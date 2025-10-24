import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'trustdevice_se_plugin_platform_interface.dart';

/// An implementation of [TrustdeviceProPluginPlatform] that uses method channels.
class MethodChannelTrustdeviceSePlugin extends TrustdeviceSePluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('trustdevice_se_plugin');

  @override
  Future<void> initWithOptions(Map<String, dynamic> configMap) async {
    methodChannel.invokeMethod("initWithOptions", configMap);
  }

  @override
  Future<Map<String, dynamic>> getDeviceInfo() async {
    final dynamic response = await methodChannel.invokeMethod('getDeviceInfo');

    // 转换为JSON字符串再解析
    final jsonString = jsonEncode(response);
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> sign(url) async {
    final dynamic response = await methodChannel.invokeMethod('sign', url);

    // 转换为JSON字符串再解析
    final jsonString = jsonEncode(response);
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  @override
  Future<String> getSDKVersion() async {
    String result = await methodChannel.invokeMethod("getSDKVersion");
    return result;
  }

}
