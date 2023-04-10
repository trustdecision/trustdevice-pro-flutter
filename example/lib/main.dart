import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trustdevice_pro_plugin/trustdevice_pro_plugin.dart';
import 'package:trustdevice_pro_plugin_example/td_dialog.dart';

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
  final _TAG = "MyAppState";
  final _trustdeviceProPlugin = TrustdeviceProPlugin();
  var _mBlackbox = "";

  @override
  void initState() {
    super.initState();
    _requestPermission();
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
                          // print("${_TAG} getSDKVersion: ${sdkVersion}");
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
                    ProgressDialog.showProgress(context);
                    _initWithOptions()
                        .then((blackbox) => {
                              setState(() {
                                if (blackbox != null) {
                                  _mBlackbox = blackbox;
                                  print(
                                      "${_TAG} initWithOptions blackbox: ${_mBlackbox}");
                                }
                              })
                            })
                        .whenComplete(() => ProgressDialog.dismiss(context));
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
                    var future = _getPlatformBlackBox();
                    future.then((blackbox) => {
                          setState(() {
                            if (blackbox != null) {
                              _mBlackbox = blackbox;
                              print(
                                  "${_TAG} getPlatformBlackBox blackbox: ${_mBlackbox}");
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
   *Initialize the configuration and return to blackbox
   */
  Future<String> _initWithOptions() async {
    Map<String, dynamic> configMap = {
      TDRisk.KEY_APPKEY: "appKey",
      TDRisk.KEY_APPNAME: "TrustDecision",
      TDRisk.KEY_PARTNER: "TrustDecision",
      TDRisk.KEY_COUNTRY: "cn",
      TDRisk.KEY_FP_IOS_ALLOWED: "allowed"
    };
    var blackbox = await _trustdeviceProPlugin.initWithOptions(configMap);
    return Future.value(blackbox);
  }

  /**
   * Get blackox
   */
  Future<String> _getPlatformBlackBox() async {
    var blackbox = await _trustdeviceProPlugin.getBlackbox();
    return Future.value(blackbox);
  }
}
