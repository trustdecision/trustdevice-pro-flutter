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
  trustdevice_pro_plugin: ^1.2.3
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
   <uses-permission android:name="com.google.android.gms.permission.AD_ID"/>
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

# 设备指纹功能模块
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
| installPackageList | 是否采集安装包列表                    | 默认true，采集安装包列表, 可以调用此方法进行关闭**选项：** true，采集安装包列表；false，不采集安装包列表；                                                                                                                                             | Android | options["installPackageList"] = true |

## 获取blackbox
### 同步方法 getBlackBox

#### 使用场景说明
**优点：** 会立即返回blackBox，不受网络状态的影响；<br/>**缺点：** 在集成设备指纹SDK后，在之前没有获取到非降级blackBox的情况下，会返回降级blackBox，会增大后续查询接口上传的数据量，数据量大小为5000字节左右；<br/>**适用场景：** 需要立即获取blackBox的场景；<br/>

**示例代码**

```dart
  Future<String> _getBlackBox() async {
    var blackbox = await _trustdeviceProPlugin.getBlackbox();
    return Future.value(blackbox);
  }
```

### 异步方法 getBlackBoxAsync


#### 使用场景说明
**优点：** 网络正常情况下返回非降级blackBox，会降低后续查询接口上传的数据量，数据量大小为26字节左右；<br/>**缺点：** 不是立即返回，根据网络情况进行等待，一般耗时300ms左右返回；<br/>**适用场景：** 需要获取最新且为非降级blackBox的场景；<br/>

**示例代码**

```dart
  Future<String> _getBlackBoxAsync() async {
    var blackbox = await _trustdeviceProPlugin.getBlackboxAsync();
    return Future.value(blackbox);
  }
```



# 验证码功能模块

## initWithOptions选传参数

