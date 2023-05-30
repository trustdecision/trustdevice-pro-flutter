import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'trustdevice_pro_plugin_method_channel.dart';

abstract class TrustdeviceProPluginPlatform extends PlatformInterface {
  /// Constructs a TrustdeviceProPluginPlatform.
  TrustdeviceProPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static TrustdeviceProPluginPlatform _instance =
      MethodChannelTrustdeviceProPlugin();

  /// The default instance of [TrustdeviceProPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelTrustdeviceProPlugin].
  static TrustdeviceProPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TrustdeviceProPluginPlatform] when
  /// they register themselves.
  static set instance(TrustdeviceProPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> initWithOptions(Map<String, dynamic> configMap) {
    throw UnimplementedError('getResult() has not been implemented.');
  }

  Future<String> getBlackbox() {
    throw UnimplementedError('getResult() has not been implemented.');
  }

  Future<String> getBlackboxAsync() {
    throw UnimplementedError('getResult() has not been implemented.');
  }

  Future<String> getSDKVersion() {
    throw UnimplementedError('getResult() has not been implemented.');
  }
}
