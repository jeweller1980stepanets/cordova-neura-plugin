# cordova-neura-plugin

This plugin is a wrapper of the <a href="https://dev.theneura.com/">Neura SDK</a> allowing you to use all its functions on a cordova app

## Installation

Install via repo url directly:

    cordova plugin add https://github.com/NeuraLabs/cordova-neura-plugin.git
    
## Sample app

The sample app included in this repo demonstrates the basic usage of the Neura SDK via this plugin.
To run the sample app please follow these steps:
    
1. Download the <a href="https://github.com/NeuraLabs/cordova-neura-plugin/blob/master/NeuraSampleCordova.zip">sample app zip file</a> and extract it
2. cd to the sample app folder
3. Add the cordova-neura-plugin as described in the installation section above
4. [Optional - only if push notifications for Neura events are required] Add the <a href="https://github.com/phonegap/phonegap-plugin-push">phonegap-plugin-push</a> to the sample app as described on its <a href="https://github.com/phonegap/phonegap-plugin-push/blob/master/docs/INSTALLATION.md">installation guide</a>
5. run the following commands


    cordova platforms add android
    cordova run android
