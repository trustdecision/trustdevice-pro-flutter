# Integrated Requirement

## Compliance Explanation

Please note that when integrating SDK products provided by the TrustDecision in the APP of your company:

1.1 According to the user's information protection regulations, before your users start the App for the first time and start collecting information, your company should fully inform the user of the purpose, method, and scope of collecting, using, and sharing the user's personal information with a third party through an interactive interface or design (such as a pop-up window of the privacy policy), and obtain the express consent of the end user.

1.2 To provide business security and risk control services to your company, the TrustDecision SDK will collect, process, and use the identification information（IMEI/IDFA）, AndroidID, IMSI, MEID, MAC address, SIM card serial number, device type, device model, system type, geographical location, login IP address, application list, running process, sensor information(light sensor, gravity sensor, magnetic field sensor, acceleration sensor, gyroscope sensor) and other device information of the user's device. To ensure compliance with your use of related services, the aforementioned privacy policy should cover the authorization of TrustDecision SDK to provide services and collect, process, and use relevant information. The following terms are for your reference. The specific expression can be determined by your company according to the overall framework and content of your privacy agreement:

TrustDecision SDK: For business security and risk control, our company uses the TrustDecision SDK. The SDK needs to obtain the information of your devices, such as （IMEI/IDFA）, AndroidID, IMSI, MAC address, SIM card serial number, device type, device model, system type, geographic location, login IP address, application list, running process, sensor information(light sensor, gravity sensor, magnetic field sensor, acceleration sensor, gyroscope sensor) and other related device information, for fraud risk identification.

**Privacy Protocol:** `<https://www.trustdecision.com/legal/privacy-policy>`

## Environment

|                           | Android                              | iOS                |
| ------------------------- | ------------------------------------ | :----------------- |
| Supported System Versions | Android 5.0 and above                | iOS 9.0 and above  |
| Supported Architectures   | armeabi, armeabi-v7a, arm64-v8a, x86 | armv7,arm64,x86_64 |

# Integrate

There are 3 steps to integrate Liveness Detection SDK:

