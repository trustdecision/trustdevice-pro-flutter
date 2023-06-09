import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'trustdevice_pro_plugin_platform_interface.dart';

/// An implementation of [TrustdeviceProPluginPlatform] that uses method channels.
class MethodChannelTrustdeviceProPlugin extends TrustdeviceProPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('trustdevice_pro_plugin');

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
}
