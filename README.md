# Integrated Requirement

## Compliance Explanation

Please note that when integrating SDK products provided by the TrustDecision in the APP of your company:

1.1 According to the user's information protection regulations, before your users start the App for the first time and start collecting information, your company should fully inform the user of the purpose, method, and scope of collecting, using, and sharing the user's personal information with a third party through an interactive interface or design (such as a pop-up window of the privacy policy), and obtain the express consent of the end user.

1.2 To provide business security and risk control services to your company, the TrustDecision SDK will collect, process, and use the identification information（IMEI/IDFA）, AndroidID, IMSI, MEID, MAC address, SIM card serial number, device type, device model, system type, geographical location, login IP address, application list, running process, sensor information(light sensor, gravity sensor, magnetic field sensor, acceleration sensor, gyroscope sensor) and other device information of the user's device. To ensure compliance with your use of related services, the aforementioned privacy policy should cover the authorization of TrustDecision SDK to provide services and collect, process, and use relevant information. The following terms are for your reference. The specific expression can be determined by your company according to the overall framework and content of your privacy agreement:

<table border="1">
    <tr>
        <td style="background-color:#FAFAFA"><font size="2">TrustDecision SDK: For business security and risk control, our company uses the TrustDecision SDK. The SDK needs to obtain the information of your devices, such as （IMEI/IDFA）, AndroidID, IMSI, MAC address, SIM card serial number, device type, device model, system type, geographic location, login IP address, application list, running process, sensor information(light sensor, gravity sensor, magnetic field sensor, acceleration sensor, gyroscope sensor) and other related device information, for fraud risk identification.</font></td>
    </tr>
</table>


**Privacy Protocol:**  [https://www.trustdecision.com/legal/privacy-policy](https://www.trustdecision.com/legal/privacy-policy)

## Environment

|                           | Android                              | iOS                |
| ------------------------- | ------------------------------------ | :----------------- |
| Supported System Versions | Android 5.0 and above                | iOS 9.0 and above  |
| Supported Architectures   | armeabi, armeabi-v7a, arm64-v8a, x86 | armv7,arm64,x86_64 |

# Integrate

## Install

### Plugin Install

Add trustdevice_pro_plugin to pubspec.yaml of your project.

```
dependencies:
  flutter:
    sdk: flutter
  ...
  trustdevice_pro_plugin: ^1.3.5
```

### AndroidManifest.xml

Declare the following permissions in the AndroidManifest.xml file under the application module

xml

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

dart

```javascript
Future<void> initWithOptions(Map<String, dynamic> config)
```

## Get blackBox

### Cautions

- Call `getBlackBox` after `initWithOptions`.
- Don't cache blackBox returned by getBlackBox in the app. Please rely on this function to get blackBox.

### Definition

dart

```dart
// get by synchronous call 
Future<String> getBlackBox()
// get by asynchronous call
Future<String> getBlackBoxAsync();
```

## Best Practices

1.Call initialization in the `onCreate` method of the application, and obtain blackBox asynchronously

dart

```Text
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
    _trustdeviceProPlugin.getBlackBoxAsync();
  }
  
}
```

2.Obtain blackBox in actual business scenarios

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

dart

```Text
Future<String> getSDKVersion()
```

## Keep Configuration

XML

```Text
-keep class cn.tongdun.**{*;}
-keep class com.trustdecision.**{*;}
```

## All Configuration

| Key                | Description                                                  | 平台    | Sample                               |
| ------------------ | ------------------------------------------------------------ | ------- | ------------------------------------ |
| partner(required)  | Partner code, contact operator to obtain.                    | All     | options["partner"] = "your partner"  |
| appKey(required)   | Application identification, please refer to[how to get appKey](https://en-doc.trustdecision.com/reference/android-get-appkey) | All     | options["appKey"] = "your appKey"    |
| country(required)  | Data-center： **cn** for China  **fra** for Europe  **sg** for Singapore  **inda** for Indonesia  **us** for the USA | All     | options["country"] = "your country"  |
| appName            | Application name, contact operator to obtain                 | All     | options["appName"] = "your appName"  |
| debug              | Allow debugging, default false, must be closed before the application release. | All     | options["debug"] = true              |
| timeLimit          | Network timeout configuration, in seconds, default 15s       | All     | options["timeLimit"] = 5             |
| location           | whether collecting GPS location information, default allowed | All     | options["location"] = true           |
| collectLevel       | You can set M to control the maximum length of blackBox to 2000, default around 5000 | All     | options["collectLevel"] = "M"        |
| IDFA               | Whether collecting IDFA information, default allowed         | iOS     | options["IDFA"] = true               |
| deviceName         | Whether collecting device name, default allowed              | iOS     | options["deviceName"] = true         |
| runningTasks       | Whether collecting running tasks, default allowed            | Android | options["runningTasks"] = true       |
| sensor             | Whether collecting sensor information, default allowed       | Android | options["sensor"] = true             |
| readPhone          | Whether collecting READ *PHONE* STATE permission-related information, default allowed | Android | options["readPhone"] = true          |
| installPackageList | Whether collecting application list information, default allowed | Android | options["installPackageList"] = true |
