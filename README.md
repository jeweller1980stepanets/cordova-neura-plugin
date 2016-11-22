# cordova-neura-plugin

This plugin is a wrapper of the <a href="https://dev.theneura.com/">Neura SDK</a> allowing you to use all its functions on a cordova app

## Installation

Install via repo url directly:

    cordova plugin add https://github.com/NeuraLabs/cordova-neura-plugin.git
    
## Sample app


The sample app included in this repo demonstrates the basic usage of the Neura SDK via this plugin.
To run the sample app please follow these steps:

## Android
    
1. Download the <a href="https://github.com/NeuraLabs/cordova-neura-plugin/blob/master/NeuraSampleCordova.zip">sample app zip file</a> and extract it
2. cd to the sample app folder
3. Add the cordova-neura-plugin as described in the <a href="https://github.com/NeuraLabs/cordova-neura-plugin/blob/master/README.md#installation">installation guide</a> above
4. Add the <a href="https://github.com/phonegap/phonegap-plugin-push">phonegap-plugin-push</a> to the sample app as described on its <a href="https://github.com/phonegap/phonegap-plugin-push/blob/master/docs/INSTALLATION.md">installation guide</a>
5. run `cordova platforms add android`
6. run `cordova run android`

## iOS

1. Add iOS platform to the application - 
	'cordova platform add ios'
2. Install 'xcode' package via 'npm'
	'npm i xcode'
3. Download <a href="https://dev.theneura.com/docs/guide/ios/setup">NeuraSDK.framework</a> and unzip the content.
4. Copy 'NeuraSDK.framework' from 'Release-universal' folder to 'path/to/cordova-plugin-neura/' folder.
5. Build cordova project - 
 	'cordova build ios --verbose'
6. Change Sample app project's Info.plist (NeuraSampleCordova-Info.plist). 
	It can be done by altering the appropriate plist file or via xCode.
	
	I. Add Privacy related items:
		a. Privacy - Motion Usage Description
		b. Privacy - Bluetooth Peripheral Usage Description
		c. Privacy - Location Always Usage Description

		In plist format:

	    <key>NSBluetoothPeripheralUsageDescription</key>
	    <string>This enables more accurate detection of activity and significant places.</string>
	    <key>NSLocationAlwaysUsageDescription</key>
	    <string>Location data is required to to provide a better experience</string>
	    <key>NSMotionUsageDescription</key>
	    <string>Motion data is required to provide a better experience</string>

	II. Add background modes:
		a. "fetch"
		b. "location"
		c. "remote-notification"
		d. "bluetooth-central"

		In plist format:

	   	<key>UIBackgroundModes</key>
	   	<array>
      	    <string>fetch</string>
      	    <string>location</string>
      	    <string>remote-notification</string>
      	    <string>bluetooth-central</string>
    	</array>


7. Open xcode project 'path/to/NeuraSampleCordova/platforms/ios/NeuraSampleCordova.xcworkspace'
8. Select appropriate signing team.
9. In case the NeuraSDK Automatic Push Notification functionality should be used, go to the 'Capabilities' tab of the 'NeuraSampleCordova' target and turn on 'Push Notification' capability.