<table>
  <tr>
    <th>配置 key</th>
    <th>定义</th>
    <th>说明</th>
    <th>场景</th>
    <th>示例代码</th>
  </tr>
  <tr>
    <td>language</td>
    <td>语言类型</td>
    <td><b>可选项：</b> <br>1-简体中文、2-繁体中文、3-英 文、4-日文、5-韩文、6-⻢来语、7-泰语、8-印尼语、9-俄 语  <br><b>默认：</b> <br>1-简体中文 </td>
    <td>客户根据需要设置语言类型。<br>国内支持1-5<br>海外支持1-9</td>
    <td>
       options[language"] = "1"
    </td>
  </tr>
  <tr>
    <td>tapToClose</td>
    <td>点击空白处是否关闭验证码</td>
    <td><b>可选项：</b> true、false  <br><b>默认：</b> false  </td>
    <td>开启后，点击界面空白处，会关闭验证码弹窗，关闭弹窗更加便捷</td>
    <td>
     options[tapToClose"] = true
    </td>
  </tr>
  <tr>
    <td>needSeqid</td>
    <td>失败回调信息中是否携带seqid</td>
    <td><b>可选项：</b> true、false  <br><b>默认：</b>true  </td>
    <td>开启后，失败信息中会携带seqid序列号，将seqid提供给同盾，方便排查失败原因</td>
    <td>
      options[needSeqid"] = true
     </td>
  </tr>
  <tr>
    <td>hideLoadHud</td>
    <td>是否跳过加载动画</td>
    <td><b>可选项：</b> true、false  <br><b>默认：</b>false  </td>
    <td>开启后，弹出验证码弹窗时不会再显示加载动画，缩短验证时间</td>
    <td>
      options[hideLoadHud"] = true
     </td>
  </tr>
  <tr>
    <td>hideWebCloseButton</td>
    <td>是否隐藏webview的关闭按钮</td>
    <td><b>可选项：</b> true、false  <br><b>默认：</b>false  </td>
    <td>需要强制完成验证码验证的场景</td>
    <td>
      options[hideWebCloseButton"] = true
     </td>
  </tr>
  <tr>
    <td>openLog</td>
    <td>是否打开log</td>
    <td><b>可选项：</b> true、false  <br><b>默认：</b>false  </td>
    <td>开启后，调试时控制台会输出更多的log信息，方便排查问题</td>
    <td>
      options[openLog"] = true
     </td>
  </tr>
  <tr>
    <td>skipCaptcha</td>
    <td>是否跳过同盾验证码验证</td>
    <td><b>可选项：</b> true、false  <br><b>默认：</b>false  </td>
    <td>开启将不会进行验证码的验证，同时返回4000错误码，用于动态设置是否使用同盾验证码SDK验证的场景</td>
    <td>
      options[skipCaptcha"] = true
     </td>
  </tr>
  <tr>
    <td>mfaId</td>
    <td>MFA产品</td>
    <td><b>可选项：</b> string  <br><b>默认：</b>nil  </td>
    <td>如果您接入了MFA产品（未对接MFA，可忽略该说明），请将MFA流程中获取的 `mfaid`传递给验证码配置参数</td>
    <td>
     options[mfaId"] = "mfaId string"
     </td>
  </tr>
</table>

## 弹出验证码弹窗


**示例代码**

```dart
    _trustdeviceProPlugin.showCaptcha(TDRiskCaptchaCallback(onReady: () {
        print("验证码弹窗成功，等待验证!");
    }, onSuccess: (String token) {
        print("验证成功!，validateToken:" + token);
    }, onFailed: (int errorCode, String errorMsg) {
        print("验证失败!, 错误码: $errorCode 错误内容: $errorMsg");
    }));
```

## 错误码

验证码功能模块的错误码会通过 showCaptcha 函数输出

| 错误码  | 错误信息         | 处理方式                     |
| ---- | ------------ | ------------------------ |
| 1001 | 关闭了验证码窗口     | 弹出验证码后，用户手动取消了验证码，不需要处理  |
| 2001 | 请求参数异常，请检查参数 | 请检查appName和partnerCode参数 |
| 2100 | 请求参数异常，请检查参数 | 请检查传递参数                  |
| 2101 | 请求参数异常，请检查参数 | 请求过程出错，请联系运营             |
| 2102 | 请求参数异常，请检查参数 | 参数缺失，请检查参数               |
| 2111 | 验证⻚面网络错误     | 稍后再试，或者请联系运营             |
| 2112 | 验证⻚面操作太频繁    | 稍后再试                     |
| 2113 | 未知错误         | 未知错误，请联系运营               |
| 2114 | 关闭了验证码窗口     | 点击了验证码关闭按钮，不需要处理         |
| 2115 | 验证⻚面网络错误     | 网络资源加载失败                 |
| 2116 | 验证⻚面网络错误     | 网络资源加载失败                 |
| 2202 | 验证成功         | 验证结果成功，不需要处理             |
| 2301 | 未购买此服务       | 请联系运营                    |
| 2302 | 流量已被禁用       | 请联系运营                    |
| 2303 | 流量不足         | 请联系运营                    |
| 2304 | 服务已过期        | 请联系运营                    |
| 2305 | 日流量已封顶       | 请联系运营                    |
| 2600 | 系统繁忙，请稍后再试   | 系统繁忙，请稍后再试               |
| 2601 | 验证失败，稍后重试    | 验证失败，请稍后重试               |
| 2602 | 验证失败，稍后重试    | 验证失败，请稍后重试               |
| 2603 | 验证失败，稍后重试    | 验证失败，请稍后重试               |
| 2604 | 验证失败，稍后重试    | 刷新频繁，请稍后重试               |
| 2605 | 验证失败，稍后重试    | 获取验证码信息失败                |
| 2702 | 验证失败，稍后重试    | 解析错误，请稍后重试               |
| 3001 | SSL证书校验失败    | 请关闭网络代理工具                |
| 3002 | 验证页面加载出错     | 刷新网络后重试                  |
| 3003 | 验证⻚面加载超时     | 检查网络后重试                  |
| 4000 | 验证逻辑跳过       | 开发者手动处理验证跳过逻辑            |
| 9000 | 设备指纹没有挂载     | 集成验证码需要先集成设备指纹           |
| 9001 | 没有网络         | 请检查网络连接                  |
| 9002 | 请求超时         | 检查网络，稍后重试                |
| 9003 | 返回结果异常       | 服务端错误，返回结果异常，联系技术支持      |
| 9004 | 全局加载超时       | 检查网络，稍后重试                |




# 活体功能模块

## initWithOptions选传参数

<table>
  <tr>
    <th>配置 key</th>
    <th>定义</th>
    <th>说明</th>
    <th>场景</th>
    <th>示例代码</th>
  </tr>
  <tr>
    <td>language</td>
    <td>语言类型</td>
  <td><br/><b>Default:</b> </b><b>en</b> 英语 <b>Options:</b> <br/> <b>en</b> 英语<br/><b>zh-Hans</b> 简体中文<br/><b>zh-Hant</b> 繁體中文<br/><b>es</b> 西班牙语<br/><b>id</b> 印尼语<br/><b>ar</b> 阿拉伯语<br/><b>fil</b> 菲律宾语<br/> <b>ko</b> 韩语<br/><b>pt</b> 葡萄牙语<br/><b>ru</b> 俄语<br/><b>th</b> 泰语<br/><b>tr</b> 土耳其语<br/><b>vi</b> 越南语  </td>
    <td>客户根据需要设置语言类型 </td>
    <td><b>Objective C</b><br>
  [options setValue:@"en" forKey:@"language"];
<br><b>Swift</b><br>
  options.updateValue("en", forKey: "language")</td>
  </tr>
  <tr>
    <td>playAudio</td>
    <td>是否播报语音</td>
    <td> 默认为 NO，不播报语音    </td>
    <td> 开启后，会播报对应提示语音 </td>
<td><b>Objective C</b><br>
  [options setValue:@NO forKey:@"playAudio"];
<br><b>Swift</b><br>
  options.updateValue(false, forKey: "playAudio")</td>
  </tr>
  <tr>
    <td>livenessDetectionThreshold</td>
    <td>活体检测难易度阈值</td>
    <td> 活体检测难易度阈值，分为high、medium、low三个等级
 默认为medium，中等难度    </td>
    <td> 根据需要，调整为对应难度 </td>
<td><b>Objective C</b><br>
  [options setValue:@"medium" forKey:@"livenessDetectionThreshold"];
<br><b>Swift</b><br>
  options.updateValue("medium", forKey: "livenessDetectionThreshold")</td>
  </tr>
  <tr>
    <td>livenessHttpTimeOut</td>
    <td>SDK网络超时时间配置（单位:秒）</td>
    <td> 默认为15s  </td>
    <td> 客户根据需要设置网络超时时间 </td>
    <td><b>Objective C</b><br>
  [options setValue:@8 forKey:@"livenessHttpTimeOut"];
<br><b>Swift</b><br>
  options.updateValue(8, forKey: "livenessHttpTimeOut")</td>
  </tr>
  <tr>
    <td>showReadyPage</td>
    <td>启动人脸时，会弹出检测准备页面</td>
    <td> 是否显示准备页面, 默认为 YES， 即显示    </td>
    <td> 关闭后，不显示准备页面，识别流程更短 </td>
<td><b>Objective C</b><br>
  [options setValue:@YES forKey:@"showReadyPage"];
<br><b>Swift</b><br>
  options.updateValue(true, forKey: "showReadyPage")</td>
  </tr>
  <tr>
    <td>faceMissingInterval </td>
    <td> 没有检测到人脸时的超时时间 （单位:毫秒）</td>
    <td> 无人脸超时时间， 单位ms 默认为 1000ms   </td>
    <td> 根据需要设置没有检测到人脸时的超时时间 </td>
    <td><b>Objective C</b><br>
  [options setValue:@(1000) forKey:@"faceMissingInterval"];
<br><b>Swift</b><br>
  options.updateValue(1000, forKey: "faceMissingInterval")</td>
  </tr>
  <tr>
    <td>prepareStageTimeout</td>
    <td> 准备检测动作时候的起始时间 （单位:秒）</td>
    <td> 准备阶段超时时间， 单位秒 默认为 0S， 即永远不超时  </td>
    <td> 根据需要设置 准备阶段超时时间 </td>
    <td><b>Objective C</b><br>
  [options setValue:@(0) forKey:@"prepareStageTimeout"];
<br><b>Swift</b><br>
  options.updateValue(0, forKey: "prepareStageTimeout")</td>
  </tr>
  <tr>
    <td>actionStageTimeout</td>
    <td> 动作阶段中, 最长验证时间 （单位:秒）</td>
    <td> 动作阶段超时时间， 单位秒 默认为 8S </td>
    <td> 根据需要设置 动作阶段超时时间 </td>
    <td><b>Objective C</b><br>
  [options setValue:@(8) forKey:@"actionStageTimeout"];
<br><b>Swift</b><br>
  options.updateValue(8, forKey: "actionStageTimeout")</td>
  </tr>
</table>


## 弹出活体弹窗


**示例代码**

```dart
    String license = "使用您的license!!!";

    await _trustdeviceProPlugin.showLivenessWithShowStyle(license,TDLivenessShowStyle.Present,TDLivenessCallback(onSuccess: (String seqId,int errorCode,String errorMsg,double score,String bestImageString,String livenessId) {
          print("Liveness验证成功!seqId: $seqId");
       }, onFailed: (String seqId,int errorCode,String errorMsg,String livenessId) {
          print("Liveness验证失败!, 错误码: $errorCode 错误内容: $errorMsg");
      }));
```

## 错误码


| 代码  | 提示                                                         | 是否计费 |
| ----- | ------------------------------------------------------------ | -------- |
| 200   | success 成功（真人）                                         | 是       |
| 20700 | No face detected 没有检测到人脸                              | 否       |
| 20702 | Person change detected 检测到换人                            | 否       |
| 20703 | Detection  timeout 检测超时                                  | 否       |
| 20705 | Screen lock or background exit during detection 检测过程中锁屏或退出后台 | 否       |
| 20710 | No camera permission 没有相机权限                            | 否       |
| 20711 | User actively cancels detection on the preparation page 准备页面用户主动取消检测 | 否       |
| 20712 | User  actively cancels detection on the detection page 检测页面用户主动取消检测 | 否       |
| 20749 | Inconsistent action, tilt head down 动作不一致做出低头动作   | 否       |
| 60001 | Network issue, failed to retrieve session 网络问题，无法获取session | 否       |
| 60002 | Network issue, failed to call anti-hack 网络问题，无法调用anti-hack | 否       |
| 11350 | Internal error 内部错误                       | 否    |





# FAQ

**Q1**：引入终端SDK后，工程无法再进行 Xcode 调试，如何解决？

**A1**：请参考 [SDK初始化](#sdk初始化) 在终端SDK初始化时，加入如下参数

```
options["debug"] = true
```
