import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:trustdevice_pro_plugin/trustdevice_pro_plugin.dart';

import 'trustdevice_pro_plugin_platform_interface.dart';

/// An implementation of [TrustdeviceProPluginPlatform] that uses method channels.
class MethodChannelTrustdeviceProPlugin extends TrustdeviceProPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('trustdevice_pro_plugin');
  TDRiskCaptchaCallback? captchaCallback = null;

  TDLivenessCallback? livenessCallback = null;


  MethodChannelTrustdeviceProPlugin() {
    methodChannel.setMethodCallHandler(_methodCallHandler);
  }

  Future<String> getSDKVersion() async {
    String result = await methodChannel.invokeMethod("getSDKVersion");
    return result;
  }

  Future<void> initWithOptions(Map<String, dynamic> configMap) async {
    methodChannel.invokeMethod("initWithOptions", configMap);
  }

  Future<String> getBlackBox() async {
    String result = await methodChannel.invokeMethod("getBlackBox");
    return result;
  }

  Future<String> getBlackBoxAsync() async {
    String result = await methodChannel.invokeMethod("getBlackBoxAsync");
    return result;
  }

  @override
  Future<Map<String, dynamic>> sign(url) async {
    final dynamic response = await methodChannel.invokeMethod('sign', url);

    // 转换为JSON字符串再解析
    final jsonString = jsonEncode(response);
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<void> showCaptcha(TDRiskCaptchaCallback callback) async {
    captchaCallback = callback;
    await methodChannel.invokeMethod("showCaptcha");
  }


  Future<dynamic> getRootViewController() async {
    final result = await methodChannel.invokeMethod("getRootViewController");
    return result;
  }

  Future<void> showLiveness(String license,TDLivenessCallback callback) async {
    livenessCallback = callback;
    await methodChannel.invokeMethod("showLiveness",{
      'license' : license,
    });
  }


  Future<void> _methodCallHandler(MethodCall call) async {
    //print("call.method :${call.method} call.arguments:${call.arguments}");
    switch (call.method) {
      case 'showCaptcha':
        final dynamic arg = call.arguments;
        var function = arg["function"];
        if (function == null || captchaCallback == null) return;
        switch (function) {
          case 'onReady':
            captchaCallback?.onReady();
            break;
          case 'onSuccess':
            captchaCallback?.onSuccess(arg["token"]);
            break;
          case 'onFailed':
            captchaCallback?.onFailed(arg["errorCode"], arg["errorMsg"]);
            break;
        }
        break;
      case 'showLiveness':
        Map<dynamic, dynamic> resultMap = call.arguments as Map<dynamic, dynamic>;
        var function = resultMap["function"];

        if (function == null || livenessCallback == null) return;
        switch (function) {
          case 'onSuccess':
            livenessCallback?.onSuccess(resultMap);
            break;
          case 'onFailed':
            livenessCallback?.onFailed(resultMap);
            break;
        }
        break;
      default:
    }
  }
}
