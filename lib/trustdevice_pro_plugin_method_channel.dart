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
      default:
    }
  }
}