1. Use the [Retrive license API](https://en-support.trustdecision.com/reference/flutter#1-retrive-license-api) to get a license within the effective timeframe.
2. Install the Liveness Detection SDK Flutter Plugin then get the "livenessId".
3. Use the [Retrive result API](https://en-support.trustdecision.com/reference/flutter#3-retrive-result-api) with the "livenessId" generated in Step 2 to obtain a selfie if the liveness detection process is fully completed (whether it’s a live person or an attack scenario), or receive detailed results in case of process failure.

## 1) Retrive license API

Please follow the steps in `<https://en-support.trustdecision.com/reference/liveness-api#retrive-license-api>`

## 2.Install the Liveness Detection SDK Flutter Plugin

### Plugin Install

Add trustdevice_pro_plugin to pubspec.yaml of your project.

YAML

```yaml
dependencies:
  flutter:
    sdk: flutter
  ...
  trustdevice_pro_plugin: 1.3.9
```

### AndroidManifest.xml

Declare the following permissions in the AndroidManifest.xml file under the application module

XML

```xml
<manifest>
   <!-- required -->
   <uses-permission android:name="android.permission.INTERNET"/>
   <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
   <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
  <!-- Outside the Chinese Mainland -->
  <uses-permission android:name="com.google.android.gms.permission.AD_ID"/>

   <!--optional, If not declared, some device information will be abandoned -->
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
   <uses-permission android:name="android.permission.READ_PHONE_STATE" />
   <!-- required for Android 11 and above to obtain the installed packages -->
   <uses-permission android:name="android.permission.QUERY_ALL_PACKAGES"
        tools:ignore="QueryAllPackagesPermission" />
</manifest>
```

### Permissions

| Name                               | Description                                                  |
| ---------------------------------- | ------------------------------------------------------------ |
| **INTERNET**(required)             | Allows the app to access the network connection and send requests to communicate with the server. |
| **ACCESS_NETWORK_STATE**(required) | Collect network connection status information.               |
| **ACCESS_WIFI_STATE**(required)    | Collect the current WiFi access status and WLAN hotspot information. |
| **AD_ID**(required)                | Collect the Google advertising ID, required outside the Chinese Mainland. |
| ACCESS_COARSE_LOCATION             | Get location information, with an accuracy of approximately 30 to 1500 meters. |
| ACCESS_FINE_LOCATION               | Get location information, with positioning accuracy within 10 meters. |
| READ_PHONE_STATE                   | Collect information on SIM card                              |
| QUERY_ALL_PACKAGES                 | Collect installed packages                                   |

## Initialization

### Cautions

- Ensure that it is initialized after the user agrees to the privacy agreement.

### Definition

Dart

```dart
  Future<void> initWithOptions(Map<String, dynamic> config)
```

## Get blackBox

### Cautions

- Call `getBlackBox` after `initWithOptions`.
- Don't cache blackBox returned by getBlackBox in the app. Please rely on this function to get blackBox.

### Definition

Dart

```dart
  // get by synchronous call 
  Future<String> getBlackBox()
  // get by asynchronous call
  Future<String> getBlackBoxAsync();
```

## Best Practices

1. Call initialization in the `onCreate` method of the application, and obtain blackBox asynchronously

Dart

```dart
import 'package:trustdevice_pro_plugin/trustdevice_pro_plugin.dart';

class _MyAppState extends State<MyApp> {
  final _trustdeviceProPlugin = TrustdeviceProPlugin();
  
  @override
  void initState() {
    super.initState();
    _initWithOptions();
  }
  
  Future<void> _initWithOptions() async {
     var options = {
      "partner": "",
      "appKey": "",
      "appName": "",
      "country": ""
    };
    //Anti debugging switch, used during development phase
 		options["debug"] = true;
    _trustdeviceProPlugin.initWithOptions(options);
    var blackBox = await _trustdeviceProPlugin.getBlackBoxAsync();
    print("_initWithOptions blackBox: ${blackBox}");
  }
  
}
```

1. Obtain blackBox in actual business scenarios

Dart

```dart
Future<void> _register() async {
   var blackBox = await _trustdeviceProPlugin.getBlackBox();
   // ...
}
```

## Status Check

1. getBlackBox() will return a 26-bit string while initialization successfully: `rGPGX1678775227I9NCwcuVJCb`。
2. getBlackBox() will return a string of around 5000 bits while initialization Failed, please refer to [overview-definition](https://en-doc.trustdecision.com/reference/terminal-sdk-overview-2-0-en)

# Other

## Get SDK Version

Dart

```dart
  Future<String> getSDKVersion()
```

## Keep Configuration

XML

```xml
-keep class cn.tongdun.**{*;}
-keep class com.trustdecision.**{*;}
```

## All Configuration

| Key                | Description                                                  | 平台    | Sample                               |
| ------------------ | ------------------------------------------------------------ | ------- | ------------------------------------ |
| partner(required)  | Partner code, contact operator to obtain.                    | All     | options["partner"] = "your partner"  |
| appKey(required)   | Application identification, please refer to[how to get appKey](https://en-doc.trustdecision.com/reference/android-get-appkey) | All     | options["appKey"] = "your appKey"    |
| country(required)  | Data-center： **cn**for China **fra**for Europe **sg**for Singapore **inda** for Indonesia **us**for the USA | All     | options["country"] = "your country"  |
| appName            | Application name, contact operator to obtain                 | All     | options["appName"] = "your appName"  |
| debug              | Allow debugging, default false, must be closed before the application release. | All     | options["debug"] = true              |
| timeLimit          | Network timeout configuration, in seconds, default 15s       | All     | options["timeLimit"] = 5             |
| location           | whether collecting GPS location information, default allowed | All     | options["location"] = true           |
| collectLevel       | You can set M to control the maximum length of blackBox to 2000, default around 5000 | All     | options["collectLevel"] = "M"        |
| IDFA               | Whether collecting IDFA information, default allowed         | iOS     | options["IDFA"] = true               |
| deviceName         | Whether collecting device name, default allowed              | iOS     | options["deviceName"] = true         |
| runningTasks       | Whether collecting running tasks, default allowed            | Android | options["runningTasks"] = true       |
| sensor             | Whether collecting sensor information, default allowed       | Android | options["sensor"] = true             |
| readPhone          | Whether collecting READ *PHONE*STATE permission-related information, default allowed | Android | options["readPhone"] = true          |
| installPackageList | Whether collecting application list information, default allowed | Android | options["installPackageList"] = true |

# Liveness Module

## Install the Liveness Module dependency

### iOS

1.Double-click to open the Runner.xcworkspace project;

2.Find the trustdevice_pro_plugin.podspec file;

3.Add the liveness module dependency in the trustdevice_pro_plugin.podspec file

```undefined
s.dependency 'TrustDecisionLiveness', '2.5.0'
```

4.In the folder where Runner.xcworkspace is located, execute

```undefined
pod install --repo-update
```

### Android

1.Open the android/build.gradle file

2.Add live library dependency in android/build.gradle file

```undefined
dependencies {
    implementation 'com.trustdecision.android:liveness:2.5.3'
}
```

## Initial configuration optional parameter list

| Key                        | Definition                                                   | Description                                                  | Scene                                                        | Sample code                                      |
| -------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------ |
| language                   | language type                                                | Liveness detection prompt language                           | **Default:****en**English **Options:**  **en** English  **zh-Hans**Simplified Chinese  **zh-Hant**Traditional Chinese  **es** Spanish  **id** Indonesian  **ar** Arabic  **fil** Filipino  **ko** Korean  **pt** Portuguese  **ru** Russian  **th** Thai  **tr** Turkish  **vi** Vietnamese | options["language"] = "en"                       |
| playAudio                  | Whether to play audio                                        | The default is NO, no audio will be played                   | When turned on, the corresponding prompt audio will be played(English, Indonesian, and Spanish currently supported ) | options["playAudio"] = false                     |
| livenessDetectionThreshold | Difficulty threshold for live detection                      | Difficulty threshold for live detection, divided into three levels: high, medium, and low The default is medium | Adjust to corresponding difficulty as needed                 | options["livenessDetectionThreshold"] = "medium" |
| livenessHttpTimeOut        | SDK network timeout configuration (unit: seconds)            | Default is 15s                                               | Customers can set the network timeout according to their needs | options["livenessHttpTimeOut"] = 8               |
| showReadyPage              | When starting the face, the detection preparation page will pop up | Whether to display the preparation page, the default is YES, which means it will be displayed | After closing, the preparation page will not be displayed, and the identification process will be shorter | options["showReadyPage"] = true                  |
| faceMissingInterval        | Timeout when no face is detected (unit: milliseconds)        | No face timeout, unit ms, default is 1000ms                  | Set the timeout period when no face is detected as needed    | options["faceMissingInterval"] = 1000            |
| prepareStageTimeout        | The starting time when preparing to detect the action (unit: seconds) | Preparation phase timeout, in seconds, the default is 0S, that is, it will never time out | Set the preparation phase timeout as needed                  | options["prepareStageTimeout"] = 0               |
| actionStageTimeout         | In the action phase, the maximum verification time (unit: seconds) | Action phase timeout, unit second, default is 8S             | Set the action phase timeout as needed                       | options["actionStageTimeout"] = 8                |

## Popup Liveness Window

**Example Code**

Dart

```dart
    String license = "please use your license!!!";

    await _trustdeviceProPlugin.showLiveness(license,TDLivenessCallback(onSuccess: (String seqId,int errorCode,String errorMsg,double score,String bestImageString,String livenessId) {
          print("Liveness success!seqId: $seqId,livenessId:$livenessId,bestImageString:$bestImageString");
       }, onFailed: (String seqId,int errorCode,String errorMsg,String livenessId) {
          print("Liveness failed!, errorCode: $errorCode errorMsg: $errorMsg");
    }));
```

## Error Code

| Code  | Message                                                 |
| ----- | ------------------------------------------------------- |
| 200   | success (live person)                                   |
| 20700 | No face detected                                        |
| 20702 | Person change detected                                  |
| 20703 | Detection timeout                                       |
| 20705 | Screen lock or background exit during detection         |
| 20710 | No camera permission                                    |
| 20711 | User actively cancels detection on the preparation page |
| 20712 | User actively cancels detection on the detection page   |
| 20731 | Face not centered                                       |
| 20732 | Face not facing the screen                              |
| 20749 | Inconsistent action, tilt head down                     |
| 60001 | Network issue, failed to retrieve session               |
| 60002 | Network issue, failed to call anti-hack                 |
| 11350 | Internal error                                          |

## 3. Retrive result API

Please follow the steps in `<https://en-support.trustdecision.com/reference/liveness-api#retrive-result-api>`