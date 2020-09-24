import * as functions from 'firebase-functions';

const firebaseAdmin = require('firebase-admin');
firebaseAdmin.initializeApp();

const db = firebaseAdmin.firestore();

export const helloWorld = functions.https.onRequest((request, response) => {
    functions.logger.info("Hello logs!", {structuredData: true});
    response.send("Hello from Firebase!");
});

export const addUser = functions.firestore.document("users/{userId}").onWrite(async (change, context) => {
    const data = change.after.data();
    const name = data?.name;
    const email = data?.email;
    const admin = data?.admin;

    if (name === undefined || email === undefined || admin === undefined) return null;

    if (admin !== false && !(await UserIsAdmin(context.auth?.uid))) {
        return change.after.ref.set({
            email: email,
            name: name,
            admin: false
        }, {merge: true});
    }

    return change.after;
});

export async function UserIsAdmin(userUid: string | undefined): Promise<boolean> {
    if (userUid === undefined) return false;
    const user = await db.doc("users/" + userUid).get();
    return user.get("admin") === true;
}

