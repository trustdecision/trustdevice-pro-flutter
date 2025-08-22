#import "TrustdeviceSePlugin.h"
#import <TDMobRisk/TDMobRisk.h>

@interface TrustdeviceSePlugin()

@end

static FlutterMethodChannel* _channel = nil;

@implementation TrustdeviceSePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"trustdevice_se_plugin"
                                     binaryMessenger:[registrar messenger]];
    TrustdeviceSePlugin* instance = [[TrustdeviceSePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    _channel = channel;
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
    } else if ([@"initWithOptions" isEqualToString:call.method]) {
        TDDeviceManager_t *manager = [TDDeviceManager sharedManager];
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
    } else if ([@"getDeviceInfo" isEqualToString:call.method]) {
        TDDeviceManager_t *manager = [TDDeviceManager sharedManager];
        
        manager->getDeviceInfo(^(TDDeviceResponse response){
            // 切换到主线程（Flutter result 必须在主线程调用）
            dispatch_async(dispatch_get_main_queue(), ^{
                
                int code = response.apiStatus.code;
                if (code == 0) { // 成功
                    // 创建结果字典
                    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
                    
                    // 添加所有字段
                    resultDict[@"code"] = @(code);
                    resultDict[@"fpVersion"] = @(response.fpVersion); // char* -> NSString
                    resultDict[@"blackBox"] = @(response.blackBox);
                    resultDict[@"anonymousId"] = @(response.anonymousId);
                    resultDict[@"message"] = @(response.apiStatus.message);
                    resultDict[@"sealedResult"] = @(response.sealedResult);
                    resultDict[@"deviceRiskScore"] = @(response.deviceRiskScore);
                    
                    // 返回成功结果
                    result(resultDict);
                    
                } else { // 失败
                    // 创建错误字典
                    NSDictionary *errorDict = @{
                        @"code": @(code),
                        @"message": @(response.apiStatus.message),
                        @"details": @"" // 处理可能的空值
                    };
                    
                    // 返回错误（使用 Flutter 标准错误格式）
                    result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d", code]
                                            message:@(response.apiStatus.message)
                                            details:errorDict]);
                }
            });
        });

    } else if ([@"getSDKVersion" isEqualToString:call.method]) {
        TDDeviceManager_t *manager = [TDDeviceManager sharedManager];
        NSString* version = manager->getSDKVersion();
        result(version);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
