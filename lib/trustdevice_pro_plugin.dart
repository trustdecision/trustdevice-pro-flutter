// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'trustdevice_pro_plugin_platform_interface.dart';

class TrustdeviceProPlugin {
  ///Obtain the sdk version number
  Future<String> getSDKVersion() {
    return TrustdeviceProPluginPlatform.instance.getSDKVersion();
  }

  ///Initialize the configuration and return to blackbox
  @Deprecated('use initWithConfigurations instead')
  Future<void> initWithOptions(Map<String, dynamic> configMap) {
    return TrustdeviceProPluginPlatform.instance.initWithOptions(configMap);
  }

  ///Initialize the configuration and return to blackbox
  Future<void> initWithConfigurations(TDRiskConfiguration configuration) {
    return TrustdeviceProPluginPlatform.instance
        .initWithOptions(configuration.toJson());
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

class TDRiskConfiguration {
  TDRiskConfiguration({
    required this.partner,
    required this.appKey,
    required this.appName,
    required this.country,
    this.debug,
    this.timeLimit,
    this.location,
    this.collectLevel,
    this.android,
    this.ios,
    this.captcha,
    this.customConfiguration,
  });

  /// Partner code
  ///
  /// Partner, please contact TrustDecision to obtain
  final String partner;

  /// App key
  ///
  /// Appkey, please offer your App bundleId for TrustDecision to obtain
  /// appkey creation requires the user to provide the application bundleId.
  /// ⚠️ Different values for bundleId are used for different applications
  final String appKey;

  /// App name
  ///
  /// AppName, please contact TrustDecision to obtain
  final String appName;

  /// Country code
  ///
  /// need pass a [TDRiskCountry]
  final TDRiskCountry country;

  /// Whether allow debug
  ///
  /// default is false,After the SDK is integrated,
  /// the app has the anti-debugging function by default.
  ///
  /// * Develop: Please set value to true.
  /// * Release: Please not set this key or set value to false
  final bool? debug;

  /// SDK timeout interval Configuration (unit: seconds)
  ///
  /// Timeout interval of network request callback after SDK initialization.
  /// Default is 15s.
  final int? timeLimit;

  /// Whether collect location information
  ///
  /// default is true,SDK will collect location if the app has been
  /// authorized to get location information.
  ///
  /// * true: allow collect location information;
  /// * false: not allow collect location information
  final bool? location;

  /// Degraded blackbox length configuration
  ///
  /// Degraded blackbox will be longer. This configuration allows you to control the length of the degraded blackbox.
  ///
  /// * [TDRiskCollectLevel.medium] After setting, the degraded blackbox length is about 2000 characters;
  /// * [TDRiskCollectLevel.large] default value, after setting, the degraded length is about 5000 characters
  final TDRiskCollectLevel? collectLevel;

  /// Android Platform Configurations
  final TDRiskAndroidConfiguration? android;

  /// IOS Platform Configurations
  final TDRiskIOSConfiguration? ios;

  /// Captcha Module Configurations
  final TDRiskCaptchaConfiguration? captcha;

  /// Custom Configuration
  final Map<String, dynamic>? customConfiguration;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'partner': partner,
      'appKey': appKey,
      'appName': appName,
      'country': country.code,
      'debug': debug,
      'timeLimit': timeLimit,
      'location': location,
      'collectLevel': collectLevel?.rawValue,
      if (android != null) ...android!.toJson(),
      if (ios != null) ...ios!.toJson(),
      if (captcha != null) ...captcha!.toJson(),
      if (customConfiguration != null) ...customConfiguration!,
    }..removeWhere((key, value) => value == null);
  }
}

class TDRiskCountry {
  const TDRiskCountry(this.code);
  final String code;

  /// China
  static const china = TDRiskCountry('cn');

  /// Singapore
  static const singapore = TDRiskCountry('sg');

  /// North America
  static const northAmerica = TDRiskCountry('us');

  /// Europe
  static const europe = TDRiskCountry('eu');
}

enum TDRiskCollectLevel {
  /// After setting, the degraded blackbox length is about 2000 characters
  medium('M'),

  /// After setting, the degraded length is about 5000 characters
  large('L'),
  ;

  const TDRiskCollectLevel(this.rawValue);
  final String rawValue;
}

class TDRiskAndroidConfiguration {
  /// Android Platform Configuration
  const TDRiskAndroidConfiguration({
    this.blackBoxMaxSize,
    this.customProcessName,
    this.forceTLSVersion,
    this.runningTasks,
    this.sensor,
    this.readPhone,
    this.installPackageList,
  });

  /// blackbox maximum length
  ///
  /// The default length is Integer.MAX_VALUE,
  /// it will increase according to the actual device situation
  final int? blackBoxMaxSize;

  /// custom process name
  ///
  /// change the name of the SDK's process
  final String? customProcessName;

  /// Whether https is mandatory to use TLS-v1.1 version
  ///
  /// default is false, and the developer can set the corresponding settings
  /// according to the specific situation.
  ///
  /// * true: use TLS-v1.1 version
  /// * false: not use TLS-v1.1 version
  final bool? forceTLSVersion;

  /// Whether allow getting running tasks
  ///
  /// default is true.
  ///
  /// * true: allow getting running tasks;
  /// * false: not allow getting running tasks
  final bool? runningTasks;

