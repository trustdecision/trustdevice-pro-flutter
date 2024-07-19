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

**Precautions**

When the installation starts for the first time, the SDK initialization is performed after the user agrees with the privacy agreement.
Avoid SDK initialization collection without the user agreeing to the privacy agreement, causing compliance risk accidents.


# Integrate Steps

## Integrated SDK

1.Add `trustdevice_pro_plugin` to the pubspec.yaml in your Flutter app

```
dependencies:
  flutter:
    sdk: flutter
  ...
  trustdevice_pro_plugin: ^1.2.4
```

## Android permission application

Declare the following permissions in the AndroidManifest.xml file under the application module

```xml
<manifest>
   <!--Compulsory permissions-->
   <uses-permission android:name="android.permission.INTERNET"/>
   <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
   <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>

   <!--The following permissions are optional. If this part of the authority is not declared, the acquisition of some device information will be abandoned, which will have a certain effect on data analysis and the accuracy of the fingerprint of the device fingerprint-->
   <uses-permission android:name="com.google.android.gms.permission.AD_ID"/>
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
   <uses-permission android:name="android.permission.READ_PHONE_STATE" />
   <!-- This permission is required for Android 11 and above to obtain the installation package list. Collecting the installation package list involves risk and compliance. Whether this permission is required is optional for the business party
select -->
   <uses-permission android:name="android.permission.QUERY_ALL_PACKAGES"/>
</manifest>
```

Dynamic application permissions: Android 6.0 or above requires dynamic application permissions. Dynamic application permissions code must be placed before the initial plugin. The code example is as follows:

```dart
//The following permissions are not required to be applied for, 
//and can be selectively applied for according to business conditions
 Future<void> _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.phone,
    ].request();
  }
```

## Initialization

**Sample Code**

```dart
import 'package:trustdevice_pro_plugin/trustdevice_pro_plugin.dart';
// ...

// Initialization
class _MyAppState extends State<MyApp> {
  final _trustdeviceProPlugin = TrustdeviceProPlugin();
  @override
  void initState() {
    super.initState();
    _initWithOptions();
  }
  //initialize the configuration
  Future<void> _initWithOptions() async {
    var options = {
            "partner": "[Your partner]",
            "appKey": "[Your appKey]",
            "appName": "[Your appName]",
            "country": "[Your country code]",
        };
     _trustdeviceProPlugin.initWithOptions(options);
  }
  // ...
}

```

**Required Configuration**

<table>
  <tr>
    <th>Key</th>
    <th>Definition</th>
    <th>Description</th>
    <th>Platform</th>
    <th>Sample code</th>
  </tr>
  <tr>
    <td>partner</td>
    <td>Partner code </td>
    <td>Partner, please contact TrustDecision to obtain</td>
    <td>All</td>
    <td>
    options["partner"] = "[Your partner]"
    </td>
  </tr>
  <tr>
    <td>appKey</td>
    <td>App key</td>
    <td>Appkey, please offer your App bundleId for TrustDecision to obtain<br>
    appkey creation requires the user to provide the application bundleId.<br>
    ⚠️ Different values for bundleId are used for different applications
    </td>
    <td>All</td>
    <td>
   options["appKey"] = "[Your appKey]"
   </td>
  </tr>
  <tr>
    <td>appName</td>
    <td>App name</td>
    <td>AppName, please contact TrustDecision to obtain</td>
    <td>All</td>
    <td>
    options["appName"] = "[Your appName]"
   </td>
  </tr>
  <tr>
    <td>country</td>
    <td> Country code</td>
    <td> cn: means China;<br>sg: means Singapore;<br>us: means North America;<br>fra: means Europe</td>
    <td>All</td>
    <td>
    options["country"] = "[Your country code]"
   </td>
  </tr>
</table>


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

# Fingerprint

## initWithOptions Optional Parameter

