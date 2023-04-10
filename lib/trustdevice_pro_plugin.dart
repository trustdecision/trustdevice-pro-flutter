import 'trustdevice_pro_plugin_platform_interface.dart';

class TrustdeviceProPlugin {
  /**
   * Obtain the sdk version number
   */
  Future<String> getSDKVersion() {
    return TrustdeviceProPluginPlatform.instance.getSDKVersion();
  }

  /**
   *Initialize the configuration and return to blackbox
   */
  Future<String> initWithOptions(Map<String, dynamic> configMap) {
    return TrustdeviceProPluginPlatform.instance.initWithOptions(configMap);
  }

  /**
   *Get blackbox
   */
  Future<String> getBlackbox() {
    return TrustdeviceProPluginPlatform.instance.getBlackbox();
  }
}

class TDRisk {
  //Mandatory Shared Configuration
  static const KEY_PARTNER = "partner";
  static const KEY_APPKEY = "appKey";
  static const KEY_APPNAME = "appName";
  static const KEY_COUNTRY = "country";

  //Optional co ownership configuration (behavior validation configuration)
  static const KEY_PB_LANGUAGE = "language";
  static const KEY_PB_TAPTOCLOSE = "tapToClose";
  static const KEY_PB_NEEDSEQID = "needSeqid";
  static const KEY_PB_HIDELOADHUB = "hideLoadHud";
  static const KEY_PB_HIDEWEBCLOSEBUTTON = "hideWebCloseButton";
  static const KEY_PB_OPENLOG = "openLog";
  static const KEY_PB_SKIPCAPTCHA = "skipCaptcha";
  static const KEY_PB_MFAID = "mfaId";

  //Android device fingerprint configuration
  static const KEY_FP_ANDROID_TIMELIMIT = "httpTimeout";
  static const KEY_FP_ANDROID_COLLECTLEVEL = "collectLevel";
  static const KEY_FP_ANDROID_BLACKBOX_MAXSIZE = "blackBoxMaxSize";
  static const KEY_FP_ANDROID_CUSTOM_PROCESSNAME = "customProcessName";
  static const KEY_FP_ANDROID_FORCE_TLSVERSION = "forceTLSVersion";
  static const KEY_FP_ANDROID_DISABLE_DEBUGGER = "disableDebugger";
  static const KEY_FP_ANDROID_DISABLE__RUNNINGTASKS = "disableRunningTasks";
  static const KEY_FP_ANDROID_DISABLE__GPS = "disableGPS";
  static const KEY_FP_ANDROID_DISABLE__SENSOR = "disableSensor";
  static const KEY_FP_ANDROID_DISABLE__READPHONE = "disableReadPhone";
  static const KEY_FP_ANDROID_DISABLE__PACKAGELIST = "disableInstallPackageList";

  //IOS device fingerprint configuration
  static const KEY_FP_IOS_TIMELIMIT = "timeLimit";
  static const KEY_FP_IOS_COLLECTLEVEL = "collectLevel";
  static const KEY_FP_IOS_ALLOWED = "allowed";
  static const KEY_FP_IOS_NOLOCATION = "noLocation";
  static const KEY_FP_IOS_NOIDFA = "noIDFA";
  static const KEY_FP_IOS_NODEVICENAME = "noDeviceName";
}
