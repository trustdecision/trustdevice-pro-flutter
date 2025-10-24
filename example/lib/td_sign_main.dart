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
  var _mResultString = "";

  @override
  void initState() {
    super.initState();
    // _requestPermission().then((value) => {
    //
    // })

    // _initWithOptions();

    // test 签名
    // _testSign('dev/v2');

    _testSign('');
  }
  Future<void> _testSign(url) async{
    try {
      final resultData = await _trustdeviceProPlugin.sign(url);
      final sign = resultData['sign'] as String? ?? '';
      final msg = resultData['msg'] as String? ?? '';
      final code = resultData['code'] as int;
      if (code == 0) {
        // sign success
        print('signtest0:$resultData');
      } else {
        // code,msg
        print('signtest1:$resultData');
      }
    } catch (e) {
      print("签名异常：$e");
    }
    
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
      "partner": "tongdun", // 需要替换成你自己的
      "appKey": "0d2e7e22f9737acbac739056aa23c738", // 需要替换成你自己的
      "appName": "App", // 需要替换成你自己的
      "country": "sg", // 需要替换成你自己的
      "debug": kDebugMode, // 上线时删除本行代码，防止应用被调试
    };
    //initialize the configuration
    _trustdeviceProPlugin.initWithOptions(options);
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

}
