import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:trustdevice_pro_plugin/trustdevice_pro_plugin.dart';
import 'package:trustdevice_pro_plugin/trustdevice_pro_plugin_method_channel.dart';
import 'package:trustdevice_pro_plugin/trustdevice_pro_plugin_platform_interface.dart';

class MockTrustdeviceProPluginPlatform
    with MockPlatformInterfaceMixin
    implements TrustdeviceProPluginPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String> getBlackBox() {
    // TODO: implement getBlackBox
    throw UnimplementedError();
  }

  @override
  Future<void> initWithOptions(Map<String, dynamic> configMap) {
    // TODO: implement initWithOptions
    throw UnimplementedError();
  }

  @override
  Future<String> getSDKVersion() {
    // TODO: implement getSDKVersion
    throw UnimplementedError();
  }

  @override
  Future<String> getBlackBoxAsync() {
    // TODO: implement getBlackBoxAsync
    throw UnimplementedError();
  }

  @override
  Future<void> showCaptcha(TDRiskCaptchaCallback callback) {
    // TODO: implement showCaptcha
    throw UnimplementedError();
  }
}

void main() {
  final TrustdeviceProPluginPlatform initialPlatform =
      TrustdeviceProPluginPlatform.instance;

  test('$MethodChannelTrustdeviceProPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTrustdeviceProPlugin>());
  });
}
