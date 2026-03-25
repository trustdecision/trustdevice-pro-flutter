import 'dart:convert';

import 'trustdevice_se_plugin_platform_interface.dart';

// // 关键：重新导出需要的类
// export 'trustdevice_se_plugin_platform_interface.dart' 
//     show TDDeviceInfoCallback, TDDeviceAPIStatus; // 添加这行

class TrustdeviceSePlugin {

  dynamic _behaviorCollector;
  static final TrustdeviceSePlugin _instance = TrustdeviceSePlugin._internal();

  /// 构造方法 - 传入行为采集插件实例
  /// 如果不需要行为采集，可以不传
  factory TrustdeviceSePlugin([dynamic behaviorCollector]) {
    if (behaviorCollector != null) {
      _instance._behaviorCollector = behaviorCollector;
    }
    return _instance;
  }

  TrustdeviceSePlugin._internal();
  
  /// 获取单例实例的静态方法（保持向后兼容）
  static TrustdeviceSePlugin get instance {
    return _instance;
  }

  ///Initialize the configuration and return to blackBox
  Future<void> initWithOptions(Map<String, dynamic> configMap) async {
    try {
      if (_behaviorCollector != null) {
        await _behaviorCollector!.initWithOptions(configMap);
      }
      await TrustdeviceSePluginPlatform.instance.initWithOptions(configMap);
      return;
    } catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>>  getDeviceInfo() {
    return TrustdeviceSePluginPlatform.instance.getDeviceInfo();
  }

  // 签名
  Future<Map<String, dynamic>>  sign(String url) {
    return TrustdeviceSePluginPlatform.instance.sign(url);
  } 

  ///Obtain the sdk version number
  Future<String> getSDKVersion() {
    return TrustdeviceSePluginPlatform.instance.getSDKVersion();
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