<table>
  <tr>
    <th>Key</th>
    <th>Definition</th>
    <th>Description</th>
    <th>Platform</th>
    <th>Sample code</th>
  </tr>
  <tr>
    <td>debug</td>
    <td>Whether allow debug</td>
    <td>default is false,After the SDK is integrated, the app has the anti-debugging function by default. <br><b>Develop: </b>Please set value to true.<br><b>Release: </b>Please not set this key or set value to false <br><b>Options:</b><br>true: allow debug;<br>false: not allow debug</td>
    <td>All</td>
    <td>
    options["debug"] = true
   </td>
  </tr>
  <tr>
    <td>timeLimit</td>
    <td>SDK timeout interval Configuration (unit: seconds)</td>
    <td>Timeout interval of network request callback after SDK initialization. Default is 15s.</td>
    <td>All</td>
    <td>
    options["timeLimit"] = 5
    </td>
  </tr>
  <tr>
    <td>location</td>
    <td>Whether collect location information</td>
    <td>default is true,SDK will collect location if the app has been authorized to get location information. <br><b>Options:</b><br>true: allow collect location information;<br>false: not allow collect location information</td>
    <td>All</td>
    <td>
    options["location"] = true
    </td>
  </tr>
  <tr>
    <td>collectLevel</td>
    <td>Degraded blackbox length configuration</td>
    <td>Degraded blackbox will be longer. This configuration allows you to control the length of the degraded blackbox. <br><b>Options:</b><br>"M": After setting, the degraded blackbox length is about 2000 characters;<br>"L": default value, after setting, the degraded length is about 5000 characters</td>
    <td>All</td>
    <td>
    options["collectLevel"] = "M"
    </td>
  </tr>
  <tr>
    <td>IDFA</td>
    <td>Whether collect Advertising Identifier (IDFA) information</td>
    <td>default is true,SDK will collect IDFA information if the app has been authorized to get IDFA information. <br><b>Options:</b><br>true: allow collect IDFA information;<br>false: not allow collect IDFA information</td>
    <td>iOS</td>
    <td>
    options["IDFA"] = true
    </td>
  </tr>
  <tr>
    <td>deviceName</td>
    <td>Whether collect device's name information</td>
    <td>default is true,SDK will collect device's name information. <br><b>Options:</b><br>true: allow collect device's name information;<br>false: not allow collect device's name information</td>
    <td>iOS</td>
    <td>
    options["deviceName"] = true
    </td>
  </tr>
  <tr>
    <td>blackBoxMaxSize</td>
    <td>blackbox maximum length</td>
    <td>The default length is Integer.MAX_VALUE, it will increase according to the actual device situation </td>
    <td>Android</td>
    <td>
    options["blackBoxMaxSize"] = 3000
   </td>
  </tr>
  <tr>
    <td>customProcessName</td>
    <td>custom process name</td>
    <td>change the name of the SDK's process</td>
    <td>Android</td>
    <td>
    options["customProcessName"] = "td"
    </td>
  </tr>
  <tr>
    <td>forceTLSVersion</td>
    <td>Whether https is mandatory to use TLS-v1.1 version</td>
    <td>default is false, and the developer can set the corresponding settings according to the specific situation. <br><b>Options:</b><br>true: use TLS-v1.1 version;<br>false: not use TLS-v1.1 version</td>
    <td>Android</td>
    <td>
    options["forceTLSVersion"] = true
  </td>
  </tr>
  <tr>
    <td>runningTasks</td>
    <td>Whether allow getting running tasks</td>
    <td>default is true. <br><b>Options:</b><br>true: allow getting running tasks;<br>false: not allow getting running tasks</td>
    <td>Android</td>
    <td>
     options["runningTasks"] = true
  </td>
  </tr>
  <tr>
    <td>sensor</td>
    <td>Whether collect sensor information</td>
    <td>default is true,SDK will collect sensor-related information. <br><b>Options:</b><br>true: collect sensor information;<br>false: not collect sensor information</td>
    <td>Android</td>
    <td>
    options["sensor"] = true
   </td>
  </tr>
  <tr>
    <td>readPhone</td>
    <td>Whether collect READ_PHONE_STATE related information</td>
    <td>default is true,SDK will collect READ_PHONE_STATE information if app gained READ_PHONE_STATE permission<br><b>Options:</b><br>true: collect READ_PHONE_STATE related information;<br>false: not collect READ_PHONE_STATE related information</td>
    <td>Android</td>
    <td>
    options["readPhone"] = true
  </td>
  <tr>
    <td>installPackageList</td>
    <td>Whether collect the list of installation packages</td>
    <td>default is true,SDK will collect the list of installation packages.
    <br><b>Options:</b><br>true: collect the list of installation packages;<br>false: not collect the list of installation packages</td>
    <td>Android</td>
    <td>
    options["installPackageList"] = true
  </td>
  </tr>
</table>


## Get Blackbox

**Attention**

- Please `getBlackBox` after `initWithOptions`,  otherwise SDK exceptions will be caused.
- We suggest that developers do not cache the results returned by `getBlackBox` in the app. Please rely on this function to get blackbox.

### Synchronous method getBlackBox

#### Usage Scenario Description

**Advantages:** The blackBox will be returned immediately, not affected by the network status;<br/> **Disadvantages:** After the device fingerprint SDK is integrated, if the non-degraded blackBox has not been obtained before, it will return to the degraded blackBox will increase the amount of data uploaded by the subsequent query interface, and the data size is about 5000 bytes;<br/>**Applicable scenarios:** Scenes where blackBox needs to be obtained immediately;<br/>

**Sample Code**

```dart
 Future<String> _getPlatformBlackBox() async {
    var blackbox = await _trustdeviceProPlugin.getBlackbox();
    return Future.value(blackbox);
  }
```

### Asynchronous method getBlackBoxAsync


#### Usage Scenario Description

