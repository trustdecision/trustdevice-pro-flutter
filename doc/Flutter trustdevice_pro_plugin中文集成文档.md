# Flutter trustdevice_pro_plugin集成文档

# 集成要求

## 合规说明

请注意，在贵司的App中集成同盾提供的SDK产品时:

1.1 根据《网络安全法》《电信条例》《电信和互联网用户个人信息保护规定》等相关法律法规要求及监管实践中的标准，在贵司的最终用户首次启动App并在贵司开始采集信息之前，贵司应以交互界面或设计（如隐私政策弹窗等）向最终用户完整告知收集、使用、与第三方共享最终用户个人信息的目的、方式和范围，并征得最终用户的明示同意。

1.2 为向贵司提供业务安全和风控服务，同盾SDK将采集、处理、使用用户的手机终端唯一标志信息（IMEI/IDFA）、Android ID、IMSI、MEID、MAC 地址、SIM 卡序列号、设备序列号、设备类型、设备型号、系统类型、地理位置、登录 IP 地址等设备信息。为确保贵司使用相关服务的合规性，前述隐私政策应涵盖对同盾SDK提供服务并采集、处理、使用相关信息的授权，以下条款内容供贵司参考，具体表述可由贵司根据贵司隐私协议的整体框架和内容自行确定：

```
同盾SDK：为了业务安全和风控，我司使用了同盾 SDK，该 SDK 需要获取您的手机终端唯一标志信息（IMEI/IDFA）、Android ID、IMSI、MEID、MAC 地址、SIM卡序列号、设备序列号、设备类型、设备型号、系统类型、地理位置、登录 IP 地址、应用程序列表、运行中进程信息、传感器（光传感器、重力传感器、磁场传感器、加速度传感器、陀螺仪传感器）相关设备信息，用于设备欺诈风险识别。
```

同盾隐私协议：https://www.tongdun.cn/other/privacy/id=1

**注意事项**

确保在用户同意隐私协议后，再进行插件配置初始化，避免出现用户未同意隐私协议就进行插件初始化采集，引发合规风险。

## 快速开始

1.将trustdevice_pro_plugin添加到Flutter应用程序中的pubspec.yaml

```
dependencies:
  flutter:
    sdk: flutter
  ...
  trustdevice_pro_plugin: ^1.1.0
```

2.Android权限申请

在应⽤module下的 AndroidManifest.xml ⽂件中声明以下权限

```xml
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

3.初始化配置

```
import 'package:trustdevice_pro_plugin/trustdevice_pro_plugin.dart';
import 'package:flutter/foundation.dart';
// ...

// Initialization
class _MyAppState extends State<MyApp> {
  final _trustdeviceProPlugin = TrustdeviceProPlugin();
  @override
  void initState() async {
    super.initState();
    var options = {
      "partner": "请输入您的合作方编码",
      "appKey": "请输入您的appKey",
      "appName": "请输入您的appName",
      "country": "请输入您所在的国家地区",
      "debug":kDebugMode, // 上线时删除本行代码，防止应用被调试
    };
    //初始化配置并返回blackbox
    var blackbox = await _trustdeviceProPlugin.initWithOptions(options);
  }
  // ...
}

```

**必传配置**

<table>
  <tr>
    <th>配置 key</th>
    <th>定义</th>
    <th>说明</th>
    <th>平台</th>
    <th>示例代码</th>
  </tr>
  <tr>
    <td>partner</td>
    <td>合作方编码</td>
    <td>同盾的合作方编码，请联系同盾运营获取</td>
    <td>All</td>
    <td>
 options["partner"] = "请输入您的合作方编码"
   </td>
  </tr>
  <tr>
    <td>appKey</td>
    <td>应用标识</td>
    <td>同盾生成的应用标识，和app绑定，用于校验app的有效性，请联系同盾运营获取<br> 
       appkey创建需要用户提供应用包名、小写的sha256 签名。<br>
      ⚠️不同应用的包名签名不要使用相同的值 </td>
    <td>All</td>
    <td>
    options["appKey"] = "请输入您的appKey"
    </td>
  </tr>
  <tr>
    <td>appName</td>
    <td>应用名称</td>
    <td>同盾平台注册的应用名称，请联系同盾运营获取</td>
    <td>All</td>
    <td>
    options["appName"] = "请输入您的appName"
     </td>
  </tr>
  <tr>
    <td>country</td>
    <td>国家地区</td>
    <td>cn代表中国，<br>sg代表新加坡，<br>us代表北美，<br>fra代表欧洲</td>
    <td>All</td>
    <td>
   options["country"] = "请输入您所在的国家地区"
    </td>
  </tr>
</table>


我们也提供了可选参数配置，详情可以见附表（初始化配置可选参数列表）

## 获取blackBox


### 注意事项
+ 请确保在调用过一次 `SDK初始化（initWithOptions）方法，`调用 blackBox（getBlackBox方法 或 getBlackBoxAsync方法）`，否则会引起SDK异常

### 同步方法 getBlackBox


#### 使用场景说明
**优点：**会立即返回blackBox，不受网络状态的影响；<br/>**缺点：**在集成设备指纹SDK后，在之前没有获取到非降级blackBox的情况下，会返回降级blackBox，会增大后续查询接口上传的数据量，数据量大小为5000字节左右；<br/>**适用场景：**需要立即获取blackBox的场景；<br/>

