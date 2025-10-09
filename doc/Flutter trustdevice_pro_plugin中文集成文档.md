# Flutter

仅支持Android和iOS

# 集成要求

## 合规说明

请注意，在贵司的App中集成同盾提供的SDK产品时:

1.1 根据《网络安全法》《电信条例》《电信和互联网用户个人信息保护规定》等相关法律法规要求及监管实践中的标准，在贵司的最终用户首次启动App并在贵司开始采集信息之前，贵司应以交互界面或设计（如隐私政策弹窗等）向最终用户完整告知收集、使用、与第三方共享最终用户个人信息的目的、方式和范围，并征得最终用户的明示同意。

1.2 为向贵司提供业务安全和风控服务，同盾SDK将采集、处理、使用用户的手机终端唯一标志信息（IMEI/IDFA）、Android ID、OAID、IMSI、MEID、MAC 地址、SIM 卡序列号、设备序列号、设备类型、设备型号、系统类型、地理位置、登录 IP 地址等设备信息。为确保贵司使用相关服务的合规性，前述隐私政策应涵盖对同盾SDK提供服务并采集、处理、使用相关信息的授权，以下条款内容供贵司参考，具体表述可由贵司根据贵司隐私协议的整体框架和内容自行确定：

同盾SDK：为了业务安全和风控，我司使用了同盾 SDK，该 SDK 需要获取您的手机终端唯一标志信息（IMEI/IDFA）、Android ID、OAID、IMSI、MEID、MAC 地址、SIM卡序列号、设备序列号、设备类型、设备型号、系统类型、地理位置、登录 IP 地址、应用程序列表、运行中进程信息、传感器（光传感器、重力传感器、磁场传感器、加速度传感器、陀螺仪传感器、心率传感器）相关设备信息，用于设备欺诈风险识别

同盾隐私协议：https://www.tongdun.cn/other/privacy/id=1

## 环境要求

|          | Android                              | iOS                |
| -------- | ------------------------------------ | :----------------- |
| 兼容版本 | Android 5.0及以上系统                | iOS9.0及以上系统   |
| 支持架构 | armeabi, armeabi-v7a, arm64-v8a, x86 | armv7,arm64,x86_64 |

# 集成步骤

集成活体检测SDK共有3个步骤：