  /// Whether collect sensor information
  ///
  /// default is true,SDK will collect sensor-related information.
  ///
  /// * true: collect sensor information;
  /// * false: not collect sensor information
  final bool? sensor;

  /// Whether collect [READ_PHONE_STATE](https://developer.android.com/reference/android/Manifest.permission#READ_PHONE_STATE) related information
  ///
  /// default is true,SDK will collect READ_PHONE_STATE information
  /// if app gained READ_PHONE_STATE permission
  ///
  /// * true: collect READ_PHONE_STATE related information;
  /// * false: not collect READ_PHONE_STATE related information
  final bool? readPhone;

  /// Whether collect the list of installation packages
  ///
  /// default is true,SDK will collect the list of installation packages.
  ///
  /// * true: collect the list of installation packages;
  /// * false: not collect the list of installation packages
  final bool? installPackageList;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'blackBoxMaxSize': blackBoxMaxSize,
      'customProcessName': customProcessName,
      'forceTLSVersion': forceTLSVersion,
      'runningTasks': runningTasks,
      'sensor': sensor,
      'readPhone': readPhone,
      'installPackageList': installPackageList,
    };
  }
}

class TDRiskIOSConfiguration {
  /// iOS Platform Configuration
  const TDRiskIOSConfiguration({
    this.idfa,
    this.deviceName,
  });

  /// Whether collect Advertising Identifier (IDFA) information
  ///
  /// default is true,SDK will collect IDFA information if the app has been authorized to get IDFA information.
  /// Options:
  /// * true: allow collect IDFA information;
  /// * false: not allow collect IDFA information
  final bool? idfa;

  /// Whether collect device's name information
  ///
  /// default is true,SDK will collect device's name information.
  /// Options:
  /// * true: allow collect device's name information;
  /// * false: not allow collect device's name information
  final bool? deviceName;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'IDFA': idfa,
      'deviceName': deviceName,
    };
  }
}

class TDRiskCaptchaConfiguration {
  const TDRiskCaptchaConfiguration({
    this.language,
    this.tapToClose,
    this.needSeqid,
    this.hideLoadHud,
    this.hideWebCloseButton,
    this.openLog,
    this.skipCaptcha,
    this.mfaId,
  });

  /// language type, default is Simplified Chinese
  ///
  /// Chinese mainland support:
  /// * Simplified Chinese
  /// * Traditional Chinese
  /// * English
  /// * Japanese
  /// * Korean
  ///
  /// overseas support:
  /// * Simplified Chinese
  /// * Traditional Chinese
  /// * English
  /// * Japanese
  /// * Korean
  /// * Malay
  /// * Thai
  /// * Indonesian
  /// * Russian
  final CaptchaLanguage? language;

  /// Click on the blank space to close the Captcha window
  ///
  /// default is false
  ///
  /// After opening, click on the blank area of the interface
  /// to close the Captcha window, which is more convenient
  /// to close the pop-up window
  final bool? tapToClose;

  /// Whether to carry the seqid in the failure callback message
  ///
  /// default is true
  ///
  /// When enabled, the seqid serial number will be carried
  /// in the failure message, and the seqid will be provided
  /// to TrustDecision for easy troubleshooting Reason for failure
  final bool? needSeqid;

  /// Whether to skip the loading animation
  ///
  /// default is false
  ///
  /// When enabled, the loading animation will not be displayed
  /// when the Captcha window pops up, shortening the verification time
  final bool? hideLoadHud;

  /// Whether to hide the close button of the webview
  ///
  /// default is false
  ///
  /// Scenarios that need to be forced to complete the Captcha
  final bool? hideWebCloseButton;

  /// Whether to open the log
  ///
  /// default is false
  ///
  /// When enabled, the console will output more log information
  /// during debugging, which is convenient for troubleshooting
  final bool? openLog;

  /// Whether to skip the TrustDecision Captcha verification
  ///
  /// default is false
  ///
  /// When enabled, the Captcha will not be verified,
  /// and a 4000 error code will be returned at the same time,
  /// which is used for dynamic settings Whether
  /// to use TrustDecision Captcha SDK verification
  final bool? skipCaptcha;

  /// MFA ID
  ///
  /// If you have connected to the
  /// MFA product (the description can be ignored if the MFA is not connected),
  /// please set the mfaId which is obtained from the MFA process
  /// to the configuration parameter.
  final String? mfaId;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'language': language?.code,
      'tapToClose': tapToClose,
      'needSeqid': needSeqid,
      'hideLoadHud': hideLoadHud,
      'hideWebCloseButton': hideWebCloseButton,
      'openLog': openLog,
      'skipCaptcha': skipCaptcha,
      'mfaId': mfaId,
    };
  }
}

class CaptchaLanguage {
  const CaptchaLanguage(this.code);
  final String code;

  /// Simplified Chinese
  static const simplifiedChinese = CaptchaLanguage('1');

  /// Traditional Chinese
  static const traditionalChinese = CaptchaLanguage('2');

  /// English
  static const english = CaptchaLanguage('3');

  /// Japanese
  static const japanese = CaptchaLanguage('4');

  /// Korean
  static const korean = CaptchaLanguage('5');

  /// Malay
  static const malay = CaptchaLanguage('6');

  /// Thai
  static const thai = CaptchaLanguage('7');

  /// Indonesian
  static const indonesian = CaptchaLanguage('8');

  /// Russian
  static const russian = CaptchaLanguage('9');
}

@Deprecated('use TDRiskConfiguration instead')
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
