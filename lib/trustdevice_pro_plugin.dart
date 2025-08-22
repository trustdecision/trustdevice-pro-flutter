import 'trustdevice_pro_plugin_platform_interface.dart';

export 'trustdevice_se_plugin.dart'; // 在pro_plugin中暴露se_plugin


enum TDLivenessShowStyle {

    Push,

    Present,
}


class TrustdeviceProPlugin {
  ///Obtain the sdk version number
  Future<String> getSDKVersion() {
    return TrustdeviceProPluginPlatform.instance.getSDKVersion();
  }

  ///Initialize the configuration and return to blackBox
  Future<void> initWithOptions(Map<String, dynamic> configMap) {
    return TrustdeviceProPluginPlatform.instance.initWithOptions(configMap);
  }

  ///Get blackBox
  Future<String> getBlackBox() {
    return TrustdeviceProPluginPlatform.instance.getBlackBox();
  }

  ///Get blackBox Async
  Future<String> getBlackBoxAsync() {
    return TrustdeviceProPluginPlatform.instance.getBlackBoxAsync();
  }

  ///showCaptcha
  Future<void> showCaptcha(TDRiskCaptchaCallback callback) {
    return TrustdeviceProPluginPlatform.instance.showCaptcha(callback);
  }

  ///showLiveness
  Future<void> showLiveness(String license,TDLivenessCallback callback) {
    return TrustdeviceProPluginPlatform.instance.showLiveness(license,callback);
  }

}

class TDRisk {
  ///Mandatory Shared Configuration
  static const KEY_PARTNER = "partner";
  static const KEY_APPKEY = "appKey";
  static const KEY_APPNAME = "appName";
  static const KEY_COUNTRY = "country";
  static const KEY_DEBUG = "debug";
  static const KEY_TIME_LIMIT = "timeLimit";
  static const KEY_LOCATION = "location";
  static const KEY_COLLECT_LEVEL = "collectLevel";

  ///Android device fingerprint configuration
  static const KEY_FP_ANDROID_RUNNING_TASKS = "runningTasks";
  static const KEY_FP_ANDROID_SENSOR = "sensor";
  static const KEY_FP_ANDROID_READ_PHONE = "readPhone";
  static const KEY_FP_ANDROID_INSTALLPACKAGE_LIST = "installPackageList";
  static const KEY_FP_ANDROID_GOOGLE_AID = "googleAid";

  ///IOS device fingerprint configuration
  static const KEY_FP_IOS_IDFA = "IDFA";
  static const KEY_FP_IOS_DEVICENAME = "deviceName";
}

typedef VoidCallback = void Function();

class TDRiskCaptchaCallback {
  final void Function() onReady;
  final void Function(String token) onSuccess;
  final void Function(int errorCode, String errorMsg) onFailed;

  const TDRiskCaptchaCallback({
    required this.onReady,
    required this.onSuccess,
    required this.onFailed,
  });
}



class TDLivenessCallback {
  final void Function(String seqId,int errorCode,String errorMsg,double score,String bestImageString,String livenessId) onSuccess;
  final void Function(String seqId,int errorCode,String errorMsg,String livenessId) onFailed;

  const TDLivenessCallback({
    required this.onSuccess,
    required this.onFailed,
  });
}
