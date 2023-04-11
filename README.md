# Integrated Requirement

## Compliance Explanation

Please note that when integrating SDK products provided by the TrustDecision in the APP of your company:

1.1 According to the user's information protection regulations, before your users start the App for the first time and start collecting information, your company should fully inform the user of the purpose, method, and scope of collecting, using, and sharing the user's personal information with a third party through an interactive interface or design (such as a pop-up window of the privacy policy), and obtain the express consent of the end user.

1.2 To provide business security and risk control services to your company, the TrustDecision SDK will collect, process, and use the identification information（IMEI/IDFA）, AndroidID, IMSI, MEID, MAC address, SIM card serial number, device type, device model, system type, geographical location, login IP address, application list, running process, sensor information(light sensor, gravity sensor, magnetic field sensor, acceleration sensor, gyroscope sensor) and other device information of the user's device. To ensure compliance with your use of related services, the aforementioned privacy policy should cover the authorization of TrustDecision SDK to provide services and collect, process, and use relevant information. The following terms are for your reference. The specific expression can be determined by your company according to the overall framework and content of your privacy agreement:

TrustDecision SDK: For business security and risk control, our company uses the TrustDecision SDK. The SDK needs to obtain the information of your devices, such as （IMEI/IDFA）, AndroidID, IMSI, MAC address, SIM card serial number, device type, device model, system type, geographic location, login IP address, application list, running process, sensor information(light sensor, gravity sensor, magnetic field sensor, acceleration sensor, gyroscope sensor) and other related device information, for fraud risk identification.

**Privacy Protocol:** https://www.trustdecision.com/legal/privacy-policy

**Precautions**

Ensure that the trustdevice_pro_plugin is initialized after the user agrees to the privacy agreement, so as to avoid the occurrence of trustdevice_pro_plugin initialization and collection without the user's consent to the privacy agreement, which may cause compliance risks.

## Quick start

1.Add `trustdevice_pro_plugin` to the pubspec.yaml in your Flutter app

```dart
dependencies:
  flutter:
    sdk: flutter
  ...
  trustdevice_pro_plugin: ^0.1.1
```

2.Android permission application

Dynamic application permissions: Android 6.0 or above requires dynamic application permissions. Dynamic application permissions code must be placed before the initial plugin. The code example is as follows:

```dart
//The following permissions are not required to be applied for,and can be
//selectively applied for according to business conditions
 Future<void> _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.phone,
    ].request();
  }
```

3.Initial configuration

```dart
import 'package:trustdevice_pro_plugin/trustdevice_pro_plugin.dart';
// ...

// Initialization
class _MyAppState extends State<MyApp> {
  final _trustdeviceProPlugin = TrustdeviceProPlugin();
  @override
  void initState() async {
    super.initState();
    Map<String, dynamic> configMap = {
    "appKey": "<appKey>", // configure AppKey, please contact TrustDecision Operations to obtain it 
    "appName": "<appName>", // app Name, such as appName, please fill in your app Name
    "partner": "<partner>",// Partner code, such as demo, please fill in your partner, get from trustDecision
    "country": "<country>" // Country parameter，E.g: cn、sg、us、fra
    };
    //initialize the configuration and return the blackbox
    var blackbox = await _trustdeviceProPlugin.initWithOptions(configMap);
  }
  // ...
}

```

configMap must have the following parameters:

| Key     | Definition   | Description                                                  |
| ------- | ------------ | ------------------------------------------------------------ |
| partner | partnerCode  | Partner code,such as TrustDecision,please fill in your partner |
| appKey  | appKey       | Configure AppKey with TrustDecision, please contact TrustDecision Operations to get it |
| appName | appName      | app Name,such as demo,please fill in your app Name           |
| country | Country code | `us` means North America<br/>`fra` means Europe<br/>`sg` means Singapore<br/>`cn` means China |

We also provide optional parameter configuration, see the attached table for details (list of optional parameters for initial configuration)

4.Get the blackbox code example as follows

