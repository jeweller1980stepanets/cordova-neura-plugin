package com.neura.cordova.plugin;

import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.os.RemoteException;
import android.support.annotation.NonNull;
import android.util.Log;

import com.neura.resources.authentication.AnonymousAuthenticateCallBack;
import com.neura.resources.authentication.AnonymousAuthenticateData;
import com.neura.resources.authentication.AnonymousAuthenticationStateListener;
import com.neura.resources.authentication.AuthenticateCallback;
import com.neura.resources.authentication.AuthenticateData;
import com.neura.resources.authentication.AuthenticationState;
import com.neura.resources.data.PickerCallback;
import com.neura.resources.device.Capability;
import com.neura.resources.device.Device;
import com.neura.resources.device.DevicesRequestCallback;
import com.neura.resources.device.DevicesResponseData;
import com.neura.resources.insights.DailySummaryCallbacks;
import com.neura.resources.insights.DailySummaryData;
import com.neura.resources.insights.SleepProfileCallbacks;
import com.neura.resources.insights.SleepProfileData;
import com.neura.resources.place.PlaceNode;
import com.neura.resources.situation.SituationCallbacks;
import com.neura.resources.situation.SituationData;
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
import com.neura.standalonesdk.events.NeuraPushCommandFactory;
import com.neura.standalonesdk.service.NeuraApiClient;
import com.neura.standalonesdk.util.Builder;
import com.neura.standalonesdk.util.SDKUtils;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import com.neura.sdk.object.AnonymousAuthenticationRequest;

public class neura extends CordovaPlugin {
    
    private static final String TAG = "neura-plugin";
    
    private static final int ERROR_CODE_UNKNOWN_ERROR = -1;
    private static final int ERROR_CODE_INVALID_ARGS = -2;
    
    private NeuraApiClient mNeuraApiClient;
    private CordovaInterface mInterface;
    
    @Override
    public void initialize(final CordovaInterface cordova, final CordovaWebView webView){
        mInterface = cordova;
        super.initialize(cordova, webView);
    }
    
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        Log.d(TAG, "execute() called with: " + "action = [" + action + "], args = [" + args + "], callbackContext = [" + callbackContext + "]");
        
        try {
            if (action.equals("init")) {
                this.init(args, callbackContext);
                return true;
            } else if (action.equals("authenticate")) {
                this.authenticate(args, callbackContext);
                return true;
            } else if (action.equals("anonymousAuthenticate")) {
                this.anonymousAuthenticate(args, callbackContext);
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
            } else if (action.equals("enableNeuraHandingStateAlertMessages")) {
                this.enableNeuraHandingStateAlertMessages(args, callbackContext);
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
            } else if (action.equals("isLoggedIn")) {
                this.isLoggedIn(args, callbackContext);
                return true;
            } else if (action.equals("registerFirebaseToken")) {
                this.registerFirebaseToken(args, callbackContext);
                return true;
            } else if (action.equals("getUserPlaceByLabelType")) {
                this.getUserPlaceByLabelType(args, callbackContext);
                return true;
            } else if (action.equals("getDailySummary")) {
                this.getDailySummary(args, callbackContext);
                return true;
            } else if (action.equals("getSleepProfile")) {
                this.getSleepProfile(args, callbackContext);
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            
            callbackContext.error(ERROR_CODE_UNKNOWN_ERROR);
        }
        
        return false;
    }
    