1. 调用 [获取License API](https://cn-support.trustdecision.com/reference/flutter#1获取license-api)，得到一个在时间有效期范围内的License。
2. 安装活体检测SDK Flutter插件，获取“livenessId”。
3. 调用 [获取结果 API](https://cn-support.trustdecision.com/reference/flutter#3获取结果-api)，传入第2步中获得的“livenessId”，传入第2步中获得的“liveness_id”，在活体检测过程完毕后获取最佳人脸自拍照（无论是真人或者是假人攻击场景），或在活体检测过程失败时接收详细原因。

## 1.获取License API

请按 https://cn-support.trustdecision.com/reference/liveness-api#获取license-api 步骤操作

## 2.安装活体检测SDK Flutter插件

### 插件安装

将trustdevice_pro_plugin添加到Flutter应用程序中的pubspec.yaml

YAML

```yaml
dependencies:
  flutter:
    sdk: flutter
  ...
  trustdevice_pro_plugin: ^1.4.2
```

### Android权限申请

在应⽤module下的 AndroidManifest.xml ⽂件中声明以下权限

XML

```xml
<manifest>
   <!--必选权限-->
   <uses-permission android:name="android.permission.INTERNET"/>
   <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
   <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
   <!--如果您的应用是面向海外市场，在google play 上发布，请添加此项-->
 	 <uses-permission android:name="com.google.android.gms.permission.AD_ID"/>
   <!--以下权限是可选权限，不声明此部分权限将放弃部分设备信息的采集，对数据分析及设备指纹的精准度有一定影响-->
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
   <uses-permission android:name="android.permission.READ_PHONE_STATE" />
   <!-- Android11及以上获取安装包列表需要该权限，采集安装包列表涉及到⻛险合规，是否需要该权限业务⽅⾃⾏选
择 -->
   <uses-permission android:name="android.permission.QUERY_ALL_PACKAGES"/>
</manifest>
```

### 权限说明

| 权限                             | 说明                                           |
| -------------------------------- | ---------------------------------------------- |
| **INTERNET**（必选）             | 允许程序访问网络连接，发送请求与服务器进行通信 |
| **ACCESS_NETWORK_STATE**（必选） | 获取网络连接状态信息                           |
| **ACCESS_WIFI_STATE**（必选）    | 获取当前WiFi接入的状态以及WLAN热点的信息       |
| **AD_ID**(海外必选)              | 获取google 广告ID                              |
| ACCESS_COARSE_LOCATION           | 获取粗略位置信息，精度大概误差在30~1500米      |
| ACCESS_FINE_LOCATION             | 获取精确位置信息，定位精度达10米以内           |
| READ_PHONE_STATE                 | 读取SIM卡相关信息                              |
| QUERY_ALL_PACKAGES               | 获取应用程序列表                               |

## 初始化

### 注意事项

- 确保在用户同意隐私协议后，再进行SDK初始化

### 方法定义

Dart

```dart
  Future<void> initWithOptions(Map<String, dynamic> config)
```

## 获取blackBox

### 注意事项

- 请在initWithOptions后调用getBlackBox/getBlackBoxAsync
- 不要在App内对返回的blackBox进行缓存，获取blackBox请依赖getBlackBox方法
- 尽量在首次异步获取blackBox的成功之后，再同步获取blackBox

### 方法定义

Dart

```dart
  // 同步获取
  Future<String> getBlackBox()
  // 异步获取  
  Future<String> getBlackBoxAsync();
```

## 最佳实践

1. 在应用入口Application的onCreate方法中调用初始化并异步获取blackBox

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
      "partner": "请输入您的合作方编码",
      "appKey": "请输入您的appKey",
      "appName": "请输入您的appName",
      "country": "请输入您所在的国家地区"
    };
    //Anti debugging switch, used during development phase
 		options["debug"] = true;
    _trustdeviceProPlugin.initWithOptions(options);
    var blackBox = await _trustdeviceProPlugin.getBlackBoxAsync();
    print("_initWithOptions blackBox: ${blackBox}");
  }
  
}
```

1. 在实际业务节点同步获取blackBox

Dart

```dart
// 比如注册的时候 
Future<void> _register() async {
   var blackBox = await _trustdeviceProPlugin.getBlackBox();
   // ...
}
```

## 状态检查

1. SDK上报数据成功，getBlackBox()返回的结果长度为26位字符串。如: `rGPGX1678775227I9NCwcuVJCb`。
2. 异常情况下，getBlackBox()返回的结果长度可能达到5000字符，详情可查看[正常blackBox和降级blackBox的差异](https://cn-doc.trustdecision.com/reference/terminal-sdk-overview-2-0-cn)

# 其他说明

## 获取版本号

Dart

```dart
  Future<String> getSDKVersion()
```

## 混淆打包

如果开发者需要使用 proguard 进行混淆打包，请在 proguard 配置文件添加如下代码：

XML

```xml
-keep class cn.tongdun.**{*;}
-keep class com.trustdecision.**{*;}
```

## 全部配置

| 配置 key      | 说明                                                         | 平台 | 示例代码                                      |
| ------------- | ------------------------------------------------------------ | ---- | --------------------------------------------- |
| partner(必须) | 合作方编码，请联系运营获取                                   | All  | options["partner"] = "请输入您的合作方编码"   |
| appKey(必须)  | 应用标识，参考[如何申请appKey](https://cn-doc.trustdecision.com/reference/android-获取-appkey) | All  | options["appKey"] = "请输入您的appKey"        |
| country(必须) | **cn**代表中国，**sg**代表新加坡，**us**代表北美，**fra**代表欧洲，**idna**代表印尼 | All  | options["country"] = "请输入您所在的国家地区" |

# 活体功能模块

## 安装活体库依赖

### iOS

1.双击打开 Runner.xcworkspace 工程；

2.找到 trustdevice_pro_plugin.podspec 文件；

3.在 trustdevice_pro_plugin.podspec 文件中添加活体库依赖

```undefined
  s.dependency 'TrustDecisionLiveness'
