# 集成要求

## 合规说明

请注意，在贵司的App中集成同盾提供的SDK产品时:

1.1  根据《网络安全法》《电信条例》《电信和互联网用户个人信息保护规定》等相关法律法规要求及监管实践中的标准，在贵司的最终用户首次启动App并在贵司开始采集信息之前，贵司应以交互界面或设计（如隐私政策弹窗等）向最终用户完整告知收集、使用、与第三方共享最终用户个人信息的目的、方式和范围，并征得最终用户的明示同意。

1.2  为向贵司提供业务安全和风控服务，同盾SDK将采集、处理、使用用户的手机终端唯一标志信息（IMEI/IDFA）、Android ID、OAID、IMSI、MEID、MAC 地址、SIM 卡序列号、设备序列号、设备类型、设备型号、系统类型、地理位置、登录 IP 地址等设备信息。为确保贵司使用相关服务的合规性，前述隐私政策应涵盖对同盾SDK提供服务并采集、处理、使用相关信息的授权，以下条款内容供贵司参考，具体表述可由贵司根据贵司隐私协议的整体框架和内容自行确定：

<table border="1">
    <tr>
        <td style="background-color:#FAFAFA"><font size="2">同盾SDK：为了业务安全和风控，我司使用了同盾 SDK，该 SDK 需要获取您的手机终端唯一标志信息（IMEI/IDFA）、Android ID、OAID、IMSI、MEID、MAC 地址、SIM卡序列号、设备序列号、设备类型、设备型号、系统类型、地理位置、登录 IP 地址、应用程序列表、运行中进程信息、传感器（光传感器、重力传感器、磁场传感器、加速度传感器、陀螺仪传感器、心率传感器）相关设备信息，用于设备欺诈风险识别。</font></td>
    </tr>
</table>

同盾隐私协议：https://www.tongdun.cn/other/privacy/id=1

**注意事项**

确保在用户同意隐私协议后，再进行插件配置初始化，避免出现用户未同意隐私协议就进行插件初始化采集，引发合规风险。

# 集成步骤

## 集成SDK

 将trustdevice_pro_plugin添加到Flutter应用程序中的pubspec.yaml

```
dependencies:
  flutter:
    sdk: flutter
  ...
  trustdevice_pro_plugin: ^1.2.0
```

## Android权限申请

在应⽤module下的 AndroidManifest.xml ⽂件中声明以下权限

```
<manifest>
   <!--必选权限-->
   <!--网络通信-->
   <uses-permission android:name="android.permission.INTERNET"/>
   <!--获取网络状态-->
   <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
   <!--获取WIFI状态-->
   <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>

   <!--以下权限是可选权限，不声明此部分权限将放弃部分设备信息的采集，对数据分析及设备指纹的精准度有一定影响-->
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
   <uses-permission android:name="android.permission.READ_PHONE_STATE" />
   <!-- Android11及以上获取安装包列表需要该权限，采集安装包列表涉及到⻛险合规，是否需要该权限业务⽅⾃⾏选
择 -->
   <uses-permission android:name="android.permission.QUERY_ALL_PACKAGES"/>
</manifest>
```

动态申请权限：针对 Android 6.0 及以上版本需要动态申请权限，动态申请权限代码必须放在初始化插件之前，代码示例如下：

```
//以下权限不是必须申请，可根据业务情况选择性权限申请
 Future<void> _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.phone,
    ].request();
  }
```

## SDK初始化

**示例代码**

```
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
      "partner": "请输入您的合作方编码",
      "appKey": "请输入您的appKey",
      "appName": "请输入您的appName",
      "country": "请输入您所在的国家地区",
    };
    _trustdeviceProPlugin.initWithOptions(options);
  }
  // ...
}
```

**必传配置**

| 配置 key | 定义       | 说明                                                                                                                                                             | 平台 | 示例代码                                      |
| -------- | ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --------------------------------------------- |
| partner  | 合作方编码 | 同盾的合作方编码，请联系同盾运营获取                                                                                                                             | All  | options["partner"] = "请输入您的合作方编码"   |
| appKey   | 应用标识   | 同盾生成的应用标识，和app绑定，用于校验app的有效性，请联系同盾运营获取 appkey创建需要用户提供应用包名、小写的sha256 签名。⚠️不同应用的包名签名不要使用相同的值 | All  | options["appKey"] = "请输入您的appKey"        |
| appName  | 应用名称   | 同盾平台注册的应用名称，请联系同盾运营获取                                                                                                                       | All  | options["appName"] = "请输入您的appName"      |
| country  | 国家地区   | cn代表中国，sg代表新加坡，us代表北美，fra代表欧洲                                                                                                                | All  | options["country"] = "请输入您所在的国家地区" |

