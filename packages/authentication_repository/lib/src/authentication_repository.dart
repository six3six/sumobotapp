import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import 'models/models.dart';

class AuthenticationException implements Exception {
  final String? message;

  const AuthenticationException({this.message});

  @override
  String toString() {
    return message ?? "";
  }
}

/// Thrown if during the sign up process if a failure occurs.
class SignUpFailure extends AuthenticationException {
  SignUpFailure(String message) : super(message: message);
}

/// Thrown during the login process if a failure occurs.
class LogInWithEmailAndPasswordFailure extends AuthenticationException {
  LogInWithEmailAndPasswordFailure(String message) : super(message: message);
}

/// Thrown during the sign in with google process if a failure occurs.
class LogInWithGoogleFailure extends AuthenticationException {
  LogInWithGoogleFailure(String message) : super(message: message);
}

class LogInWithAppleFailure extends AuthenticationException {
  LogInWithAppleFailure(String message) : super(message: message);
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure extends AuthenticationException {
  LogOutFailure(String message) : super(message: message);
}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _firestore = firestore ?? FirebaseFirestore.instance {
    user.map((user) => currentUser = user);
  }

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  User currentUser = User.empty;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user async* {
    final Stream<firebase_auth.User?> stream = _firebaseAuth.authStateChanges();
    await for (firebase_auth.User? firebaseUser in stream) {
      yield firebaseUser == null ? User.empty : await firebaseUser.toUser;
    }
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpFailure] if an exception occurs.
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await addUserInDatabase(userCredential.user?.uid ?? "", name, email);
    } on Exception {
      throw SignUpFailure("Authentication error (unknown issue)");
    }
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null)
        throw LogInWithGoogleFailure("Google returns null user");
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final firebase_auth.OAuthCredential credential =
          firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      var user = userCredential.user;
      if (user == null)
        throw LogInWithGoogleFailure("Null user from credential");
      if (!await userExistInDatabase(user.uid))
        addUserInDatabase(
            user.uid, googleUser.displayName ?? "", googleUser.email);
    } catch (e) {
      print(e);
      throw LogInWithGoogleFailure("This error $e");
    }
  }

  Future<bool> logInWithAppleAvailable() async {
    return await TheAppleSignIn.isAvailable();
  }

  /// Starts the Sign In with Apple Flow.
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithApple() async {
    try {
      final appleCredential = await TheAppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      final appleIdCredential = appleCredential.credential;
      if (appleIdCredential == null)
        throw LogInWithAppleFailure("Google returns null user");

      final firebase_auth.OAuthCredential credential =
          firebase_auth.OAuthCredential(
        providerId: "apple.com",
        signInMethod: "apple.com",
        idToken: String.fromCharCodes(appleIdCredential.identityToken ?? []),
        accessToken:
            String.fromCharCodes(appleIdCredential.authorizationCode ?? []),
      );

      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      userCredential.user?.updateDisplayName(
          appleIdCredential.fullName?.givenName ??
              "" + " " + (appleIdCredential.fullName?.familyName ?? ""));
      var user = userCredential.user;
      if (user == null)
        throw LogInWithAppleFailure("Null user from credential");
      if (!await userExistInDatabase(user.uid))
        addUserInDatabase(
            user.uid,
            appleIdCredential.fullName?.givenName ??
                "" + " " + (appleIdCredential.fullName?.familyName ?? ""),
            appleIdCredential.email ?? "");
    } catch (e) {
      print(e);
      throw LogInWithAppleFailure("This error $e");
    }
  }

  Future<void> addUserInDatabase(
      String userUid, String name, String email) async {
    await _firestore.collection("users").doc(userUid).set({
      "name": name,
      "email": email,
    });
  }

  Future<bool> userExistInDatabase(String userUid) async {
    DocumentSnapshot doc =
        await _firestore.collection("users").doc(userUid).get();
    return doc.exists;
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print(e);
      throw LogInWithEmailAndPasswordFailure("This error $e");
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _googleSignIn.disconnect(),
        _firebaseAuth.signOut(),
      ]);
    } catch (e) {
      print(e);
      throw LogOutFailure("This error : $e");
    }
  }

  Future<void> changePassword(String newPassword) async {
    await _firebaseAuth.currentUser?.updatePassword(newPassword);
  }

  Future<bool> getUserRole(String uid) async {
    bool admin = false;
    final DocumentSnapshot admins = await FirebaseFirestore.instance
        .collection("roles")
        .doc("admins")
        .get();
    if (admins.get(uid) == null)
      admin = false;
    else
      admin = true;
    return admin;
  }

  Future<User> getUserFromUid(String uid) async {
    final DocumentSnapshot snapshot =
        await _firestore.collection("users").doc(uid).get();

    if (!snapshot.exists) return User.empty;
    final data = snapshot.data();
    return User(
      email: snapshot.get("email") as String? ?? "",
      id: uid,
      admin: await getUserRole(uid),
      name: snapshot.get("name") as String? ?? "",
      photo: null,
    );
  }
}

extension on firebase_auth.User {
  Future<User> get toUser async {
    bool admin = false;
    final DocumentSnapshot admins = await FirebaseFirestore.instance
        .collection("roles")
        .doc("admins")
        .get();

    if (admins.get(uid) == null)
      admin = false;
    else
      admin = true;

    String name = "";
    try {
      DocumentSnapshot user =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      name = user.get("name");
    } catch (e) {
      name = displayName ?? "";
    }

    return User(
        id: uid, admin: admin, email: email ?? "", name: name, photo: photoURL);
  }
}
