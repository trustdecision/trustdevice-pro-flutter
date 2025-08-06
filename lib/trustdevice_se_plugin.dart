import 'trustdevice_se_plugin_platform_interface.dart';

// // 关键：重新导出需要的类
// export 'trustdevice_se_plugin_platform_interface.dart' 
//     show TDDeviceInfoCallback, TDDeviceAPIStatus; // 添加这行

class TrustdeviceSePlugin {
  ///Initialize the configuration and return to blackBox
  Future<void> initWithOptions(Map<String, dynamic> configMap) {
    return TrustdeviceSePluginPlatform.instance.initWithOptions(configMap);
  }

  Future<Map<String, dynamic>>  getDeviceInfo() {
    return TrustdeviceSePluginPlatform.instance.getDeviceInfo();
  } 

  ///Obtain the sdk version number
  Future<String> getSDKVersion() {
    return TrustdeviceSePluginPlatform.instance.getSDKVersion();
  }

}