```dart
 Future<String> _getPlatformBlackBox() async {
    var blackbox = await _trustdeviceProPlugin.getBlackbox();
    return Future.value(blackbox);
  }
```

## Get SDK Version

Sample Code

```dart
// Get SDK Version
 Future<String> _getSDKVersion() async {
    var sdkVersion = await _trustdeviceProPlugin.getSDKVersion();
    return Future.value(sdkVersion);
  }
```

## Other Instructions

Android obfuscated packaging If developers need to use proguard for obfuscated packaging, please add the following code to the proguard configuration file:

```java
-keep class cn.tongdun.**{*;}
```

## Initial configuration optional parameter list

Android:

| Key                       | Definition                                               | Description                                                  |
| ------------------------- | -------------------------------------------------------- | ------------------------------------------------------------ |
| httpTimeout               | SDK timeout interval configuration(unit: millisecond)    | Timeout interval of network request callback after SDK initialization. Defaults is 15 * 1000ms. |
| collectLevel              | Downgrade blackbox collection field length configuration | The downgraded blackbox will be longer. This configuration can control the downgraded blackbox length 1. TDRisk.COLLECT_LEVEL_L (default value, the downgraded length is about 5000 characters) 2. TDRisk.COLLECT_LEVEL_M (the downgraded length is about 2000 characters) |
| blackBoxMaxSize           | blackbox maximum length                                  | The default length is Integer.MAX_VALUE, it will increase according to the actual device situation) |
| customProcessName         | custom process name                                      | change the name of the process                               |
| forceTLSVersion           | Whether https is mandatory to use TLS-v1.1 version       | The default is not mandatory, and the developer can set the corresponding settings according to the specific situation |
| disableDebugger           | Whether to allow debugging                               | After the SDK is integrated, the app allows debugging by default, and the developer can make corresponding settings according to the specific situation. |
| disableRunningTasks       | Whether to allow getting running tasks                   | The default is to allow access, you can call this method to close |
| disableGPS                | Do not collect GPS related information                   | If you don't want to get location related information, you can cancel the collection of location related information by this method. ⚠️ When this option is configured, the app has location rights and the SDK will not collect location related information |
| disableSensor             | Do not collect sensor information                        | If you do not collect sensor-related information, you can cancel the collection of relevant information through this method。 |
| disableReadPhone          | Do not collect READ_PHONE related information            | By default, information that requires READ_PHONE_STATE permission is collected, and this method can be called to close it |
| disableInstallPackageList | Do not collect the list of installation packages         | By default, the list of installation packages is collected, and this method can be called to close |

IOS:

| Key          | Definition                                                 | Description                                                  | Scene                                                        |
| ------------ | ---------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| allowed      | Anti-debugging configuration                               | After the SDK is integrated, the app has the anti-debugging function by default. If you don't want this feature, please set allowed to disable it. | **Develop:** Please set this configuration. **Release:** Please remove this configuration. |
| timeLimit    | SDK timeout interval Configuration (unit: seconds)         | Timeout interval of network request callback after SDK initialization. Default is 15s. | If you have certain requirements for the callback time of the SDK, please set timeLimit. |
| noLocation   | SDK location information collection configuration          | SDK collects location if the app has been authorized to get location information. | If you don't want SDK to collect location information, please set noLocation. |
| noIDFA       | SDK Advertising Identifier (IDFA) collection configuration | SDK collects IDFA if the app has been authorized to get IDFA information. | If you don't want SDK to collect IDFA information and contain IDFA-related code, please set noIDFA. |
| noDeviceName | SDK deviceName collection configuration                    | SDK collects deviceName if the app has been authorized to get deviceName information. | If you don't want SDK to collect deviceName information, please set noDeviceName. |
| collectLevel | Degraded blackbox length configuration                     | Degraded blackbox will be longer. This configuration allows you to control the length of the degraded blackbox | If you wish the degraded blackbox length is as short as possible, please set this configuration. |