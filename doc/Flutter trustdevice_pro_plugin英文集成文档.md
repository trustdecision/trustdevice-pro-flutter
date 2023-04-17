# Flutter trustdevice_pro_plugin Integration Documentation

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

```
dependencies:
  flutter:
    sdk: flutter
  ...
  trustdevice_pro_plugin: ^1.1.0
```

2.Android permission application

Declare the following permissions in the AndroidManifest.xml file under the application module

```xml
<manifest>
   <!--Compulsory permissions-->
   <uses-permission android:name="android.permission.INTERNET"/>
   <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
   <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>

   <!--The following permissions are optional. If this part of the authority is not declared, the acquisition of some device information will be abandoned, which will have a certain effect on data analysis and the accuracy of the fingerprint of the device fingerprint-->
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
   <uses-permission android:name="android.permission.READ_PHONE_STATE" />
   <!-- This permission is required for Android 11 and above to obtain the installation package list. Collecting the installation package list involves risk and compliance. Whether this permission is required is optional for the business party
select -->
   <uses-permission android:name="android.permission.QUERY_ALL_PACKAGES"/>
</manifest>
```

Dynamic application permissions: Android 6.0 or above requires dynamic application permissions. Dynamic application permissions code must be placed before the initial plugin. The code example is as follows:

```
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
    var options = {
            "partner": "[Your partner]",
            "appKey": "[Your appKey]",
            "appName": "[Your appName]",
            "country": "[Your country code]",
        };
    //initialize the configuration and return the blackbox
    var blackbox = await _trustdeviceProPlugin.initWithOptions(options);
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
    <td>Country/region parameters, such as cn sg us fra,Fill in the corresponding parameters according to country and region of business.<br><b>Options:</b><br>cn: means China;<br>sg: means Singapore;<br>us: means North America;<br>fra: means Europe</td>
    <td>All</td>
    <td>
    options["country"] = "[Your country code]"
   </td>
  </tr>
</table>

We also provide optional parameter configuration, see the attached table for details (list of optional parameters for initial configuration)

4.Get the blackbox code example as follows

**Attention**

- Please `getBlackBox` after `initWithOptions`, otherwise SDK exceptions will be caused.
- We suggest that developers do not cache the results returned by `getBlackBox` in the app. Please rely on this function to get blackbox.

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
#TONGDUN
-keep class cn.tongdun.**{*;}
```

## Initial configuration optional parameter list

<table>
  <tr>
    <th>Key</th>
    <th>Definition</th>
    <th>Description</th>
    <th>Platform</th>
    <th>Sample code</th>
  </tr>
  <tr>
    <td>allowed</td>
    <td>Whether allow debug</td>
    <td>default is false,After the SDK is integrated, the app has the anti-debugging function by default. <br><b>Develop: </b>Please set value to true.<br><b>Release: </b>Please not set this key or set value to false <br><b>Options:</b><br>true: allow debug;<br>false: not allow debug</td>
    <td>All</td>
    <td>
    options["allowed"] = true
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
    <td>Whether collect READ_PHONE related information</td>
    <td>default is true,SDK will collect READ_PHONE information if app gained READ_PHONE_STATE permission<br><b>Options:</b><br>true: collect READ_PHONE related information;<br>false: not collect READ_PHONE related information</td>
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


