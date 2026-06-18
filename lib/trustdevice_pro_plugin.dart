
import 'package:flutter/services.dart';

import 'trustdevice_pro_plugin_platform_interface.dart';

export 'trustdevice_se_plugin.dart'; // 在pro_plugin中暴露se_plugin


enum TDLivenessShowStyle {

    Push,

    Present,
}

class TDErrorEvent {
  final int errorCode;
  final String errorMsg;
  TDErrorEvent({required this.errorCode, required this.errorMsg});
}


class TrustdeviceProPlugin {

  dynamic _behaviorCollector;
  
  static final TrustdeviceProPlugin _instance = TrustdeviceProPlugin._internal();

  /// 构造方法 - 传入行为采集插件实例
  /// 如果不需要行为采集，可以不传
  factory TrustdeviceProPlugin([dynamic behaviorCollector]) {
    if (behaviorCollector != null) {
      _instance._behaviorCollector = behaviorCollector;
    }
    return _instance;
  }

  TrustdeviceProPlugin._internal();
  
  /// 获取单例实例的静态方法（保持向后兼容）
  static TrustdeviceProPlugin get instance {
    return _instance;
  }

  // 新增：事件通道
  static const EventChannel _errorEventChannel = EventChannel('trustdevice_pro_plugin/error');

  // 新增：静态 getter，返回错误事件流
  static Stream<TDErrorEvent> get onError {
    return _errorEventChannel.receiveBroadcastStream().map((dynamic event) {
      final map = Map<String, dynamic>.from(event);
      return TDErrorEvent(
        errorCode: map['errorCode'],
        errorMsg: map['errorMsg'],
      );
    });
  }

  ///Obtain the sdk version number
  Future<String> getSDKVersion() {
    return TrustdeviceProPluginPlatform.instance.getSDKVersion();
  }

  ///Initialize the configuration and return to blackBox
  Future<void> initWithOptions(Map<String, dynamic> configMap) async{

    try {
      if (_behaviorCollector != null) {
        final dataCenter = configMap['dataCenter'];
        if (dataCenter != null) {
          configMap['country'] = dataCenter;
        }
        await _behaviorCollector!.initWithOptions(configMap);
      }
      await TrustdeviceProPluginPlatform.instance.initWithOptions(configMap);

      return;
    } catch(e){
      rethrow;
    }
    
  }

  ///Get blackBox
  Future<String> getBlackBox() {
    
    return TrustdeviceProPluginPlatform.instance.getBlackBox();
  }

  ///Get blackBox Async
  Future<String> getBlackBoxAsync() {
    
    return TrustdeviceProPluginPlatform.instance.getBlackBoxAsync();
  }

  // 签名
  Future<Map<String, dynamic>>  sign(String url) {
    return TrustdeviceProPluginPlatform.instance.sign(url);
  } 

  ///showCaptcha
  Future<void> showCaptcha(TDRiskCaptchaCallback callback) {
    return TrustdeviceProPluginPlatform.instance.showCaptcha(callback);
  }

  ///showLiveness
  Future<void> showLiveness(String license,TDLivenessCallback callback) {
    return TrustdeviceProPluginPlatform.instance.showLiveness(license,callback);
  }

  /// 开始行为采集
  void start() {
    if (_behaviorCollector == null) {
      throw StateError('Behavior collector is not provided. Pass a BehaviorCollector to the constructor.');
    }
    _behaviorCollector!.start();
  }
    /// 收集行为数据
  Future<Map<String, dynamic>> collect({String? blackbox}) async {
    if (_behaviorCollector == null) {
      throw StateError('Behavior collector is not provided. Pass a BehaviorCollector to the constructor.');
    }
    // String? finalBlackbox = blackbox;
    // if (finalBlackbox == null) {
    //   try {
    //     finalBlackbox = await getBlackBoxAsync();
    //   } catch (e) {
    //     // 如果 getBlackBoxAsync 抛出异常（未初始化），返回错误码 100
    //     return {'code': 100, 'msg': 'Please call initWithOptions method first'};
    //   }
    // }
    final result = await _behaviorCollector!.collect();
    if (result == null) {
      return {'code': -1, 'msg': 'Data collection returned null'};
    }
    return result;
  }

  
  /// 停止行为采集
  void stop() {
    if (_behaviorCollector == null) {
      throw StateError('Behavior collector is not provided. Pass a BehaviorCollector to the constructor.');
    }
    _behaviorCollector!.stop();
  }

  /// 检查是否有行为采集插件
  bool hasBehaviorCollector() {
    return _behaviorCollector != null;
  }

}

class TDRisk {
  ///Mandatory Shared Configuration
  static const KEY_PARTNER = "partner";
  static const KEY_APPKEY = "appKey";
  static const KEY_APPNAME = "appName";
  static const KEY_COUNTRY = "country";
  static const KEY_DATACENTER = "dataCenter";
  static const KEY_DEBUG = "debug";
  static const KEY_TIME_LIMIT = "timeLimit";
  static const KEY_LOCATION = "location";
  static const KEY_COLLECT_LEVEL = "collectLevel";

  ///Android device fingerprint configuration
  static const KEY_FP_ANDROID_RUNNING_TASKS = "runningTasks";
  static const KEY_FP_ANDROID_SENSOR = "sensor";
  static const KEY_FP_ANDROID_READ_PHONE = "readPhone";
  static const KEY_FP_ANDROID_INSTALLPACKAGE_LIST = "installPackageList";
  static const KEY_FP_ANDROID_GOOGLE_AID = "googleAid";

  ///IOS device fingerprint configuration
  static const KEY_FP_IOS_IDFA = "IDFA";
  static const KEY_FP_IOS_DEVICENAME = "deviceName";
}

typedef VoidCallback = void Function();

class TDRiskCaptchaCallback {
  final void Function() onReady;
  final void Function(String token) onSuccess;
  final void Function(int errorCode, String errorMsg) onFailed;

  const TDRiskCaptchaCallback({
    required this.onReady,
    required this.onSuccess,
    required this.onFailed,
  });
}



class TDLivenessCallback {
  final void Function(Map<dynamic, dynamic> successResultMap) onSuccess;
  final void Function(Map<dynamic, dynamic> failResultMap) onFailed;

  const TDLivenessCallback({
    required this.onSuccess,
    required this.onFailed,
  });
}
