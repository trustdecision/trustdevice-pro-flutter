import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trustdevice_pro_plugin/trustdevice_pro_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrustDevice Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _trustdeviceProPlugin = TrustdeviceProPlugin();
  String _log = '';

  void _appendLog(String message) {
    setState(() {
      _log += '$message\n';
    });
    debugPrint(message);
  }

  /// 初始化 SDK
  Future<void> _initWithOptions() async {
    _appendLog('▶️ initWithOptions called');
    try {
      final options = <String, dynamic>{
        "partner": "xxx", // 请替换为实际值
        "appKey": "xxx", // 请替换为实际值
        "dataCenter": 'cn', // cn / sg / us / fra / idna
        "channel": "your_channel", // 可选，请联系运营获取
      };

      if (Platform.isAndroid) {
        options["appKey"] = '5978b5f9fd6a8bf5de02f0054d0dccec';
      }

      await _trustdeviceProPlugin.initWithOptions(options);
      _appendLog('✅ SDK initialized successfully');
    } on PlatformException catch (e) {
      _appendLog('❌ Init failed: code=${e.code}, message=${e.message}');
    } catch (e) {
      _appendLog('❌ Init error: $e');
    }
  }

  /// 获取 SDK 版本号
  Future<void> _getSDKVersion() async {
    _appendLog('▶️ getSDKVersion called');
    try {
      final version = await _trustdeviceProPlugin.getSDKVersion();
      _appendLog('✅ SDK version: $version');
    } on PlatformException catch (e) {
      _appendLog('❌ Get version failed: code=${e.code}, message=${e.message}');
    } catch (e) {
      _appendLog('❌ Get version error: $e');
    }
  }

  /// 通过原生异步接口获取设备信息
  Future<void> _getDeviceInfoAsync() async {
    await _fetchDeviceInfo(
        'getDeviceInfoAsync', _trustdeviceProPlugin.getDeviceInfoAsync);
  }

  /// 通过原生同步接口获取设备信息（插件在工作线程执行）
  Future<void> _getDeviceInfo() async {
    await _fetchDeviceInfo(
        'getDeviceInfo', _trustdeviceProPlugin.getDeviceInfo);
  }

  /// 测试旧版异步 blackBox 接口
  Future<void> _getBlackBoxAsync() async {
    await _fetchBlackBox(
        'getBlackBoxAsync', _trustdeviceProPlugin.getBlackBoxAsync);
  }

  /// 测试旧版同步 blackBox 接口
  Future<void> _getBlackBox() async {
    await _fetchBlackBox('getBlackBox', _trustdeviceProPlugin.getBlackBox);
  }

  Future<void> _fetchBlackBox(
    String methodName,
    Future<String> Function() fetch,
  ) async {
    _appendLog('▶️ $methodName called');
    try {
      final blackBox = await fetch();
      _appendLog('   blackBox length: ${blackBox.length}');
      _appendLog('   blackBox: $blackBox');
    } on PlatformException catch (e) {
      _appendLog('❌ $methodName failed: code=${e.code}, message=${e.message}');
    } catch (e) {
      _appendLog('❌ $methodName error: $e');
    }
  }

  Future<void> _fetchDeviceInfo(
    String methodName,
    Future<Map<String, dynamic>> Function() fetch,
  ) async {
    _appendLog('▶️ $methodName called');
    try {
      final resultData = await fetch();

      // 解析通用字段
      final fpVersion = resultData['fpVersion'] as String? ?? '';
      final blackBox = resultData['blackBox'] as String? ?? '';
      final anonymousId = resultData['anonymousId'] as String? ?? '';
      final deviceRiskScore = resultData['deviceRiskScore'] as int? ?? 0;
      final sealedResult = resultData['sealedResult'] as String? ?? '';
      final apiStatus =
          Map<String, dynamic>.from(resultData['apiStatus'] as Map? ?? {});

      final statusCode = apiStatus['code'] as int? ?? -1;
      final statusMessage = apiStatus['message'] as String? ?? '';

      _appendLog('   code: $statusCode, message: $statusMessage');
      _appendLog('   blackBox: $blackBox');
      _appendLog('   fpVersion: $fpVersion');
      _appendLog('   anonymousId: $anonymousId');
      _appendLog('   deviceRiskScore: $deviceRiskScore');
      if (sealedResult.isNotEmpty) {
        _appendLog('   sealedResult: $sealedResult');
      }
    } on PlatformException catch (e) {
      _appendLog('❌ $methodName failed: code=${e.code}, message=${e.message}');
    } catch (e) {
      _appendLog('❌ $methodName error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TrustDevice Demo'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _initWithOptions,
            child: const Text('initWithOptions'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _getSDKVersion,
            child: const Text('getSDKVersion'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _getDeviceInfoAsync,
            child: const Text('getDeviceInfoAsync'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _getDeviceInfo,
            child: const Text('getDeviceInfo'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _getBlackBoxAsync,
            child: const Text('getBlackBoxAsync (legacy)'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _getBlackBox,
            child: const Text('getBlackBox (legacy)'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Text(
                  _log,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
