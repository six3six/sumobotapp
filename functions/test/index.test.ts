// tslint:disable-next-line:no-implicit-dependencies

/*
const test = require('firebase-functions-test')({
    databaseURL: 'https://sumobot-1ec17.firebaseio.com',
    storageBucket: 'sumobot-1ec17.appspot.com',
    projectId: 'sumobot-1ec17',
}, 'serviceAccountKey.json');
*/
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
});
