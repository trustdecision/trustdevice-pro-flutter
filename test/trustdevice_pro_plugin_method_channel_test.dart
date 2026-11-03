import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trustdevice_pro_plugin/trustdevice_pro_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelTrustdeviceProPlugin();
  const MethodChannel channel = MethodChannel('trustdevice_pro_plugin');
  final calls = <String>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      calls.add(methodCall.method);
      return {
        'blackBox': 'test-black-box',
        'fpVersion': '5.3.2',
        'apiStatus': {'code': 0, 'message': 'Success'},
      };
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getDeviceInfo calls native synchronous API and returns status',
      () async {
    final info = await platform.getDeviceInfo();

    expect(calls, ['getDeviceInfo']);
    expect(info['blackBox'], 'test-black-box');
    expect(info['apiStatus'], {'code': 0, 'message': 'Success'});
  });

  test('getDeviceInfoAsync calls native asynchronous API', () async {
    final info = await platform.getDeviceInfoAsync();

    expect(calls, ['getDeviceInfoAsync']);
    expect(info['blackBox'], 'test-black-box');
  });

  test('getDeviceInfoAsync preserves nonzero SDK status', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            channel,
            (MethodCall methodCall) async => {
                  'blackBox': '',
                  'apiStatus': {'code': 100, 'message': 'SDK error'},
                });

    final info = await platform.getDeviceInfoAsync();

    expect(info['apiStatus'], {'code': 100, 'message': 'SDK error'});
  });
}
