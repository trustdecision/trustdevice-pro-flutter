import 'package:flutter/foundation.dart';
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
      title: '设备信息展示',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: '设备信息展示'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _trustdeviceProPlugin = TrustdeviceProPlugin();
  
  // 存储设备信息
  String _fpVersion = '加载中...';
  String _blackBox = '加载中...';
  String _anonymousId = '加载中...';
  String _deviceRiskScore = '加载中...';
  String _sealedResult = '加载中...';
  String _apiStatus = '加载中...';
  
  // 加载状态
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initWithOptions();
  }

  Future<void> _initWithOptions() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      var options = {
        "partner": "demo",
        "appKey": "appKey",
        "channel": "channel",
        "country": "cn",    
      };

      
      // 初始化插件
      await _trustdeviceProPlugin.initWithOptions(options);

      var blackBox = await _trustdeviceProPlugin.getBlackBoxAsync();
      print("get blackbox:${blackBox}");
      
      // // 获取设备信息
      // final resultData = await _trustdeviceSePlugin.getDeviceInfo();
      
      // // 解析返回的数据
      // final fpVersion = resultData['fpVersion'] as String? ?? '';
      // final blackBox = resultData['blackBox'] as String? ?? '';
      // final anonymousId = resultData['anonymousId'] as String? ?? '';
      // final deviceRiskScore = resultData['deviceRiskScore'] as int? ?? 0;
      // final sealedResult = resultData['sealedResult'] as String? ?? '';
      
      // // 解析嵌套的apiStatus对象
      // final apiStatus = resultData['apiStatus'] as Map<String, dynamic>? ?? {};
      // final statusCode = apiStatus['code'] as int? ?? -1;
      // final statusMessage = apiStatus['message'] as String? ?? '';
      
      setState(() {
        // _fpVersion = fpVersion;
        // _blackBox = blackBox;
        // _anonymousId = anonymousId;
        // _deviceRiskScore = '$deviceRiskScore';
        // _sealedResult = sealedResult.isNotEmpty ? sealedResult : '无结果';
        // _apiStatus = '$statusCode ($statusMessage)';
        // _isLoading = false;
      });
      
    } on PlatformException catch (e) {
      setState(() {
        print("e.code:${e.code}");
        print("e.message:${e.message}");
        _errorMessage = '设备信息获取失败: ${e.message}';
        _isLoading = false;
      });
    } catch (e) {
      print("error:$e");
      setState(() {
        _errorMessage = '未知错误: $e';
        _isLoading = false;
      });
    }
  }

  // 复制内容到剪贴板
  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已复制$label到剪贴板'),
        duration: const Duration(seconds: 1),
      )
    );
  }

  // 构建信息展示卡片
  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: SelectableText(
          value,
          style: const TextStyle(fontSize: 14),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.copy, size: 20),
          onPressed: () => _copyToClipboard(value, title),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _initWithOptions,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _initWithOptions,
                        child: const Text('重试'),
                      )
                    ],
                  ),
                )
              : ListView(
                  children: [
                    _buildInfoCard('指纹版本', _fpVersion),
                    _buildInfoCard('黑盒数据', _blackBox),
                    _buildInfoCard('匿名ID', _anonymousId),
                    _buildInfoCard('风险分数', _deviceRiskScore),
                    _buildInfoCard('密封结果', _sealedResult),
                    _buildInfoCard('API状态', _apiStatus),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _initWithOptions,
        tooltip: '刷新信息',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}