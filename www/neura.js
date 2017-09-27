var exec = require('cordova/exec');

module.exports = {
    init : function(appUid, appSecret, success, error) {
        exec(success, error, "neura", "init", [{appUid: appUid, appSecret :appSecret}]);
    },
    authenticate : function(permissions, phone, success, error) {
        exec(success, error, "neura", "authenticate", [{permissions: permissions, phone: phone}]);
    },
    anonymousAuthenticate : function(pushToken, success, error) {
            exec(success, error, "neura", "anonymousAuthenticate", [{pushToken:pushToken}]);
    },
    forgetMe : function(showAreYouSureDialog, success, error) {
        exec(success, error, "neura", "forgetMe", [showAreYouSureDialog]);
    },
    getSubscriptions : function(success, error) {
        exec(success, error, "neura", "getSubscriptions", []);
    },
    subscribeToEvent : function(eventName, webHookId, neuraSendEventViaPush, success, error) {
        exec(success, error, "neura", "subscribeToEvent", [eventName, webHookId, neuraSendEventViaPush]);
    },
    removeSubscription : function(eventName, eventIdentifier, neuraSendEventViaPush, success, error) {
        exec(success, error, "neura", "removeSubscription", [eventName, eventIdentifier, neuraSendEventViaPush]);
    },
    shouldSubscribeToEvent : function(eventName, success, error) {
        exec(success, error, "neura", "shouldSubscribeToEvent", [eventName]);
    },
    getAppPermissions : function(success, error) {
        exec(success, error, "neura", "getAppPermissions", []);
    },
    getPermissionStatus : function(permissionsArray, success, error) {
        exec(success, error, "neura", "getPermissionStatus", permissionsArray);
    },
    enableLogFile : function(enableLogFile, success, error) {
        exec(success, error, "neura", "enableLogFile", [enableLogFile]);
    },
    enableNeuraHandingStateAlertMessages : function(enableNeuraHandingStateAlertMessages, success, error) {
        exec(success, error, "neura", "enableNeuraHandingStateAlertMessages", [enableNeuraHandingStateAlertMessages]);
    },
    getSdkVersion : function(success, error) {
        exec(success, error, "neura", "getSdkVersion", []);
    },
    isMissingDataForEvent : function(eventName, success, error) {
        exec(success, error, "neura", "isMissingDataForEvent", [eventName]);
    },
    getMissingDataForEvent : function(eventName, success, error) {
        exec(success, error, "neura", "getMissingDataForEvent", [eventName]);
    },
    getKnownDevices : function(success, error) {
        exec(success, error, "neura", "getKnownDevices", []);
    },
    getKnownCapabilities : function(success, error) {
        exec(success, error, "neura", "getKnownCapabilities", []);
    },
    hasDeviceWithCapability : function(capabilityName, success, error) {
        exec(success, error, "neura", "hasDeviceWithCapability", [capabilityName]);
    },
    addDevice : function(success, error) {
        exec(success, error, "neura", "addDevice", []);
    },
    addDeviceByCapabilities : function(deviceCapabilityNamesArray, success, error) {
        exec(success, error, "neura", "addDeviceByCapabilities", deviceCapabilityNamesArray);
    },
    addDeviceByName : function(deviceName, success, error) {
        exec(success, error, "neura", "addDeviceByName", [deviceName]);
    },
    getUserDetails : function(success, error) {
        exec(success, error, "neura", "getUserDetails", []);
    },
    getUserPhone : function(success, error) {
        exec(success, error, "neura", "getUserPhone", []);
    },
    getUserSituation : function(timestamp, success, error) {
        exec(success, error, "neura", "getUserSituation", [timestamp]);
    },
    simulateAnEvent : function(success, error) {
        exec(success, error, "neura", "simulateAnEvent", []);
    },
    isLoggedIn : function(success, error) {
        exec(success, error, "neura", "isLoggedIn", []);
    },
    registerFirebaseToken : function(token, success, error) {
        exec(success, error, "neura", "registerFirebaseToken", [token]);
    },
    getUserPlaceByLabelType : function(placeLabelType, success, error) {
        exec(success, error, "neura", "getUserPlaceByLabelType", [placeLabelType]);
    },
    getDailySummary : function(timestamp, success, error) {
        exec(success, error, "neura", "getDailySummary", [timestamp]);
    },
    getSleepProfile : function(startTimestamp, endTimestamp, success, error) {
        exec(success, error, "neura", "getSleepProfile", [startTimestamp, endTimestamp]);
    }
};
