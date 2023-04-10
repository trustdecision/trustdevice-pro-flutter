import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trustdevice_pro_plugin/trustdevice_pro_plugin_method_channel.dart';

void main() {
  MethodChannelTrustdeviceProPlugin platform =
      MethodChannelTrustdeviceProPlugin();
  const MethodChannel channel = MethodChannel('trustdevice_pro_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
