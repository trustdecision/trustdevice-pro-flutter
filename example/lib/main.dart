import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
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
      ),
      home: const MyHomePage(title: 'trustdevice_pro_plugin'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyAppState();
}

class _MyAppState extends State<MyHomePage> {
  final _trustdeviceProPlugin = TrustdeviceProPlugin();
  var _mBlackbox = "";

  @override
  void initState() {
    super.initState();
    // _requestPermission().then((value) => {
    //
    // })
    _initWithOptions();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    _getSDKVersion().then((sdkVersion) => {
                          Fluttertoast.showToast(
                              msg: "The sdk version is ${sdkVersion}",
                              textColor: Colors.white)
                        });
                  },
                  child: Text(
                    "Get sdk version",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  onPressed: () {
                    _initWithOptions();
                  },
                  child: Text(
                    "initialization",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  onPressed: () {
                    var future = _getBlackBox();
                    future.then((blackbox) => {
                          setState(() {
                            if (blackbox != null) {
                              _mBlackbox = blackbox;
                              print(
                                  "getBlackBox blackbox: ${_mBlackbox}");
                            }
                          })
                        });
                  },
                  child: Text(
                    "Get blackbox",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  onPressed: () {
                    var future = _getBlackBoxAsync();
                    future.then((blackbox) => {
                          setState(() {
                            if (blackbox != null) {
                              _mBlackbox = blackbox;
                              print(
                                  "getBlackBox blackbox: ${_mBlackbox}");
                            }
                          })
                        });
                  },
                  child: Text(
                    "Get blackbox Async",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  onPressed: () {
                    _showCaptcha(TDRiskCaptchaCallback(onReady: () {
                      print("验证码弹窗成功，等待验证!");
                    }, onSuccess: (String token) {
                      print("验证成功!，validateToken:" + token);
                    }, onFailed: (int errorCode, String errorMsg) {
                      print("验证失败!, 错误码: $errorCode 错误内容: $errorMsg");
                    }));
                  },
                  child: Text(
                    "showCaptcha",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  onPressed: () {
                    _showLiveness(TDLivenessCallback(onSuccess: (String seqId,int errorCode,String errorMsg,int score,String bestImageString,String livenessId) {
                      print("验证成功!seqId:" + seqId);
                    }, onFailed: (String seqId,int errorCode,String errorMsg,String livenessId) {
                      print("验证失败!, 错误码: $errorCode 错误内容: $errorMsg");
                    }));
                  },
                  child: Text(
                    "showLiveness",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(18, 20, 18, 0),
              child: Text("blackbox : ${_mBlackbox}"),
            )
          ],
        ),
      ),
    );
  }

  /**
   * request requestPermission
   */
  Future<void> _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.phone,
    ].request();
  }

  /**
   * Obtain the sdk version number
   */
  Future<String> _getSDKVersion() async {
    var sdkVersion = await _trustdeviceProPlugin.getSDKVersion();
    return Future.value(sdkVersion);
  }

  /**
   *Initialize the configuration
   */
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

  /**
   * Get blackox
   */
  Future<String> _getBlackBox() async {
    var blackbox = await _trustdeviceProPlugin.getBlackbox();
    return Future.value(blackbox);
  }

  /**
   * Get blackox Async
   */
  Future<String> _getBlackBoxAsync() async {
    var blackbox = await _trustdeviceProPlugin.getBlackboxAsync();
    return Future.value(blackbox);
  }

  /**
   * showCaptcha
   */
  Future<void> _showCaptcha(TDRiskCaptchaCallback callback) async {
    await _trustdeviceProPlugin.showCaptcha(callback);
  }

  /**
   * showCaptcha
   */
  Future<void> _showLiveness(TDLivenessCallback callback) async {

    final rootVC = await _trustdeviceProPlugin.getRootViewController();

    String license = "xxxx";

    await _trustdeviceProPlugin.showLivenessWithShowStyle(rootVC,license,TDLivenessShowStyle.Present,callback);
  }

}
