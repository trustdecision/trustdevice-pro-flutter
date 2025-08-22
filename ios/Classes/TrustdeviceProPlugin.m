#import "TrustdeviceProPlugin.h"
#import "TrustdeviceSePlugin.h" // 导入子类头文件
#import <TDMobRisk/TDMobRisk.h>

@interface TrustdeviceProPlugin()

@end

static FlutterMethodChannel* _channel = nil;

@implementation TrustdeviceProPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"trustdevice_pro_plugin"
                                     binaryMessenger:[registrar messenger]];
    TrustdeviceProPlugin* instance = [[TrustdeviceProPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    _channel = channel;

    // 2. 注册子功能
    [TrustdeviceSePlugin registerWithRegistrar:registrar];
}

- (UIWindow *)getKeyWindow
{
    if (@available(iOS 13.0, *))
    {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive)
            {
                for (UIWindow *window in windowScene.windows)
                {
                    if (window.isKeyWindow)
                    {
                        return window;
                    }
                }
            }
        }
    }
    else
    {
        return [UIApplication sharedApplication].keyWindow;
    }
    return nil;
}

- (UIViewController *)getRootViewController
{
    UIWindow *keyWindow = [self getKeyWindow];
    UIViewController*rootViewController = keyWindow.rootViewController;
    return rootViewController;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }else if ([@"initWithOptions" isEqualToString:call.method]) {
        TDMobRiskManager_t *manager = [TDMobRiskManager sharedManager];
        NSDictionary* configOptions = call.arguments;
        NSMutableDictionary *options = [[NSMutableDictionary alloc] initWithDictionary:configOptions];
        
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
        
        manager->initWithOptions([options copy]);
    }else if ([@"getBlackBox" isEqualToString:call.method]) {
        TDMobRiskManager_t *manager = [TDMobRiskManager sharedManager];
        NSString* blackBox = manager->getBlackBox();
        result(blackBox);
    }else if ([@"getBlackBoxAsync" isEqualToString:call.method]) {
        TDMobRiskManager_t *manager = [TDMobRiskManager sharedManager];
        manager->getBlackBoxAsync(^(NSString* blackBox){
            dispatch_async(dispatch_get_main_queue(), ^{
                result(blackBox);
            });
        });
    }
    else if ([@"getSDKVersion" isEqualToString:call.method]) {
        TDMobRiskManager_t *manager = [TDMobRiskManager sharedManager];
        NSString* version = manager->getSDKVersion();
        result(version);
    }else if ([@"showCaptcha" isEqualToString:call.method]) {
        TDMobRiskManager_t *manager = [TDMobRiskManager sharedManager];
        UIWindow *keyWindow = [self getKeyWindow];
        manager->showCaptcha(keyWindow,^(TDShowCaptchaResultStruct resultStruct) {
            NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionary];
            switch (resultStruct.resultType) {
                case TDShowCaptchaResultTypeSuccess:
                    resultDictionary[@"function"] = @"onSuccess";
                    resultDictionary[@"token"] = @(resultStruct.validateToken);
                    break;
                case TDShowCaptchaResultTypeFailed:
                    resultDictionary[@"function"] = @"onFailed";
                    resultDictionary[@"errorCode"] = @(resultStruct.errorCode);
                    resultDictionary[@"errorMsg"] = @(resultStruct.errorMsg);
                    break;
                case TDShowCaptchaResultTypeReady:
                    resultDictionary[@"function"] = @"onReady";
                    break;
                default:
                    break;
            }
            [_channel invokeMethod:@"showCaptcha" arguments:resultDictionary];
        });
    }else if ([@"getRootViewController" isEqualToString:call.method]) {
        UIViewController*rootViewController = [self getRootViewController];
        result(rootViewController);
    }else if ([@"showLiveness" isEqualToString:call.method]) {
        TDMobRiskManager_t *manager = [TDMobRiskManager sharedManager];
        
        NSDictionary* configOptions = call.arguments;
        NSMutableDictionary *options = [[NSMutableDictionary alloc] initWithDictionary:configOptions];
        
        UIViewController*targetVC = [self getRootViewController];
        
        NSString*license = options[@"license"];
        
        TDLivenessShowStyle showStyle = TDLivenessShowStylePresent;
        
        manager->showLivenessWithShowStyle(targetVC,license,showStyle,^(TDLivenessResultStruct resultStruct) {
            NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionary];
            
            if(resultStruct.resultType == TDLivenessResultTypeSuccess){
                resultDictionary[@"function"] = @"onSuccess";
                if(resultStruct.seqId){
                    resultDictionary[@"seqId"] = @(resultStruct.seqId);
                }else{
                    resultDictionary[@"seqId"] = @"";
                }
                resultDictionary[@"errorCode"] = @(resultStruct.errorCode);
                if(resultStruct.errorMsg){
                    resultDictionary[@"errorMsg"] = @(resultStruct.errorMsg);
                }else{
                    resultDictionary[@"errorMsg"] = @"";
                }
                resultDictionary[@"score"] = @(resultStruct.score);
                if(resultStruct.bestImageString){
                    resultDictionary[@"bestImageString"] = @(resultStruct.bestImageString);
                }else{
                    resultDictionary[@"bestImageString"] = @"";
                }
                if(resultStruct.livenessId){
                    resultDictionary[@"livenessId"] = @(resultStruct.livenessId);
                }else{
                    resultDictionary[@"livenessId"] = @"";
                }
                
            }else{
                resultDictionary[@"function"] = @"onFailed";
                if(resultStruct.seqId){
                    resultDictionary[@"seqId"] = @(resultStruct.seqId);
                }else{
                    resultDictionary[@"seqId"] = @"";
                }
                resultDictionary[@"errorCode"] = @(resultStruct.errorCode);
                if(resultStruct.errorMsg){
                    resultDictionary[@"errorMsg"] = @(resultStruct.errorMsg);
                }else{
                    resultDictionary[@"errorMsg"] = @"";
                }
                if(resultStruct.livenessId){
                    resultDictionary[@"livenessId"] = @(resultStruct.livenessId);
                }else{
                    resultDictionary[@"livenessId"] = @"";
                }
            }
            [_channel invokeMethod:@"showLiveness" arguments:resultDictionary];
        });
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
