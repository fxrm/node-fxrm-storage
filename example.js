
var Q = require('kew');

function Email(str) {
    if (str.length < 3 || str.indexOf('@') === -1) {
        throw new Error('EMAIL_FORMAT');
    }

    this.value = str;
}

Email.prototype.__toString = function () {
    return this.value;
};

function PasswordHash(str) {
    if (str.length < 6) {
        throw new Error('PASSWORD_LENGTH');
    }

    throw 'not implemented';
}

PasswordHash.prototype.check = function (str) {
    throw 'not implemented';
};

function UserId() {
}

function SessionId() {
}

function Application(storage) {
    this.storage = storage;
}

Application.prototype.findUserByEmail = function (email) {
    return this.storage.find(UserId, { email: email });
};

Application.prototype.findAllUsersByEmail = function (email) {
    return this.storage.findAll(UserId, { email: email });
};

Application.prototype.getUserPasswordHash = function (userId) {
    return this.storage.get(userId, { passwordHash: PasswordHash });
};

Application.prototype.initializeSession = function (sessionId, sessionKey, userId, time) {
    this.storage.set(sessionId, { sessionKey: sessionKey, userId: userId, time: time });
};

Application.prototype.setUserLastSession = function (userId, lastSessionId) {
    this.storage.set(userId, { lastSessionId: lastSessionId });
};

Application.prototype.checkUserPassword = function (userId, password) {
    return this.getUserPasswordHash(userId).check(password);
};

Application.prototype.login = function (email, password) {
    var sessionUserId;

    return this.findUserByEmail(email).then(function (userId) {
        sessionUserId = userId;

        return userId ? this.getUserPasswordHash(userId) : null;
    }).then(function (passwordHash) {
        var sessionId = new SessionId(),
            sessionKey;

        if (!passwordHash || !passwordHash.check(password)) {
            throw new Error('LOGIN_CREDENTIALS');
        }

        return Q.nfcall(crypto.randomBytes, 18);
    }).then(function (sessionKeyBuf) {
        var sessionKey = sessionKeyBuf.toString('base64');

        this.initializeSession(sessionId, sessionKey, sessionUserId, Date.now());
        this.setUserLastSession(sessionUserId, sessionId);

        return sessionKey;
    });
};