    private void init(final JSONArray args, final CallbackContext callbackContext) {
        
        Builder builder = new Builder(mInterface.getActivity());
        
        mNeuraApiClient = builder.build();
        
        try {
            final JSONObject params = args.getJSONObject(0);
            String appUid = params.optString("appUid", null);
            String appSecret = params.optString("appSecret", null);
            
            if (appUid == null || appSecret == null) {
                Log.e(TAG, "init: invalid app UID or app secret");
                
                callbackContext.error(ERROR_CODE_INVALID_ARGS);
                return;
            }
            
            mNeuraApiClient.setAppUid(appUid);
            mNeuraApiClient.setAppSecret(appSecret);
            
            Log.d(TAG, "appUid = [" + appUid + "], appSecret = [" + appSecret + "]");
            
            mNeuraApiClient.connect();
            
            callbackContext.success();
        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error(ERROR_CODE_INVALID_ARGS);
        } catch (Exception e) {
            e.printStackTrace();
            callbackContext.error(ERROR_CODE_UNKNOWN_ERROR);
        }
        AnonymousAuthenticationStateListener silentStateListener = new AnonymousAuthenticationStateListener() {
            @Override
            public void onStateChanged(AuthenticationState state) {

                switch (state) {
                    case AccessTokenRequested:
                        break;
                    case AuthenticatedAnonymously:
                        // successful authentication
                        mNeuraApiClient.unregisterAuthStateListener();
                        break;
                    case NotAuthenticated:
                    case FailedReceivingAccessToken:
                        // Authentication failed indefinitely. a good opportunity to retry the authentication flow
                        mNeuraApiClient.unregisterAuthStateListener();
                        break;
                    default:
                }
            }
        };
        mNeuraApiClient.registerAuthStateListener(silentStateListener);

    }
    