```

4.在 Runner.xcworkspace 所在文件夹下，执行

```undefined
  pod install --repo-update 
```

### Android

1.打开 android/build.gradle 文件

2 在 android/build.gradle 文件中添加活体库依赖

```undefined
dependencies {
    implementation 'com.trustdecision.android:liveness:+'
}
```

## initWithOptions选传参数

| 配置 key                   | 定义                           | 说明                                                         | 场景                                                         | 示例代码                                         |
| -------------------------- | ------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------ |
| language                   | 语言类型                       | **Default:** **en** 英语 **Options:** **en** 英语 **zh-Hans** 简体中文 **zh-Hant** 繁體中文 **es** 西班牙语 **id** 印尼语 **ar** 阿拉伯语 **fil** 菲律宾语 **ko** 韩语 **pt** 葡萄牙语 **ru** 俄语 **th** 泰语 **tr** 土耳其语 **vi** 越南语 | 客户根据需要设置语言类型                                     | options["language"] = "en"                       |
| playAudio                  | 是否播报语音                   | 默认为 NO，不播报语音                                        | 开启后，会播报对应提示语音 （目前语音播报支持英语、印尼语、西班牙语） | options["playAudio"] = false                     |
| livenessDetectionThreshold | 活体检测难易度阈值             | 活体检测难易度阈值，分为high、medium、low三个等级 默认为medium，中等难度 | 根据需要，调整为对应难度                                     | options["livenessDetectionThreshold"] = "medium" |
| livenessHttpTimeOut        | SDK网络超时时间配置（单位:秒） | 默认为15s                                                    | 客户根据需要设置网络超时时间                                 | options["livenessHttpTimeOut"] = 8               |
| showReadyPage              | 启动人脸时，会弹出检测准备页面 | 是否显示准备页面, 默认为 YES， 即显示                        | 关闭后，不显示准备页面，识别流程更短                         | options["showReadyPage"] = true                  |

## 弹出活体弹窗

**示例代码**

Dart

```dart
    String license = "使用您的license!!!";

    await _trustdeviceProPlugin.showLiveness(license,TDLivenessCallback(onSuccess: (Map<dynamic, dynamic> successResultMap) {
                             String sequence_id = successResultMap["sequence_id"];
                             String liveness_id = successResultMap["liveness_id"];
                             String image = successResultMap["image"];
                             String _mResultString = "Liveness验证成功!seqId: $sequence_id,livenessId:$liveness_id,bestImageString:$image";
                             print(_mResultString);
     }, onFailed: (Map<dynamic, dynamic> failResultMap) {
                             String sequence_id = failResultMap["sequence_id"];
                             int code = failResultMap["code"];
                             String message = failResultMap["message"];
                             String _mResultString = "Liveness验证失败!,seqId: $sequence_id, 错误码: $code 错误内容: $message";
                             print(_mResultString);
     }));

```

## 错误码

| 代码  | 提示                                                         | 是否计费 |
| ----- | ------------------------------------------------------------ | -------- |
| 200   | success 成功（真人）                                         | 是       |
| 20703 | Detection timeout 检测超时                                   | 否       |
| 20710 | No camera permission 没有相机权限                            | 否       |
| 20711 | User actively cancels detection on the preparation page 准备页面用户主动取消检测 | 否       |
| 20712 | User actively cancels detection on the detection page 检测页面用户主动取消检测 | 否       |
| 20713 | Tracking lost 人脸丢失                                       | 否       |
| 60001 | Network issue, failed to retrieve session 网络问题，无法获取session | 否       |
| 60002 | Network issue, failed to call anti-hack 网络问题，无法调用anti-hack | 否       |
| 60004 | Did not invoke init                                          | 否       |
| 11350 | Internal error 内部错误                                      | 否       |

## 3.获取结果 API

请按 https://cn-support.trustdecision.com/reference/liveness-api#获取结果-api 步骤操作