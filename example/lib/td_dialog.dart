import 'dart:io';

import 'package:flutter/material.dart';

class ProgressDialog {
  static bool _isShowing = false;

  static void showProgress(BuildContext context) {
    if (!Platform.isIOS) {
      if (!_isShowing) {
        _isShowing = true;
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return new LoadingDialog(
                text: "Loading…",
              );
            });
      }
    }
  }

  static void dismiss(BuildContext context) {
    if (!Platform.isIOS) {
      if (_isShowing) {
        Navigator.pop(context);
        _isShowing = false;
      }
    }
  }
}

class LoadingDialog extends Dialog {
  final String text;

  LoadingDialog({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: new Center(
        child: new SizedBox(
          width: 140.0,
          height: 120.0,
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new CircularProgressIndicator(),
                new Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: new Text(text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