**Advantages:** Under normal circumstances, the network returns a non-degraded blackBox, which will reduce the amount of data uploaded by the subsequent query interface, and the data size is about 26 bytes;<br/>**Disadvantages:** Not returned immediately, according to the network It usually takes about 300ms to return;<br/> **Applicable scenario:** Need to get the latest and non-degraded blackBox scenario;<br/>

**Sample Code**

```dart
 Future<String> _getBlackBoxAsync() async {
    var blackbox = await _trustdeviceProPlugin.getBlackboxAsync();
    return Future.value(blackbox);
  }
```



# Liveness Module

## Initial configuration optional parameter list

<table>
  <tr>
    <th>Key</th>
    <th>Definition</th>
    <th>Description</th>
    <th>Scene</th>
    <th>Sample code</th>
  </tr>
  <tr>
    <td>language</td>
    <td>language type</td>
     <td> Liveness detection prompt language </td>
  <td><br/><b>Default:</b> </b><b>en</b> English <b>Options:</b> <br/> <b>en</b> English <br/><b>zh-Hans</b> Simplified Chinese <br/><b>zh-Hant</b> Traditional Chinese <br/><b>es</b> Spanish <br/><b>id</b> Indonesian <br/><b>ar</b> Arabic <br/><b>fil</b> Filipino <br/> <b>ko</b> Korean <br/><b>pt</b> Portuguese <br/><b>ru</b> Russian <br/><b>th</b> Thai <br/><b>tr</b> Turkish <br/><b>vi</b> Vietnamese </td>
     <td>options["language"] = "en" </td>
   </tr>
<tr>
     <td>playAudio</td>
     <td>Whether to play audio </td>
     <td> The default is NO, no audio will be played </td>
     <td> When turned on, the corresponding prompt audio will be played </td>
     <td>options["playAudio"] = false </td>
   </tr>
   <tr>
     <td>livenessDetectionThreshold</td>
     <td>Difficulty threshold for live detection</td>
     <td> Difficulty threshold for live detection, divided into three levels: high, medium, and low
  The default is medium</td>
     <td> Adjust to corresponding difficulty as needed </td>
     <td>options["livenessDetectionThreshold"] = "medium" </td>
   </tr>
  <tr>
     <td>livenessHttpTimeOut</td>
     <td>SDK network timeout configuration (unit: seconds)</td>
     <td> Default is 15s </td>
     <td> Customers can set the network timeout according to their needs </td>
     <td>options["livenessHttpTimeOut"] = 8 </td>
   </tr>
   <tr>
     <td>showReadyPage</td>
     <td>When starting the face, the detection preparation page will pop up</td>
     <td> Whether to display the preparation page, the default is YES, which means it will be displayed </td>
     <td> After closing, the preparation page will not be displayed, and the identification process will be shorter </td>
     <td>options["showReadyPage"] = true </td>
   </tr>
   <tr>
     <td>faceMissingInterval </td>
     <td> Timeout when no face is detected (unit: milliseconds) </td>
     <td> No face timeout, unit ms, default is 1000ms </td>
     <td> Set the timeout period when no face is detected as needed </td>
     <td>options["faceMissingInterval"] = 1000 </td>
   </tr>
   <tr>
     <td>prepareStageTimeout</td>
     <td> The starting time when preparing to detect the action (unit: seconds) </td>
     <td> Preparation phase timeout, in seconds, the default is 0S, that is, it will never time out </td>
     <td> Set the preparation phase timeout as needed </td>
     <td>options["prepareStageTimeout"] = 0 </td>
   </tr>
   <tr>
     <td>actionStageTimeout</td>
     <td> In the action phase, the maximum verification time (unit: seconds) </td>
     <td> Action phase timeout, unit second, default is 8S </td>
     <td> Set the action phase timeout as needed </td>
     <td>options["actionStageTimeout"] = 8 </td>
   </tr>
</table>

## Popup Liveness Window

**Example Code**


```dart
    String license = "please use your license!!!";

    await _trustdeviceProPlugin.showLivenessWithShowStyle(license,showLiveness.Present,TDLivenessCallback(onSuccess: (String seqId,int errorCode,String errorMsg,double score,String bestImageString,String livenessId) {
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
| 20703 | Detection  timeout                                      |
| 20705 | Screen lock or background exit during detection         |
| 20710 | No camera permission                                    |
| 20711 | User actively cancels detection on the preparation page |
| 20712 | User  actively cancels detection on the detection page  |
| 20749 | Inconsistent action, tilt head down                     |
| 60001 | Network issue, failed to retrieve session               |
| 60002 | Network issue, failed to call anti-hack                 |
| 11350 | Internal error      


# FAQ

**Q1**：After Integrating the TrustDecision SDK, the project cannot be debugged in Xcode. How to solve it?

**A1**：Please refer to [Initialization](#initialization) When the TrustDecision SDK is initialized, add the following parameters

```
options["debug"] = true
```

