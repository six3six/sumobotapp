import * as functions from 'firebase-functions';
import * as https from 'https';
import * as OnesignalKey from './onesignal';

const firebaseAdmin = require('firebase-admin');
firebaseAdmin.initializeApp();

const db = firebaseAdmin.firestore();

export const helloWorld = functions.https.onRequest((request, response) => {
    functions.logger.info("Hello logs!", {structuredData: true});
    response.send("Hello from Firebase!");
});

export const sendMessage = functions.https.onRequest((request, response) => {

    const message = {
        app_id: "4f82f3b1-777e-4b3d-a3cb-47f8a5585044",
        headings: {en: "En garde ! C'est l'heure du du-du-du-duel !"},
        contents: {"en": request.body.robotName + " est attendu pour combattre contre " + request.body.advRobotName},
        include_external_user_ids: [request.body.userId],
        channel_for_external_user_ids: "push",
    };

    const headers = {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization" : "Basic " + OnesignalKey.OnesignalKey
    };

    const options = {
        host: "onesignal.com",
        port: 443,
        path: "/api/v1/notifications",
        method: "POST",
        headers: headers
    };

    const req = https.request(options, function (res) {
        res.on('data', function (responseData) {
            console.log("Response:");
            console.log(responseData.toString());
        });
    });

    req.on('error', function (e) {
        console.log("ERROR:");
        console.log(e);
    });

    req.write(JSON.stringify(message));
    req.end();

    response.send("ok");
});


export async function UserIsAdmin(userUid: string | undefined): Promise<boolean> {
    if (userUid === undefined) return false;
    const user = await db.collection("roles").doc("roles").get();
    return user.get("userUid") !== undefined;
}

