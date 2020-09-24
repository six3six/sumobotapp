import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sumobot/loby.dart';

import 'main.dart';

final double paddingInput = 25;

TextStyle fieldTheme = TextStyle(color: Colors.white);

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  FirebaseAuth auth = FirebaseAuth.instance;

  var register = false;
  int _selectedIndex = 0;
  String errorMessage = "";
  bool connected = false;

  LoginState() : super() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        setState(() {
          connected = false;
        });
      } else {
        setState(() {
          Crashlytics.instance.setUserEmail(user.email);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Lobby()));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Colors.redAccent[700], Colors.red[700]])),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: double.infinity),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: 700),
                padding: EdgeInsets.symmetric(horizontal: 30)
                    .add(EdgeInsets.only(top: 50)),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: paddingInput),
                      child: Image.asset("assets/sumobot_blanc.png"),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        errorMessage,
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .merge(TextStyle(color: Colors.red[800])),
                      ),
                    ),
                    [LoginForm(), RegisterForm()].elementAt(_selectedIndex),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            title: Text('Se connecter'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sentiment_very_satisfied),
            title: Text('S\'inscire'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  LoginFormState({Key key}) : super();

  final _formKey = GlobalKey<FormState>();

  final emailInputController = TextEditingController();
  final passwordInputController = TextEditingController();

  String emailErrorLabel;
  String passwordErrorLabel;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: paddingInput),
          child: TextFormField(
            controller: emailInputController,
            autocorrect: false,
            style: fieldTheme,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: emailErrorLabel,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: paddingInput),
          child: TextFormField(
            controller: passwordInputController,
            style: fieldTheme,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              errorText: passwordErrorLabel,
            ),
          ),
        ),
        Container(height: 30),
        Container(
          padding: EdgeInsets.only(top: paddingInput),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              onPressed: () async {
                emailErrorLabel = null;
                passwordErrorLabel = null;

                var email = emailInputController.text;
                var password = passwordInputController.text;
                if (email.isEmpty)
                  setState(() {
                    emailErrorLabel = "Merci d'entrer votre email";
                  });
                if (password.isEmpty)
                  setState(() {
                    passwordErrorLabel = "Merci d'entrer votre mot de passe";
                  });
                if (email.isEmpty || password.isEmpty) return;

                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email, password: password);
                  analytics.logSignUp(signUpMethod: "password");
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    setState(() {
                      emailErrorLabel = 'Cette email n\'est pas inscrite';
                    });
                  } else if (e.code == 'wrong-password') {
                    setState(() {
                      passwordErrorLabel = 'Le mot de passe est incorrect';
                    });
                  } else if (e.code == "invalid-email") {
                    setState(() {
                      emailErrorLabel = "L'email semble mal formé";
                    });
                  } else {
                    print(e.code);
                  }
                } catch (e) {
                  print(e.toString());
                }
              },
              textColor: Colors.white,
              child: Text('Se connecter'),
            ),
          ),
        ),
        Container(height: 30),
      ]),
    );
  }
}

class RegisterForm extends StatefulWidget {
  RegisterForm({Key key}) : super(key: key);

  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  RegisterFormState({Key key}) : super();

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confPasswordController = TextEditingController();
  final nameController = TextEditingController();

  String emailError;
  String passwordError;
  String nameError;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: paddingInput),
          child: TextFormField(
            controller: nameController,
            style: fieldTheme,
            decoration: InputDecoration(
              labelText: 'Nom',
              errorText: nameError,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: paddingInput),
          child: TextFormField(
            controller: emailController,
            style: fieldTheme,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: emailError,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: paddingInput),
          child: TextFormField(
            controller: passwordController,
            style: fieldTheme,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              errorText: passwordError,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: paddingInput),
          child: TextFormField(
            controller: confPasswordController,
            style: fieldTheme,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Mot de passe',
            ),
          ),
        ),
        Container(height: 30),
        Container(
          padding: EdgeInsets.only(top: paddingInput),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              onPressed: () async {
                emailError = null;
                passwordError = null;

                var email = emailController.text;
                var password = passwordController.text;
                var name = nameController.text;

                if (email.isEmpty) {
                  emailError = "Merci de rentrer votre email";
                }
                if (password.isEmpty) {
                  passwordError = "Merci de rentrer votre mot de passe";
                }
                if (name.isEmpty) {
                  nameError = "Merci de rentrer votre nom";
                }
                if (email.isEmpty || password.isEmpty || name.isEmpty) return;

                if (password != confPasswordController.text) {
                  setState(() {
                    passwordError = "Les mots de passes ne correspondent pas";
                  });
                  return;
                }

                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(userCredential.user.uid)
                      .set({
                    "name": name,
                    "email": email,
                    "admin": false,
                  });
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    setState(() {
                      passwordError = "Le mot de passe est trop faible";
                    });
                  } else if (e.code == 'email-already-in-use') {
                    setState(() {
                      emailError = "Cette email est déjà inscrite";
                    });
                  } else if (e.code == "invalid-email") {
                    setState(() {
                      emailError = "Email invalide";
                    });
                  } else {
                    print(e.code);
                  }
                } catch (e) {
                  print(e.toString());
                }
              },
              textColor: Colors.white,
              child: Text('S\'inscire'),
            ),
          ),
        ),
        Container(height: 30),
      ]),
    );
  }
}
