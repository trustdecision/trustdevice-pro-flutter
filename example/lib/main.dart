// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trustdevice_pro_plugin/trustdevice_pro_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'trustdevice_pro_plugin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyAppState();
}

class _MyAppState extends State<MyHomePage> {
  final _trustdeviceProPlugin = TrustdeviceProPlugin();
  var _mBlackbox = "";

  @override
  void initState() {
    super.initState();
    _initWithOptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TrustDevice Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        children: [
          ElevatedButton(
            onPressed: () async {
              final version = await _getSDKVersion();
              _showMessage(version);
            },
            child: const Text("Get sdk version"),
          ),
          ElevatedButton(
            onPressed: _initWithOptions,
            child: const Text("initialization"),
          ),
          ElevatedButton(
            onPressed: () async {
              final blackbox = await _getBlackBox();
              setState(() {
                _mBlackbox = blackbox;
                print("getBlackBox blackbox: $_mBlackbox");
              });
            },
            child: const Text("Get blackbox"),
          ),
          ElevatedButton(
            onPressed: () async {
              final blackbox = await _getBlackBoxAsync();
              setState(() {
                _mBlackbox = blackbox;
                print("getBlackBox blackbox: $_mBlackbox");
              });
            },
            child: const Text("Get blackbox Async"),
          ),
          ElevatedButton(
            onPressed: () {
              _showCaptcha(TDRiskCaptchaCallback(onReady: () {
                print("验证码弹窗成功，等待验证!");
              }, onSuccess: (String token) {
                print("验证成功!，validateToken:$token");
              }, onFailed: (int errorCode, String errorMsg) {
                print("验证失败!, 错误码: $errorCode 错误内容: $errorMsg");
              }));
            },
            child: const Text("showCaptcha"),
          ),
          Text("blackbox : $_mBlackbox"),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(label: 'OK', onPressed: () {}),
    ));
  }

  /// Obtain the sdk version number
  Future<String> _getSDKVersion() async {
    var sdkVersion = await _trustdeviceProPlugin.getSDKVersion();
    return Future.value(sdkVersion);
  }

  /// Initialize the configuration
  Future<void> _initWithOptions() async {
    var options = {
      "partner": "tongdun", // 需要替换成你自己的
      "appKey": "0d2e7e22f9737acbac739056aa23c738", // 需要替换成你自己的
      "appName": "App", // 需要替换成你自己的
      "country": "cn", // 需要替换成你自己的
      "debug": kDebugMode, // 上线时删除本行代码，防止应用被调试
    };
    //initialize the configuration
    _trustdeviceProPlugin.initWithOptions(options);
  }

  /// Get blackox
  Future<String> _getBlackBox() async {
    var blackbox = await _trustdeviceProPlugin.getBlackbox();
    return Future.value(blackbox);
  }

  /// Get blackox Async
  Future<String> _getBlackBoxAsync() async {
    var blackbox = await _trustdeviceProPlugin.getBlackboxAsync();
    return Future.value(blackbox);
  }

  /// showCaptcha
  Future<void> _showCaptcha(TDRiskCaptchaCallback callback) async {
    await _trustdeviceProPlugin.showCaptcha(callback);
  }
}