## 获取SDK版本号

**示例代码**

```
// 获取SDK版本号
 Future<String> _getSDKVersion() async {
    var sdkVersion = await _trustdeviceProPlugin.getSDKVersion();
    return Future.value(sdkVersion);
  }
```

## 其他说明

Android混淆打包 如果开发者需要使用 proguard 进行混淆打包，请在 proguard 配置文件添加如下代码：

```
-keep class cn.tongdun.**{*;}
```

## initWithOptions选传参数

| 配置 key           | 定义                                  | 说明                                                                                                                                                                                                                                                  | 平台    | 示例代码                             |
| ------------------ | ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | ------------------------------------ |
| debug              | 是否允许app被调试                     | 默认false，集成SDK后App默认具有反调试功能，开发者根据具体情况进行对应设置**选项:** true，允许调试；false，不允许调试，调试会闪退；**开发阶段:** Xcode调试请打开此配置并设置为true；**打包测试/上架阶段:** 移除此配置或设置为false； | All     | options["debug"] = true              |
| timeLimit          | SDK超时时间配置（单位:秒）            | SDK初始化采集上报后，网络请求回调的超时时间，SDK默认为15s                                                                                                                                                                                             | All     | options["timeLimit"] = 5             |
| location           | 是否允许SDK采集地理定位信息           | 默认true，在app获得地理位置权限的情况下，SDK会采集地理定位信息**选项:** true，采集地理定位信息；false，不采集地理定位信息；                                                                                                                     | All     | options["location"] = true           |
| collectLevel       | 降级blackbox采集字段长度配置          | 需要blackbox长度较短时建议使用此配置**选项:** 不设置，降级blackbox长度为5000个字符左右（根据实际设备情况会有上浮）；"M"，降级blackbox长度为2000个字符左右；"L"，默认值，降级长度为5000字符左右；                                                | All     | options["collectLevel"] = "M"        |
| IDFA               | 是否允许SDK采集广告标识符（IDFA）信息 | 默认true，在app获得广告标识符授权后，SDK会采集广告标识符（IDFA）信息；**选项:** true，采集IDFA；false，不采集IDFA，可以通过苹果对于广告标识符的静态扫码检查；                                                                                   | iOS     | options["IDFA"] = true               |
| deviceName         | 是否采集设备名称（deviceName）        | 默认true，SDK默认会采集当前设备名称，开发者根据具体情况进行对应设置**选项:** true，采集设备名称；false，不采集设备名称；                                                                                                                        | iOS     | options["deviceName"] = true         |
| runningTasks       | 是否允许获取正在运行的任务            | 默认true。**选项:** true，允许获取正在运行的任务；false，不允许获取正在运行的任务；                                                                                                                                                             | Android | options["runningTasks"] = true       |
| sensor             | 是否采集传感器信息                    | 默认true，如果需要不采集传感器相关信息，可通过该方法取消采集相关信息**选项:** true，采集传感器信息；false，不采集传感器信息；                                                                                                                   | Android | options["sensor"] = true             |
| readPhone          | 是否采集READ_PHONE_STATE相关信息      | 默认true，采集需要READ_PHONE_STATE权限。**选项:** true，采集READ_PHONE_STATE相关信息；false，不采集READ_PHONE_STATE相关信息；                                                                                                                   | Android | options["readPhone"] = true          |
| installPackageList | 是否采集安装包列表                    | 默认true，采集安装包列表, 可以调用此方法进行关闭**选项：**true，采集安装包列表；false，不采集安装包列表；                                                                                                                                             | Android | options["installPackageList"] = true |


## 获取blackbox

**注意事项**

+ 请在 `initWithOptions`后 `getBlackBox`，否则会引起SDK异常
+ 建议开发者不要在App内对 `getBlackBox`返回的结果进行缓存，获取blackbox请依赖此函数

**示例代码**

```
Future<String> _getPlatformBlackBox() async {
    var blackbox = await _trustdeviceProPlugin.getBlackbox();
    return Future.value(blackbox);
  }
```


# FAQ

**Q1**：引入终端SDK后，工程无法再进行 Xcode 调试，如何解决？

**A1**：请参考 [SDK初始化](#SDK初始化) 在终端SDK初始化时，加入如下参数

```
options["debug"] = true
```
