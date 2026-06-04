import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trustdevice_pro_plugin/trustdevice_se_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrustDevice Standard Demo',
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
  final _trustdeviceSePlugin = TrustdeviceSePlugin();
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
      final options = {
        "partner": "XXX",        // 请替换为实际值
        "appKey": "XXX", // 请替换为实际值
        "dataCenter": 'cn', // cn / sg / us / fra / idna
        "channel": "your_channel",// 可选，请联系运营获取
      };

      await _trustdeviceSePlugin.initWithOptions(options);
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
      final version = await _trustdeviceSePlugin.getSDKVersion();
      _appendLog('✅ SDK version: $version');
    } on PlatformException catch (e) {
      _appendLog('❌ Get version failed: code=${e.code}, message=${e.message}');
    } catch (e) {
      _appendLog('❌ Get version error: $e');
    }
  }

  /// 获取设备信息
  Future<void> _getDeviceInfo() async {
    _appendLog('▶️ getDeviceInfo called');
    try {
      final resultData = await _trustdeviceSePlugin.getDeviceInfo();

      // 解析通用字段
      final fpVersion = resultData['fpVersion'] as String? ?? '';
      final blackBox = resultData['blackBox'] as String? ?? '';
      final anonymousId = resultData['anonymousId'] as String? ?? '';
      final deviceRiskScore = resultData['deviceRiskScore'] as int? ?? 0;
      final sealedResult = resultData['sealedResult'] as String? ?? '';
      final apiStatus = resultData['apiStatus'] as Map<String, dynamic>? ?? {};


      final statusCode = apiStatus['code'] as int? ?? -1;
      final statusMessage = apiStatus['message'] as String? ?? '';

      
      if (statusCode == 0) {
        _appendLog('✅ Device info retrieved successfully');
        _appendLog('   anonymousId: $anonymousId');
        _appendLog('   blackBox: $blackBox');
        _appendLog('   fpVersion: $fpVersion');
        _appendLog('   deviceRiskScore: $deviceRiskScore');
        if (sealedResult.isNotEmpty) {
          _appendLog('   sealedResult: $sealedResult');
        }
      } else {
        _appendLog('⚠️ API returned error: code=$statusCode, message=$statusMessage');
      }
    } on PlatformException catch (e) {
     
      _appendLog('❌ getDeviceInfo failed: code=${e.code}, message=${e.message}');
    } catch (e) {
      _appendLog('❌ getDeviceInfo error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TrustDevice Standard Demo'),
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
            onPressed: _getDeviceInfo,
            child: const Text('getDeviceInfo'),
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