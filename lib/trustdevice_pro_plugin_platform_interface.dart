import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:trustdevice_pro_plugin/trustdevice_pro_plugin.dart';

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

  Future<void> initWithOptions(Map<String, dynamic> configMap) {
    throw UnimplementedError('getResult() has not been implemented.');
  }

  Future<String> getBlackBox() {
    throw UnimplementedError('getResult() has not been implemented.');
  }

  Future<String> getBlackBoxAsync() {
    throw UnimplementedError('getResult() has not been implemented.');
  }

  Future<void> showCaptcha(TDRiskCaptchaCallback callback) {
    throw UnimplementedError('getResult() has not been implemented.');
  }

   Future<dynamic> getRootViewController() {
    throw UnimplementedError('getResult() has not been implemented.');
  }

  Future<void> showLiveness(String license,TDLivenessCallback callback) {
    throw UnimplementedError('getResult() has not been implemented.');
  }

  Future<String> getSDKVersion() {
    throw UnimplementedError('getResult() has not been implemented.');
  }
}
