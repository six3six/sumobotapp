// tslint:disable-next-line:no-implicit-dependencies
import * as admin from "firebase-admin";

const test = require('firebase-functions-test')({
    databaseURL: 'https://sumobot-1ec17.firebaseio.com',
    storageBucket: 'sumobot-1ec17.appspot.com',
    projectId: 'sumobot-1ec17',
}, 'serviceAccountKey.json');

// tslint:disable-next-line:no-implicit-dependencies
import 'mocha';

const index = require("../src");


describe('UserIsAdmin', () => {
    it('should respond true', function (done) {
        if (index.UserIsAdmin("0419J5LGfbe6d8dTM3o2afsoUDF2")) done();
        else done("User is not admin")
    });
    it('should respond false', function (done) {
        if (index.UserIsAdmin("55555")) done();
        else done("User is admin")
    });
})

describe('Create user', () => {
    const wrapped = test.wrap(index.addUser);
    it("shouldn't be created", function (done) {
        const user = test.firestore.makeDocumentSnapshot({test: 'faz'}, "users/5555");
        const change = test.makeChange(test.firestore.makeDocumentSnapshot(), user);
        const newUser = wrapped(change);
        if (newUser.DocumentSnapshot !== user) done();
        else done("User created");
    });

    it("should not be admin", function (done) {
        const user = test.firestore.makeDocumentSnapshot({
            email: "test.test@test.test",
            name: "test TEST",
            admin: true
        }, "users/465454");
        const change = test.makeChange(test.firestore.makeDocumentSnapshot(), user);
        wrapped(change).then(async () => {
            const value = await admin.firestore().doc("users/465454").get();
            if (value.data()?.email === user.data()?.email && value.data()?.name === user.data()?.name && value.data()?.admin === false) done();
            else done("Bad user data returned");
        });
    });

    it("should not be admin", function (done) {
        const user = test.firestore.makeDocumentSnapshot({
            email: "test.test@test.test",
            name: "test TEST",
            admin: false
        }, "users/465454");
        const change = test.makeChange(test.firestore.makeDocumentSnapshot(), user);
        wrapped(change).then(async () => {
            const value = await admin.firestore().doc("users/465454").get();
            if (value.data()?.email === user.data()?.email && value.data()?.name === user.data()?.name && value.data()?.admin === false) done();
            else done("Bad user data returned");
        });

    });

    it("should be admin", function (done) {
        const user = test.firestore.makeDocumentSnapshot({
            email: "test.test@test.test",
            name: "test TEST",
            admin: true
        }, "users/465454");
        const change = test.makeChange(test.firestore.makeDocumentSnapshot(), user);
        wrapped(change).then(async () => {
            const value = await admin.firestore().doc("users/465454").get();
            if (value.data()?.email === user.data()?.email && value.data()?.name === user.data()?.name && value.data()?.admin === false) done();
            else done("Bad user data returned");
        });

    });

});
