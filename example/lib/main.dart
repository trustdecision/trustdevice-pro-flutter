import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trustdevice_pro_plugin/trustdevice_pro_plugin.dart';
import 'package:tdbehavior_flutter/tdbehavior_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TDBehaviorWidget(
      child: MaterialApp(
        title: 'trustdevice_pro_plugin',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'trustdevice_pro_plugin'),
      ),
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
  // final _trustdeviceProPlugin = TrustdeviceProPlugin();
  var _mResultString = "";
  dynamic _trustdeviceProPlugin;

  @override
  void initState() {
    super.initState();
    // _requestPermission().then((value) => {
    //
    // })
    // 注册行为采集组件
    final behaviorCollector = TDBehavior();
    // _trustdeviceProPlugin = TrustdeviceProPlugin(behaviorCollector);
    _trustdeviceProPlugin = TrustdeviceProPlugin();
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
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                  ),
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
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                  ),
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
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    var future = _getBlackBox();
                    future.then((blackBox) => {
                          setState(() {
                            if (blackBox != null) {
                              _mResultString = blackBox;
                              print(
                                  "getBlackBox blackBox: ${_mResultString}");
                            }
                          })
                        });
                  },
                  child: Text(
                    "Get blackBox",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    var future = _getBlackBoxAsync();
                    future.then((blackBox) => {
                          setState(() {
                            if (blackBox != null) {
                              _mResultString = blackBox;
                              print(
                                  "getBlackBox blackBox: ${_mResultString}");
                            }
                          })
                        });
                  },
                  child: Text(
                    "Get blackBox Async",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const BlackBoxTestPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Go BlackBox Test Page",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    _showLiveness(TDLivenessCallback(onSuccess: (Map<dynamic, dynamic> successResultMap) {
                        setState(() {
                             String sequence_id = successResultMap["sequence_id"];
                             String liveness_id = successResultMap["liveness_id"];
                             String image = successResultMap["image"];
                             _mResultString = "Liveness验证成功!seqId: $sequence_id,livenessId:$liveness_id,bestImageString:$image";
                             print(_mResultString);
                        });
                    }, onFailed: (Map<dynamic, dynamic> failResultMap) {
                       setState(() {
                             String sequence_id = failResultMap["sequence_id"];
                             int code = failResultMap["code"];
                             String message = failResultMap["message"];
                             _mResultString = "Liveness验证失败!,seqId: $sequence_id, 错误码: $code 错误内容: $message";
                             print(_mResultString);
                       });
                    }));
                  },
                  child: Text(
                    "showLiveness",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    _startBehavior();
                  },
                  child: Text(
                    "startBehavior",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    _collectBehavior().then((data) {
                      setState(() {
                        _mResultString = data.toString();
                      });
                    });
                  },
                  child: Text(
                    "collectBehavior",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    _stopBehavior();
                  },
                  child: Text(
                    "stopBehavior",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(18, 20, 18, 0),
              child: Text("result : ${_mResultString}"),
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
       "partner": "xxx", // 需要替换成你自己的
      "appKey": "xxx", // 需要替换成你自己的
      "appName": "xxx", // 需要替换成你自己的
      "country": "cn", // 参考集成文档修改
      "debug": kDebugMode,
    };
    _trustdeviceProPlugin.initWithOptions(options);
    // TDBehavior.initWithOptions(options);
    
  }

  /**
   * Get blackox
   */
  Future<String> _getBlackBox() async {
    var blackBox = await _trustdeviceProPlugin.getBlackBox();
    return Future.value(blackBox);
  }

  /**
   * Get blackox Async
   */
  Future<String> _getBlackBoxAsync() async {
    var blackBox = await _trustdeviceProPlugin.getBlackBoxAsync();
    return Future.value(blackBox);
  }
  
  /**
   * showLiveness
   */
  Future<void> _showLiveness(TDLivenessCallback callback) async {

    String license = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJwYXJ0bmVyX2tleSI6IitjdjAzanFWclhuU2hkcU5FaXBZSGg4K25qVE41S0NtMzlFLy9PLythMVB5cDB1S3pkUk03c3hHTzB1cEMvbjAiLCJwYXJ0bmVyX2NvZGUiOiJkZW1vIiwiZXhwIjoxNzYwNjA3Njg3fQ.P1Gh6S-Gj0b_FS3cvG6dRVZXIZ3I2-XzC8ffGkqShco";

    await _trustdeviceProPlugin.showLiveness(license,callback);
  }

  void _startBehavior() {
    _trustdeviceProPlugin.start();
    // TDBehavior.start();
  }

  Future<Map<String, dynamic>> _collectBehavior() async {
    // return _trustdeviceProPlugin.collect();

    // final result = await TDBehavior.collect();
    final result = await _trustdeviceProPlugin.collect();
    print('result:$result');
    final int code = result['code'];
    final String msg = result['msg'];
    final String payload = result['payload'];

    if (code == 0) {
        print('Get behavior collect result successfully, payload: $payload');
    } else {
        print('Get behavior collect result failed, code: $code, msg: $msg');
    }
    return result;
  }

  void _stopBehavior() {
    _trustdeviceProPlugin.stop();
    // TDBehavior.stop();

  }

}

class BlackBoxTestPage extends StatefulWidget {
  const BlackBoxTestPage({super.key});

  @override
  State<BlackBoxTestPage> createState() => _BlackBoxTestPageState();
}

class _BlackBoxTestPageState extends State<BlackBoxTestPage> {
  String _result = '';

  Future<void> _testGetBlackBox() async {
    try {
      final blackBox = await TrustdeviceProPlugin().getBlackBox();
      print('1111: $blackBox');
      setState(() {
        _result = blackBox;
      });
    } catch (e) {
      setState(() {
        _result = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BlackBox Test Page'),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: _testGetBlackBox,
              child: Text(
                "Get blackBox",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(18, 20, 18, 0),
            child: Text("result : $_result"),
          ),
        ],
      ),
    );
  }
}
