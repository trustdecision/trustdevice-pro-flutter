import 'trustdevice_pro_plugin_platform_interface.dart';

class TrustdeviceProPlugin {
  ///Obtain the sdk version number
  Future<String> getSDKVersion() {
    return TrustdeviceProPluginPlatform.instance.getSDKVersion();
  }

  ///Initialize the configuration and return to blackbox
  Future<void> initWithOptions(Map<String, dynamic> configMap) {
    return TrustdeviceProPluginPlatform.instance.initWithOptions(configMap);
  }

  ///Get blackbox
  Future<String> getBlackbox() {
    return TrustdeviceProPluginPlatform.instance.getBlackbox();
  }

  ///Get blackbox Async
  Future<String> getBlackboxAsync() {
    return TrustdeviceProPluginPlatform.instance.getBlackboxAsync();
  }

  ///showCaptcha
  Future<void> showCaptcha(TDRiskCaptchaCallback callback) {
    return TrustdeviceProPluginPlatform.instance.showCaptcha(callback);
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

// void onReady();
//
// void onSuccess(String token);
//
// void onFailed(int errorCode, String errorMsg);
}
