import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'trustdevice_se_plugin_method_channel.dart';

abstract class TrustdeviceSePluginPlatform extends PlatformInterface {
  /// Constructs a TrustdeviceProPluginPlatform.
  TrustdeviceSePluginPlatform() : super(token: _token);

  static final Object _token = Object();


  static final TrustdeviceSePluginPlatform _instance = MethodChannelTrustdeviceSePlugin();

  /// The default instance of [TrustdeviceSePluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelTrustdeviceProPlugin].
  static TrustdeviceSePluginPlatform get instance => _instance;
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TrustdeviceProPluginPlatform] when
  /// they register themselves.
  static set instance(TrustdeviceSePluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
  }


  Future<void> initWithOptions(Map<String, dynamic> configMap) {
    throw UnimplementedError('getResult() has not been implemented.');
  }

   Future<Map<String, dynamic>> getDeviceInfo() {
    throw UnimplementedError('getResult() has not been implemented.');
  }

}

// class TDDeviceInfoCallback {
//   final void Function(String fpVersion,
//                   String blackBox,
//                   String anonymousId,
//                   int deviceRiskScore,
//                   TDDeviceAPIStatus apiStatus,
//                   String sealedResult) onResult;

//   const TDDeviceInfoCallback({
//     required this.onResult
//   });
// }

// class TDDeviceAPIStatus {
//   final void Function() getCode;

//   const TDDeviceAPIStatus({
//     required this.getCode
//   });
// }

