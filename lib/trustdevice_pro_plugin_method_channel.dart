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

  Future<String> getBlackbox() async {
    String result = await methodChannel.invokeMethod("getBlackbox");
    return result;
  }

  Future<String> getBlackboxAsync() async {
    String result = await methodChannel.invokeMethod("getBlackboxAsync");
    return result;
  }

  Future<void> showCaptcha(TDRiskCaptchaCallback callback) async {
    captchaCallback = callback;
    await methodChannel.invokeMethod("showCaptcha");
  }


  Future<dynamic> getRootViewController() async {
    final result = await methodChannel.invokeMethod("getRootViewController");
    return result;
  }

  Future<void> showLivenessWithShowStyle(String license,TDLivenessShowStyle showStyle,TDLivenessCallback callback) async {
    livenessCallback = callback;
    await methodChannel.invokeMethod("showLivenessWithShowStyle",{
      'license' : license,
    //  'showStyle': showStyle,
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
      case 'showLivenessWithShowStyle':
        final dynamic arg = call.arguments;
        var function = arg["function"];

        if (function == null || livenessCallback == null) return;
        switch (function) {
          case 'onSuccess':
            livenessCallback?.onSuccess(arg["seqId"],arg["errorCode"],arg["errorMsg"],arg["score"],arg["bestImageString"],arg["livenessId"]);
            break;
          case 'onFailed':
            livenessCallback?.onFailed(arg["seqId"],arg["errorCode"],arg["errorMsg"],arg["livenessId"]);
            break;
        }
        break;
      default:
    }
  }
}
