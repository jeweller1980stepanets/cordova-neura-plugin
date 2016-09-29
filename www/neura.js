var exec = require('cordova/exec');

exports.init = function(appUid, appSecret, success, error) {
    exec(success, error, "neura", "init", [appUid, appSecret]);
};

exports.authenticate = function(permissionsArray, success, error) {
    exec(success, error, "neura", "authenticate", permissionsArray);
};

exports.forgetMe = function(showAreYouSureDialog, success, error) {
    exec(success, error, "neura", "forgetMe", [showAreYouSureDialog]);
};

exports.registerPushServerApiKey = function(googleApiConsoleProjectNumber, success, error) {
    exec(success, error, "neura", "registerPushServerApiKey", [googleApiConsoleProjectNumber]);
};

exports.getSubscriptions = function(success, error) {
    exec(success, error, "neura", "getSubscriptions", []);
};

exports.subscribeToEvent = function(eventName, eventIdentifier, neuraSendEventViaPush, success, error) {
    exec(success, error, "neura", "subscribeToEvent", [eventName, eventIdentifier, neuraSendEventViaPush]);
};

exports.removeSubscription = function(eventName, eventIdentifier, neuraSendEventViaPush, success, error) {
    exec(success, error, "neura", "removeSubscription", [eventName, eventIdentifier, neuraSendEventViaPush]);
};

exports.shouldSubscribeToEvent = function(eventName, success, error) {
    exec(success, error, "neura", "shouldSubscribeToEvent", [eventName]);
};

exports.getAppPermissions = function(success, error) {
    exec(success, error, "neura", "getAppPermissions", []);
};

exports.getPermissionStatus = function(permissionsArray, success, error) {
    exec(success, error, "neura", "getPermissionStatus", permissionsArray);
};

exports.enableLogFile = function(enableLogFile, success, error) {
    exec(success, error, "neura", "enableLogFile", [enableLogFile]);
};

exports.enableAutomaticallySyncLogs = function(enableAutomaticallySyncLogs, success, error) {
    exec(success, error, "neura", "enableAutomaticallySyncLogs", [enableAutomaticallySyncLogs]);
};

exports.enableNeuraHandingStateAlertMessages = function(enableNeuraHandingStateAlertMessages, success, error) {
    exec(success, error, "neura", "enableNeuraHandingStateAlertMessages", [enableNeuraHandingStateAlertMessages]);
};

exports.getSdkVersion = function(success, error) {
    exec(success, error, "neura", "getSdkVersion", []);
};

exports.isMissingDataForEvent = function(eventName, success, error) {
    exec(success, error, "neura", "isMissingDataForEvent", [eventName]);
};

exports.getMissingDataForEvent = function(eventName, success, error) {
    exec(success, error, "neura", "getMissingDataForEvent", [eventName]);
};

exports.getKnownDevices = function(success, error) {
    exec(success, error, "neura", "getKnownDevices", []);
};

exports.getKnownCapabilities = function(success, error) {
    exec(success, error, "neura", "getKnownCapabilities", []);
};

exports.hasDeviceWithCapability = function(capabilityName, success, error) {
    exec(success, error, "neura", "hasDeviceWithCapability", [capabilityName]);
};

exports.addDevice = function(success, error) {
    exec(success, error, "neura", "addDevice", []);
};

exports.addDeviceByCapabilities = function(deviceCapabilityNamesArray, success, error) {
    exec(success, error, "neura", "addDeviceByCapabilities", deviceCapabilityNamesArray);
};

exports.addDeviceByName = function(deviceName, success, error) {
    exec(success, error, "neura", "addDeviceByName", [deviceName]);
};

exports.getUserDetails = function(success, error) {
    exec(success, error, "neura", "getUserDetails", []);
};

exports.getUserPhone = function(success, error) {
    exec(success, error, "neura", "getUserPhone", []);
};

exports.getUserSituation = function(timestamp, success, error) {
    exec(success, error, "neura", "getUserSituation", [timestamp]);
};

exports.simulateAnEvent = function(success, error) {
    exec(success, error, "neura", "simulateAnEvent", []);
};