    private void authenticate(final JSONArray args, final CallbackContext callbackContext) {

        if (args == null)
        {
            Log.e(TAG, "authenticate: args are null");

            callbackContext.error(ERROR_CODE_INVALID_ARGS);
            return;
        }

        JSONObject params = args.optJSONObject(0);
        if (params == null)
        {
            Log.e(TAG, "authenticate: params are null");

            callbackContext.error(ERROR_CODE_INVALID_ARGS);
            return;
        }

        JSONArray permissions = params.optJSONArray("permissions");
        if (permissions == null || permissions.length() == 0) {
            Log.e(TAG, "authenticate: permissions are null or empty");

            callbackContext.error(ERROR_CODE_INVALID_ARGS);
            return;
        }

        if (!SDKUtils.isNeuraInstalledAndLoggedIn(mInterface.getActivity(), mNeuraApiClient)) {
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

            String phone = params.optString("phone", null);
            if (phone != null) {
                authenticationRequest.setPhone(phone);
            }

            Log.d(TAG, "authenticate() called with permissions = [" + permissions + "], phone = [" + phone + "]");

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

    private void anonymousAuthenticate(final JSONArray args, final CallbackContext callbackContext){

        if (args == null)
        {
            Log.e(TAG, "authenticate: args are null");

            callbackContext.error(ERROR_CODE_INVALID_ARGS);
            return;
        }

        JSONObject params = args.optJSONObject(0);
        if (params == null)
        {
            Log.e(TAG, "authenticate: params are null");

            callbackContext.error(ERROR_CODE_INVALID_ARGS);
            return;
        }

        if (!SDKUtils.isNeuraInstalledAndLoggedIn(mInterface.getActivity(), mNeuraApiClient)) {
            String pushToken = params.optString("pushToken", null);
            AnonymousAuthenticationRequest request = new AnonymousAuthenticationRequest(pushToken);

            mNeuraApiClient.authenticate(request, new AnonymousAuthenticateCallBack() {
                @Override
                public void onSuccess(AnonymousAuthenticateData authenticateData) {
                    Log.i(getClass().getSimpleName(), "Successfully requested authentication with neura. " +
                            "NeuraUserId = " + authenticateData.getNeuraUserId());
                    callbackContext.success(authenticateData.toString());
                    Log.i(TAG,String.valueOf(mNeuraApiClient.isLoggedIn()));
                }

                @Override
                public void onFailure(int errorCode) {
                    Log.e(getClass().getSimpleName(), "Failed to authenticate with neura. "
                            + "Reason : " + SDKUtils.errorCodeToString(errorCode));
                    callbackContext.error(errorCode);
                }
            });
        } else {
            // Already authenticated. return success
            Log.d(TAG, "authenticate: Already authenticated");

            callbackContext.success();
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
        
        mNeuraApiClient.forgetMe(mInterface.getActivity(), showAreYouSureDialog, new Handler.Callback() {
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

            mNeuraApiClient.subscribeToEvent(eventName, eventIdentifier, new SubscriptionRequestCallbacks() {
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
                if (devicesResponseData != null) {
                    for (Device currDevice : devicesResponseData.getDevices()) {
                        devicesJsonArray.put(currDevice.toJson());
                    }
                }
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
                callbackContext.success(userDetails.toJson());
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
                callbackContext.success(situationData.toJson());
            }
            
            @Override
            public void onFailure(Bundle bundle, int errorCode) {
                callbackContext.error(errorCode);
            }
        }, timestamp);
    }
    
    private void simulateAnEvent(@SuppressWarnings("UnusedParameters") JSONArray args, CallbackContext callbackContext) {
        if (!mNeuraApiClient.simulateAnEvent()) {
            callbackContext.error(ERROR_CODE_UNKNOWN_ERROR);
        }
    }
    
    private void isLoggedIn(@SuppressWarnings("UnusedParameters") JSONArray args, CallbackContext callbackContext) {
        boolean loggedIn = mNeuraApiClient.isLoggedIn();
        
        callbackContext.success(Boolean.toString(loggedIn));
    }
    
    private void registerFirebaseToken(JSONArray args, CallbackContext callbackContext) {
        try {
            String token = args.getString(0);
            mNeuraApiClient.registerFirebaseToken(mInterface.getActivity(), token);
            
            callbackContext.success();
        } catch (JSONException e) {
            e.printStackTrace();
            
            callbackContext.error(ERROR_CODE_INVALID_ARGS);
        }
    }
    
    private void getUserPlaceByLabelType(JSONArray args, CallbackContext callbackContext) {
        String placeLabelType;
        try {
            placeLabelType = args.getString(0);
        } catch (JSONException e) {
            e.printStackTrace();
            
            callbackContext.error(ERROR_CODE_INVALID_ARGS);
            
            return;
        }
        
        ArrayList<PlaceNode> places = mNeuraApiClient.getUserPlaceByLabelType(placeLabelType);
        JSONArray placesJsonArray = new JSONArray();
        if (places != null) {
            for (PlaceNode currPlaceNode : places) {
                placesJsonArray.put(currPlaceNode.getAddress());
            }
        }
        
        callbackContext.success(placesJsonArray);
    }
    
    private void getDailySummary(JSONArray args, final CallbackContext callbackContext) {
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
        
        mNeuraApiClient.getDailySummary(timestamp, new DailySummaryCallbacks() {
            @Override
            public void onSuccess(DailySummaryData situationData) {
                callbackContext.success(situationData.toJson());
            }
            
            @Override
            public void onFailure(Bundle bundle, int errorCode) {
                callbackContext.error(errorCode);
            }
        });
    }
    
    private void getSleepProfile(JSONArray args, final CallbackContext callbackContext) {
        if (args == null) {
            callbackContext.error(ERROR_CODE_INVALID_ARGS);
            return;
        }
        
        long startTimestamp;
        long endTimestamp;
        
        try {
            startTimestamp = args.getLong(0);
            endTimestamp = args.getLong(1);
        } catch (JSONException e) {
            e.printStackTrace();
            
            callbackContext.error(ERROR_CODE_INVALID_ARGS);
            return;
        }
        
        mNeuraApiClient.getSleepProfile(startTimestamp, endTimestamp, new SleepProfileCallbacks() {
            @Override
            public void onSuccess(SleepProfileData situationData) {
                callbackContext.success(situationData.toJson());
            }
            
            @Override
            public void onFailure(Bundle bundle, int errorCode) {
                callbackContext.error(errorCode);
            }
        });
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
