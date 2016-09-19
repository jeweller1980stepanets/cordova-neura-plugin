package com.neura.cordova.plugin;

import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.os.RemoteException;
import android.support.annotation.NonNull;
import android.util.Log;

import com.neura.resources.authentication.AuthenticateCallback;
import com.neura.resources.authentication.AuthenticateData;
import com.neura.resources.data.PickerCallback;
import com.neura.resources.device.Capability;
import com.neura.resources.device.DevicesRequestCallback;
import com.neura.resources.device.DevicesResponseData;
import com.neura.resources.situation.SituationCallbacks;
import com.neura.resources.situation.SituationData;
import com.neura.resources.situation.SubSituationData;
import com.neura.resources.user.UserDetails;
import com.neura.resources.user.UserDetailsCallbacks;
import com.neura.resources.user.UserPhone;
import com.neura.resources.user.UserPhoneCallbacks;
import com.neura.sdk.callbacks.GetPermissionsRequestCallbacks;
import com.neura.sdk.object.AppSubscription;
import com.neura.sdk.object.AuthenticationRequest;
import com.neura.sdk.object.Permission;
import com.neura.sdk.service.GetSubscriptionsCallbacks;
import com.neura.sdk.service.SubscriptionRequestCallbacks;
import com.neura.standalonesdk.service.NeuraApiClient;
import com.neura.standalonesdk.util.Builder;
import com.neura.standalonesdk.util.SDKUtils;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class neura extends CordovaPlugin {

    private static final String TAG = "neura-plugin";

    private static final int ERROR_CODE_UNKNOWN_ERROR = -1;
    private static final int ERROR_CODE_INVALID_ARGS = -2;

    private NeuraApiClient mNeuraApiClient;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        android.util.Log.d(TAG, "execute() called with: " + "action = [" + action + "], args = [" + args + "], callbackContext = [" + callbackContext + "]");

        try {
            if (action.equals("init")) {
                this.init(args, callbackContext);
                return true;
            } else if (action.equals("authenticate")) {
                this.authenticate(args, callbackContext);
                return true;
            } else if (action.equals("registerPushServerApiKey")) {
                this.registerPushServerApiKey(args, callbackContext);
                return true;
            } else if (action.equals("forgetMe")) {
                this.forgetMe(args, callbackContext);
                return true;
            } else if (action.equals("getSubscriptions")) {
                this.getSubscriptions(args, callbackContext);
                return true;
            } else if (action.equals("subscribeToEvent")) {
                this.subscribeToEvent(args, callbackContext);
                return true;
            } else if (action.equals("removeSubscription")) {
                this.removeSubscription(args, callbackContext);
                return true;
            } else if (action.equals("shouldSubscribeToEvent")) {
                this.shouldSubscribeToEvent(args, callbackContext);
                return true;
            } else if (action.equals("getAppPermissions")) {
                this.getAppPermissions(args, callbackContext);
                return true;
            } else if (action.equals("getPermissionStatus")) {
                this.getPermissionStatus(args, callbackContext);
                return true;
            } else if (action.equals("enableLogFile")) {
                this.enableLogFile(args, callbackContext);
                return true;
            } else if (action.equals("enableAutomaticallySyncLogs")) {
                this.enableAutomaticallySyncLogs(args, callbackContext);
                return true;
            } else if (action.equals("enableNeuraHandingStateAlertMessages")) {
                this.enableNeuraHandingStateAlertMessages(args, callbackContext);
                return true;
            } else if (action.equals("sendLog")) {
                this.sendLog(args, callbackContext);
                return true;
            } else if (action.equals("getSdkVersion")) {
                this.getSdkVersion(args, callbackContext);
                return true;
            } else if (action.equals("isMissingDataForEvent")) {
                this.isMissingDataForEvent(args, callbackContext);
                return true;
            } else if (action.equals("getMissingDataForEvent")) {
                this.getMissingDataForEvent(args, callbackContext);
                return true;
            } else if (action.equals("getKnownDevices")) {
                this.getKnownDevices(args, callbackContext);
                return true;
            } else if (action.equals("getKnownCapabilities")) {
                this.getKnownCapabilities(args, callbackContext);
                return true;
            } else if (action.equals("hasDeviceWithCapability")) {
                this.hasDeviceWithCapability(args, callbackContext);
                return true;
            } else if (action.equals("addDevice")) {
                this.addDevice(args, callbackContext);
                return true;
            } else if (action.equals("addDeviceByCapabilities")) {
                this.addDeviceByCapabilities(args, callbackContext);
                return true;
            } else if (action.equals("addDeviceByName")) {
                this.addDeviceByName(args, callbackContext);
                return true;
            } else if (action.equals("getUserDetails")) {
                this.getUserDetails(args, callbackContext);
                return true;
            } else if (action.equals("getUserPhone")) {
                this.getUserPhone(args, callbackContext);
                return true;
            } else if (action.equals("getUserSituation")) {
                this.getUserSituation(args, callbackContext);
                return true;
            } else if (action.equals("simulateAnEvent")) {
                this.simulateAnEvent(args, callbackContext);
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();

            callbackContext.error(ERROR_CODE_UNKNOWN_ERROR);
        }

        return false;
    }

    private void init(final JSONArray args, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                Builder builder = new Builder(cordova.getActivity());

                mNeuraApiClient = builder.build();

                try {
                    String appUid = args.getString(0);
                    String appSecret = args.getString(1);

                    if (appUid == null || appSecret == null) {
                        Log.e(TAG, "init: invalid app UID or app secret");

                        callbackContext.error(ERROR_CODE_INVALID_ARGS);
                        return;
                    }

                    mNeuraApiClient.setAppUid(appUid);
                    mNeuraApiClient.setAppSecret(appSecret);

                    Log.d(TAG, "appUid = [" + appUid + "], appSecret = [" + appSecret + "]");

                    Looper.prepare();
                    mNeuraApiClient.connect();

                    callbackContext.success();
                } catch (JSONException e) {
                    e.printStackTrace();
                    callbackContext.error(ERROR_CODE_INVALID_ARGS);
                } catch (Exception e) {
                    e.printStackTrace();
                    callbackContext.error(ERROR_CODE_UNKNOWN_ERROR);
                }
            }
        });
    }

    private void authenticate(final JSONArray permissions, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                if (permissions == null || permissions.length() == 0) {
                    Log.e(TAG, "authenticate: permissions are null or empty");

                    callbackContext.error(ERROR_CODE_INVALID_ARGS);
                    return;
                }

                if (!SDKUtils.isConnected(cordova.getActivity(), mNeuraApiClient)) {
                    AuthenticationRequest authenticationRequest = new AuthenticationRequest();

                    ArrayList<Permission> permissionsArrayList;
                    try {
                        permissionsArrayList = getPermissionsArrayList(permissions);
                    } catch (JSONException e) {
                        e.printStackTrace();

                        callbackContext.error(ERROR_CODE_INVALID_ARGS);

                        return;
                    }

                    authenticationRequest.setPermissions(permissionsArrayList);

                    mNeuraApiClient.authenticate(authenticationRequest, new AuthenticateCallback() {
                        @Override
                        public void onSuccess(AuthenticateData authenticateData) {
                            Log.d(TAG, "authenticate.onSuccess() called with: " + "token = [" + authenticateData.getAccessToken() + "], neuraUserId = [" + authenticateData.getNeuraUserId() + "]");

                            callbackContext.success();
                        }

                        @Override
                        public void onFailure(int errorCode) {
                            Log.d(TAG, "authenticate.onFailure() called with: " + "errorCode = [" + errorCode + "]");

                            callbackContext.error(errorCode);
                        }
                    });
                } else {
                    // Already authenticated. return success
                    Log.d(TAG, "authenticate: Already authenticated");

                    callbackContext.success();
                }
            }
        });
    }

    private void registerPushServerApiKey(JSONArray args, CallbackContext callbackContext) {
        try {
            String googleApiConsoleProjectNumber = args.getString(0);
            mNeuraApiClient.registerPushServerApiKey(cordova.getActivity(), googleApiConsoleProjectNumber);

            callbackContext.success();
        } catch (JSONException e) {
            e.printStackTrace();

            callbackContext.error(ERROR_CODE_INVALID_ARGS);
        }
    }

    private void forgetMe(JSONArray args, final CallbackContext callbackContext) {
        boolean showAreYouSureDialog;
        try {
            showAreYouSureDialog = args.getBoolean(0);
        } catch (JSONException e) {
            e.printStackTrace();

            callbackContext.error(ERROR_CODE_INVALID_ARGS);
            return;
        }

        mNeuraApiClient.forgetMe(cordova.getActivity(), showAreYouSureDialog, new Handler.Callback() {
            @Override
            public boolean handleMessage(Message msg) {
                callbackContext.success();
                return true;
            }
        });
    }

    private void getSubscriptions(@SuppressWarnings("UnusedParameters") JSONArray args, final CallbackContext callbackContext) {
        mNeuraApiClient.getSubscriptions(new GetSubscriptionsCallbacks() {
            @Override
            public void onSuccess(List<AppSubscription> list) {
                JSONArray subscriptionsJsonArray = new JSONArray();
                if (list != null) {
                    for (AppSubscription currSubscription : list) {
                        subscriptionsJsonArray.put(currSubscription.toJson());
                    }
                }

                callbackContext.success(subscriptionsJsonArray);
            }

            @Override
            public void onFailure(Bundle bundle, int errorCode) {
                callbackContext.error(errorCode);
            }
        });
    }

    private void subscribeToEvent(JSONArray args, final CallbackContext callbackContext) {
        try {
            String eventName = args.getString(0);
            String eventIdentifier = args.getString(1);
            boolean neuraSendEventViaPush = args.getBoolean(2);

            mNeuraApiClient.subscribeToEvent(eventName, eventIdentifier, neuraSendEventViaPush, new SubscriptionRequestCallbacks() {
                @Override
                public void onSuccess(String eventName, Bundle resultData, String identifier) {
                    callbackContext.success(eventName);
                }

                @Override
                public void onFailure(String eventName, Bundle resultData, int errorCode) {
                    callbackContext.error(errorCode);
                }
            });
        } catch (JSONException e) {
            e.printStackTrace();

            callbackContext.error(ERROR_CODE_INVALID_ARGS);
        }
    }

    private void removeSubscription(JSONArray args, final CallbackContext callbackContext) {
        try {
            String eventName = args.getString(0);
            String eventIdentifier = args.getString(1);
            boolean neuraSendEventViaPush = args.getBoolean(2);

            mNeuraApiClient.removeSubscription(eventName, eventIdentifier, neuraSendEventViaPush, new SubscriptionRequestCallbacks() {
                @Override
                public void onSuccess(String eventName, Bundle resultData, String identifier) {
                    callbackContext.success(eventName);
                }

                @Override
                public void onFailure(String eventName, Bundle resultData, int errorCode) {
                    callbackContext.error(errorCode);
                }
            });
        } catch (JSONException e) {
            e.printStackTrace();

            callbackContext.error(ERROR_CODE_INVALID_ARGS);
        }
    }

    private void shouldSubscribeToEvent(JSONArray args, CallbackContext callbackContext) {
        try {
            String eventName = args.getString(0);
            boolean shouldSubscribeToEvent = mNeuraApiClient.shouldSubscribeToEvent(eventName);

            callbackContext.success(Boolean.toString(shouldSubscribeToEvent));
        } catch (JSONException e) {
            e.printStackTrace();

            callbackContext.error(ERROR_CODE_INVALID_ARGS);
        }
    }

    private void getAppPermissions(@SuppressWarnings("UnusedParameters") JSONArray args, final CallbackContext callbackContext) {
        mNeuraApiClient.getAppPermissions(new GetPermissionsRequestCallbacks() {
            @Override
            public void onSuccess(List<Permission> permissions) throws RemoteException {
                JSONArray permissionsJsonArray = getPermissionsJsonArray(permissions);

                callbackContext.success(permissionsJsonArray);
            }

            @Override
            public void onFailure(Bundle resultData, int errorCode) throws RemoteException {
                callbackContext.error(errorCode);
            }

            @Override
            public IBinder asBinder() {
                return null;
            }
        });
    }

    private void getPermissionStatus(JSONArray permissions, CallbackContext callbackContext) {
        if (permissions == null) {
            callbackContext.error(ERROR_CODE_INVALID_ARGS);
            return;
        }

        ArrayList<Permission> permissionsArrayList;
        try {
            permissionsArrayList = getPermissionsArrayList(permissions);
        } catch (JSONException e) {
            e.printStackTrace();

            callbackContext.error(ERROR_CODE_INVALID_ARGS);

            return;
        }

        ArrayList<Permission> permissionsStatus = mNeuraApiClient.getPermissionStatus(permissionsArrayList);
        callbackContext.success(getPermissionsJsonArray(permissionsStatus));
    }

    private void enableLogFile(JSONArray args, CallbackContext callbackContext) {
        try {
            boolean enableLogFile = args.getBoolean(0);
            mNeuraApiClient.enableLogFile(enableLogFile);

            callbackContext.success();
        } catch (JSONException e) {
            e.printStackTrace();

            callbackContext.error(ERROR_CODE_INVALID_ARGS);
        }
    }

    private void enableAutomaticallySyncLogs(JSONArray args, CallbackContext callbackContext) {
        try {
            boolean enableAutomaticallySyncLogs = args.getBoolean(0);
            mNeuraApiClient.enableAutomaticallySyncLogs(enableAutomaticallySyncLogs);

            callbackContext.success();
        } catch (JSONException e) {
            e.printStackTrace();

            callbackContext.error(ERROR_CODE_INVALID_ARGS);
        }
    }

    private void enableNeuraHandingStateAlertMessages(JSONArray args, CallbackContext callbackContext) {
        try {
            boolean enableNeuraHandingStateAlertMessages = args.getBoolean(0);
            mNeuraApiClient.enableNeuraHandingStateAlertMessages(enableNeuraHandingStateAlertMessages);

            callbackContext.success();
        } catch (JSONException e) {
            e.printStackTrace();

            callbackContext.error(ERROR_CODE_INVALID_ARGS);
        }
    }

    private void sendLog(@SuppressWarnings("UnusedParameters") JSONArray args, CallbackContext callbackContext) {
        mNeuraApiClient.sendLog(cordova.getActivity());

        callbackContext.success();
    }

    private void getSdkVersion(@SuppressWarnings("UnusedParameters") JSONArray args, CallbackContext callbackContext) {
        String sdkVersion = mNeuraApiClient.getSdkVersion();

        callbackContext.success(sdkVersion);
    }

    private void isMissingDataForEvent(JSONArray args, CallbackContext callbackContext) {
        String eventName;
        try {
            eventName = args.getString(0);
        } catch (JSONException e) {
            e.printStackTrace();

            callbackContext.error(ERROR_CODE_INVALID_ARGS);

            return;
        }

        boolean isMissingDataForEvent = mNeuraApiClient.isMissingDataForEvent(eventName);

        callbackContext.success(Boolean.toString(isMissingDataForEvent));
    }

    private void getMissingDataForEvent(JSONArray args, CallbackContext callbackContext) {
        String eventName;
        try {
            eventName = args.getString(0);
        } catch (JSONException e) {
            e.printStackTrace();

            callbackContext.error(ERROR_CODE_INVALID_ARGS);

            return;
        }

        mNeuraApiClient.getMissingDataForEvent(eventName, new PickerCallback() {
            @Override
            public void onResult(boolean success) {
                Log.d(TAG, "getMissingDataForEvent.PickerCallback.onResult() called with: " + "success = [" + success + "]");
            }
        });

        // Return the same result as for isMissingDataForEvent
        isMissingDataForEvent(args, callbackContext);
    }

    private void getKnownDevices(@SuppressWarnings("UnusedParameters") JSONArray args, final CallbackContext callbackContext) {
        mNeuraApiClient.getKnownDevices(new DevicesRequestCallback() {
            @Override
            public void onSuccess(DevicesResponseData devicesResponseData) {
                JSONArray devicesJsonArray = new JSONArray();
//                if (devicesResponseData != null) {
//                    // TODO: Uncomment getKnownDevices iteration of devices response after added to proguard keep
//                    for (Device currDevice  : devicesResponseData.getDevices()) {
//                        devicesJsonArray.put(currDevice.toJson());
//                    }
//                }
                callbackContext.success(devicesJsonArray);
            }

            @Override
            public void onFailure(int errorCode) {
                callbackContext.error(errorCode);
            }
        });
    }

    private void getKnownCapabilities(@SuppressWarnings("UnusedParameters") JSONArray args, CallbackContext callbackContext) {
        ArrayList<Capability> knownCapabilities = mNeuraApiClient.getKnownCapabilities();

        JSONArray knownCapabilitiesJsonArray = new JSONArray();
        if (knownCapabilities != null) {
            for (Capability currCapability : knownCapabilities) {
                knownCapabilitiesJsonArray.put(currCapability.toJson());
            }
        }

        callbackContext.success(knownCapabilitiesJsonArray);
    }

    private void hasDeviceWithCapability(JSONArray args, CallbackContext callbackContext) {
        String capabilityName;
        try {
            capabilityName = args.getString(0);
        } catch (JSONException e) {
            e.printStackTrace();

            callbackContext.error(ERROR_CODE_INVALID_ARGS);

            return;
        }

        boolean hasDeviceWithCapability = mNeuraApiClient.hasDeviceWithCapability(capabilityName);
        callbackContext.success(Boolean.toString(hasDeviceWithCapability));
    }

    private void addDevice(@SuppressWarnings("UnusedParameters") JSONArray args, final CallbackContext callbackContext) {
        boolean addDeviceReturnValue = mNeuraApiClient.addDevice(new PickerCallback() {
            @Override
            public void onResult(boolean success) {
                Log.d(TAG, "addDevice.PickerCallback.onResult() called with: " + "success = [" + success + "]");

                callbackContext.success(Boolean.toString(success));
            }
        });

        if (!addDeviceReturnValue) {
            callbackContext.error(ERROR_CODE_UNKNOWN_ERROR);
        }
    }

    private void addDeviceByCapabilities(JSONArray deviceCapabilityNames, final CallbackContext callbackContext) {
        ArrayList<String> deviceCapabilityNamesArrayList = new ArrayList<String>();
        if (deviceCapabilityNames != null && deviceCapabilityNames.length() > 0) {
            for (int i = 0; i < deviceCapabilityNames.length(); i++) {
                try {
                    deviceCapabilityNamesArrayList.add(deviceCapabilityNames.getString(i));
                } catch (JSONException e) {
                    e.printStackTrace();

                    callbackContext.error(ERROR_CODE_INVALID_ARGS);

                    return;
                }
            }
        }

        boolean addDeviceReturnValue = mNeuraApiClient.addDevice(deviceCapabilityNamesArrayList, new PickerCallback() {
            @Override
            public void onResult(boolean success) {
                Log.d(TAG, "addDeviceByCapabilities.PickerCallback.onResult() called with: " + "success = [" + success + "]");

                callbackContext.success(Boolean.toString(success));
            }
        });

        if (!addDeviceReturnValue) {
            callbackContext.error(ERROR_CODE_UNKNOWN_ERROR);
        }
    }

    private void addDeviceByName(JSONArray args, final CallbackContext callbackContext) {
        String deviceName;
        try {
            deviceName = args.getString(0);
        } catch (JSONException e) {
            e.printStackTrace();

            callbackContext.error(ERROR_CODE_INVALID_ARGS);

            return;
        }

        boolean addDeviceReturnValue = mNeuraApiClient.addDevice(deviceName, new PickerCallback() {
            @Override
            public void onResult(boolean success) {
                Log.d(TAG, "addDeviceByName.PickerCallback.onResult() called with: " + "success = [" + success + "]");

                callbackContext.success(Boolean.toString(success));
            }
        });

        if (!addDeviceReturnValue) {
            callbackContext.error(ERROR_CODE_UNKNOWN_ERROR);
        }
    }

    private void getUserDetails(@SuppressWarnings("UnusedParameters") JSONArray args, final CallbackContext callbackContext) {
        mNeuraApiClient.getUserDetails(new UserDetailsCallbacks() {
            @Override
            public void onSuccess(UserDetails userDetails) {
                // TODO: Replace with toJson of UserDetails when added
                JSONObject userDetailsJson = new JSONObject();
                try {
                    userDetailsJson.put("email", userDetails.getData().getEmail());
                    userDetailsJson.put("image", userDetails.getData().getImageUrl());
                    userDetailsJson.put("name", userDetails.getData().getName());
                    userDetailsJson.put("neuraId", userDetails.getData().getNeuraId());

                    callbackContext.success(userDetailsJson);
                } catch (JSONException e) {
                    e.printStackTrace();

                    callbackContext.error(ERROR_CODE_UNKNOWN_ERROR);
                }
            }

            @Override
            public void onFailure(Bundle bundle, int errorCode) {
                callbackContext.error(errorCode);
            }
        });
    }

    private void getUserPhone(@SuppressWarnings("UnusedParameters") JSONArray args, final CallbackContext callbackContext) {
        mNeuraApiClient.getUserPhone(new UserPhoneCallbacks() {
            @Override
            public void onSuccess(UserPhone userPhone) {
                callbackContext.success(userPhone.getPhone());
            }

            @Override
            public void onFailure(Bundle bundle, int errorCode) {
                callbackContext.error(errorCode);
            }
        });
    }

    private void getUserSituation(JSONArray args, final CallbackContext callbackContext) {
        if (args == null) {
            callbackContext.error(ERROR_CODE_INVALID_ARGS);
            return;
        }

        long timestamp;

        try {
            timestamp = args.getLong(0);
        } catch (JSONException e) {
            e.printStackTrace();

            callbackContext.error(ERROR_CODE_INVALID_ARGS);
            return;
        }

        mNeuraApiClient.getUserSituation(new SituationCallbacks() {
            @Override
            public void onSuccess(SituationData situationData) {
                // TODO: Replace with toJson of SituationData when added
                JSONObject situationDataJson = new JSONObject();
                try {
                    situationDataJson.put("currentSituation", convertSituationToJson(situationData.getCurrentSituation()));
                    situationDataJson.put("followingSituation", convertSituationToJson(situationData.getFollowingSituation()));
                    situationDataJson.put("previousSituation", convertSituationToJson(situationData.getPreviousSituation()));
                    situationDataJson.put("timestamp", situationData.getSituationTimestamp());
                    callbackContext.success(situationDataJson);
                } catch (JSONException e) {
                    e.printStackTrace();

                    callbackContext.error(ERROR_CODE_UNKNOWN_ERROR);
                }
            }

            @Override
            public void onFailure(Bundle bundle, int errorCode) {
                callbackContext.error(errorCode);
            }
        }, timestamp);
    }

    private JSONObject convertSituationToJson(SubSituationData subSituationData) throws JSONException {
        // TODO: Update convertSituationToJson to use SubSituationData.toJson once implemented
        JSONObject subSituationDataJson = new JSONObject();
        if (subSituationData != null) {
            subSituationDataJson.put("startTimestamp", subSituationData.getStartTimestamp());
            subSituationDataJson.put("activity", subSituationData.getActivity());
            subSituationDataJson.put("state", subSituationData.getState());

            if (subSituationData.getPlace() != null) {
                JSONObject subSituationDataPlaceJson = new JSONObject();
                subSituationDataPlaceJson.put("nearby", subSituationData.getPlace().getNearby());
                subSituationDataPlaceJson.put("semanticName", subSituationData.getPlace().getSemanticName());
                subSituationDataPlaceJson.put("semanticType", subSituationData.getPlace().getSemanticType());

                subSituationDataJson.put("place", subSituationDataPlaceJson);
            }
        }

        return subSituationDataJson;
    }

    private void simulateAnEvent(JSONArray args, CallbackContext callbackContext) {
        if (!mNeuraApiClient.simulateAnEvent()) {
            callbackContext.error(ERROR_CODE_UNKNOWN_ERROR);
        }
    }

    private ArrayList<Permission> getPermissionsArrayList(JSONArray permissions) throws JSONException {
        String[] permissionsStringArray = new String[permissions.length()];
        for (int i = 0; i < permissions.length(); i++) {
            permissionsStringArray[i] = permissions.getString(i);
        }
        return Permission.list(permissionsStringArray);
    }

    @NonNull
    private JSONArray getPermissionsJsonArray(List<Permission> permissions) {
        JSONArray permissionsJsonArray = new JSONArray();
        if (permissions != null) {
            for (Permission currPermission : permissions) {
                permissionsJsonArray.put(currPermission.toJson());
            }
        }
        return permissionsJsonArray;
    }
}