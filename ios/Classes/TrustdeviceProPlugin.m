#import "TrustdeviceProPlugin.h"
#import <TDMobRisk/TDMobRisk.h>
@implementation TrustdeviceProPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"trustdevice_pro_plugin"
            binaryMessenger:[registrar messenger]];
  TrustdeviceProPlugin* instance = [[TrustdeviceProPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }else if ([@"initWithOptions" isEqualToString:call.method]) {
        TDMobRiskManager_t *manager = [TDMobRiskManager sharedManager];
        NSDictionary* configOptions = call.arguments;
        NSMutableDictionary *options = [[NSMutableDictionary alloc] initWithDictionary:configOptions];
        
        // 参数处理
        id allowedObj = options[@"debug"];
        if([allowedObj isKindOfClass:[NSNumber class]]){
            if([allowedObj boolValue] == YES){
                options[@"allowed"] = @"allowed";
            }
        }
        
        id locationObj = options[@"location"];
        if([locationObj isKindOfClass:[NSNumber class]]){
            if([locationObj boolValue] == NO){
                options[@"noLocation"] = @"noLocation";
            }
        }
        
        id IDFAObj = options[@"IDFA"];
        if([IDFAObj isKindOfClass:[NSNumber class]]){
            if([IDFAObj boolValue] == NO){
                options[@"noIDFA"] = @"noIDFA";
            }
        }
        
        id deviceNameObj = options[@"deviceName"];
        if([deviceNameObj isKindOfClass:[NSNumber class]]){
            if([deviceNameObj boolValue] == NO){
                options[@"noDeviceName"] = @"noDeviceName";
            }
        }
        
        /// 这个无法用textView设置，只能默认设置
        manager->initWithOptions([options copy]);
    }else if ([@"getBlackbox" isEqualToString:call.method]) {
        TDMobRiskManager_t *manager = [TDMobRiskManager sharedManager];
        NSString* blackBox = manager->getBlackBox();
        result(blackBox);
    }else if ([@"getBlackboxAsync" isEqualToString:call.method]) {
        TDMobRiskManager_t *manager = [TDMobRiskManager sharedManager];
        manager->getBlackBoxAsync(^(NSString* blackBox){
            result(blackBox);
        });
    }
    else if ([@"getSDKVersion" isEqualToString:call.method]) {
        TDMobRiskManager_t *manager = [TDMobRiskManager sharedManager];
        NSString* version = manager->getSDKVersion();
        result(version);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