#### 示例代码
```dart
  Future<String> _getBlackBox() async {
    var blackbox = await _trustdeviceProPlugin.getBlackbox();
    return Future.value(blackbox);
  }
```

### 异步方法 getBlackBoxAsync

#### 使用场景说明
**优点：**网络正常情况下返回非降级blackBox，会降低后续查询接口上传的数据量，数据量大小为26字节左右；<br/>**缺点：**不是立即返回，根据网络情况进行等待，一般耗时300ms左右返回；<br/>**适用场景：**需要获取最新且为非降级blackBox的场景；<br/>

#### 示例代码
```dart
  Future<String> _getBlackBoxAsync() async {
    var blackbox = await _trustdeviceProPlugin.getBlackboxAsync();
    return Future.value(blackbox);
  }

```

## 获取SDK版本号

示例代码

```dart
// 获取SDK版本号
 Future<String> _getSDKVersion() async {
    var sdkVersion = await _trustdeviceProPlugin.getSDKVersion();
    return Future.value(sdkVersion);
  }
```

## 其他说明

Android混淆打包 如果开发者需要使用 proguard 进行混淆打包，请在 proguard 配置文件添加如下代码：

```java
-keep class cn.tongdun.**{*;}
```

## 初始化配置可选参数列表

<table>
  <tr>
    <th>配置 key</th>
    <th>定义</th>
    <th>说明</th>
    <th>平台</th>
    <th>示例代码</th>
  </tr>
  <tr>
    <td>debug</td>
    <td>是否允许app被调试</td>
    <td>默认false，集成SDK后App默认具有反调试功能，开发者根据具体情况进行对应设置
    <b>开发阶段：</b>Xcode调试请打开此配置<br><b>打包测试/上架阶段：</b>移除此配置
    <br><b>选项:</b><br>true:允许调试；<br>false:不允许调试，调试会闪退
    </td>
    <td>All</td>
    <td>
    options["debug"] = true
    </td>
  </tr>
  <tr>
    <td>timeLimit</td>
    <td>SDK超时时间配置（单位:秒）</td>
    <td>SDK初始化采集上报后，网络请求回调的超时时间，SDK默认为15s</td>
    <td>All</td>
    <td>
    options["timeLimit"] = 5
    </td>
  </tr>
  <tr>
    <td>location</td>
    <td>是否允许SDK采集地理定位信息</td>
    <td>默认true，在app获得地理位置权限的情况下，SDK会采集地理定位信息
    <br><b>选项:<br></b>true:采集地理定位信息；<br>false:不采集地理定位信息</td>
    <td>All</td>
    <td>
    options["location"] = true
  </td>
  </tr>
  <tr>
    <td>collectLevel</td>
    <td>降级blackbox采集字段长度配置</td>
    <td>需要blackbox长度较短时建议使用此配置<br><b>不设置：</b><br>降级blackbox长度为5000个字符左右（根据实际设备情况会有上浮）
    <br><b>选项:</b><br>"M":设置后，降级blackbox长度为2000个字符左右；<br>"L"：默认值, 设置后，降级长度为5000字符左右</td>
    <td>All</td>
    <td>
  options["collectLevel"] = "M"
  </td>
  </tr>
  <tr>
    <td>IDFA</td>
    <td>是否允许SDK采集广告标识符（IDFA）信息</td>
    <td>默认true，在app获得广告标识符授权后，SDK会采集广告标识符（IDFA）信息；设置false，可以通过苹果对于广告标识符的静态扫码检查   <br><b>选项:</b><br>true:采集IDFA；<br>false:不采集IDFA</td>
    <td>iOS</td>
    <td>
   options["IDFA"] = true
  </td>
  </tr>
  <tr>
    <td>deviceName</td>
    <td>是否采集设备名称（deviceName）</td>
    <td>默认true，SDK默认会采集当前设备名称，开发者根据具体情况进行对应设置 <br><b>选项:</b><br>true:采集设备名称；<br>false:不采集设备名称</td>
    <td>iOS</td>
    <td>
    options["deviceName"] = true
   </td>
  </tr>
  <tr>
    <td>runningTasks</td>
    <td>是否允许获取正在运行的任务</td>
    <td>默认true <br><b>选项:</b><br>true:允许获取正在运行的任务；<br>false:允许获取正在运行的任务</td>
    <td>Android</td>
    <td>
   options["runningTasks"] = true
  </td>
  </tr>
  <tr>
    <td>sensor</td>
    <td>是否采集传感器信息</td>
    <td>默认true，如果需要不采集传感器相关信息，可通过该方法取消采集相关信息 <br><b>选项:</b><br>true:采集传感器信息；<br>false:不采集传感器信息</td>
    <td>Android</td>
    <td>
    options["sensor"] = true
   </td>
  </tr>
  <tr>
    <td>readPhone</td>
    <td>是否采集READ_PHONE_STATE相关信息</td>
    <td>默认true，采集需要READ_PHONE_STATE权限。<br><b>选项:</b><br>true:采集READ_PHONE相关信息；<br>false:不采集READ_PHONE相关信息</td>
    <td>Android</td>
    <td>
    options["readPhone"] = true
  </td>
  </tr>
    <tr>
    <td>installPackageList</td>
    <td>是否采集安装包列表</td>
    <td>默认true，采集安装包列表, 可以调用此方法进行关闭<br><b>选项:</b><br>true:采集安装包列表；<br>false:不采集安装包列表</td>
    <td>Android</td>
    <td>
    options["installPackageList"] = true
  </td>
  </tr>
</table>