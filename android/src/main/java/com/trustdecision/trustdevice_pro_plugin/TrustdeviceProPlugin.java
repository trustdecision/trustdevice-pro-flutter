package com.trustdecision.trustdevice_pro_plugin;

import android.app.Activity;
import android.content.Context;
import android.os.Build;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;

import androidx.annotation.NonNull;
import org.json.JSONObject;

import java.util.HashMap;

import cn.tongdun.mobrisk.TDRisk;
import cn.tongdun.mobrisk.TDRiskCallback;
import cn.tongdun.mobrisk.TDRiskCaptchaCallback;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * TrustdeviceProPlugin
 */
public class TrustdeviceProPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Handler mHandler;
    private Handler mMainHandler;
    private HandlerThread mHandlerThread;
    private Context mApplicationContext;
    private Activity mActivity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "trustdevice_pro_plugin");
        channel.setMethodCallHandler(this);
        mApplicationContext = flutterPluginBinding.getApplicationContext();
        mHandlerThread = new HandlerThread("TDFlutterPlugin_android");
        mHandlerThread.start();
        mHandler = new Handler(mHandlerThread.getLooper());
        mMainHandler = new Handler(Looper.getMainLooper());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("initWithOptions")) {
            mHandler.post(new Runnable() {
                @Override
                public void run() {
                    HashMap<String, Object> configMap = call.arguments();
                    // SDK初始化配置
                    TDRisk.Builder builder = TDFultterRiskUtils.mapToBuilder(configMap);
                    TDRisk.initWithOptions(mApplicationContext, builder);
                }
            });

        } else if (call.method.equals("getBlackbox")) {
            mHandler.post(new Runnable() {
                @Override
                public void run() {
                    String blackbox = TDRisk.getBlackBox();
                    mMainHandler.post(new Runnable() {
                        @Override
                        public void run() {
                            result.success(blackbox);
                        }
                    });
                }
            });
        } else if (call.method.equals("getBlackboxAsync")) {
            mHandler.post(new Runnable() {
                @Override
                public void run() {
                    TDRisk.getBlackBox(new TDRiskCallback() {
                        @Override
                        public void onEvent(String blackbox) {
                            mMainHandler.post(new Runnable() {
                                @Override
                                public void run() {
                                    result.success(blackbox);
                                }
                            });
                        }
                    });
                }
            });
        } else if (call.method.equals("getSDKVersion")) {
            String sdkVersion = TDRisk.getSDKVersion();
            result.success(sdkVersion);
        } else if (call.method.equals("showCaptcha")) {
            if (mActivity != null) {
                TDRisk.showCaptcha(mActivity, new TDRiskCaptchaCallback() {
                    @Override
                    public void onReady() {
                        HashMap<String, Object> argMap = new HashMap<>();
                        argMap.put("function", "onReady");
                        channel.invokeMethod("showCaptcha", argMap);
                    }

                    @Override
                    public void onSuccess(String token) {
                        HashMap<String, Object> argMap = new HashMap<>();
                        argMap.put("function", "onSuccess");
                        argMap.put("token", token);
                        channel.invokeMethod("showCaptcha", argMap);
                    }

                    @Override
                    public void onFailed(int errorCode, String errorMsg) {
                        HashMap<String, Object> argMap = new HashMap<>();
                        argMap.put("function", "onFailed");
                        argMap.put("errorCode", errorCode);
                        argMap.put("errorMsg", errorMsg);
                        channel.invokeMethod("showCaptcha", argMap);
                    }
                });
            }

        }else if (call.method.equals("showLiveness")) {
            HashMap<String, Object> configMap = call.arguments();
            TDRisk.showLiveness(configMap.get((String)"license"), new TDRiskLivenessCallback() {
                @Override
                public void onSuccess(String token) {
                    HashMap<String, Object> argMap = new HashMap<>();
                    try {
                        argMap.put("function", "onSuccess");
                        argMap.put("token", token);
                        JSONObject livenessresult = new JSONObject(response);
                    } catch (Throwable e) {

                    }
                    channel.invokeMethod("showLiveness", argMap);
                }

                @Override
                public void onError(String errorCode, String errorMsg, String sequenceId) {
                    HashMap<String, Object> argMap = new HashMap<>();
                    argMap.put("function", "onFailed");
                    argMap.put("errorCode", errorCode);
                    argMap.put("errorMsg", errorMsg);
                    argMap.put("sequenceId", sequenceId);
                    channel.invokeMethod("showLiveness", argMap);
                }
            });

        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        if (mHandlerThread != null)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
                mHandlerThread.quitSafely();
            }
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        mActivity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {
        mActivity = null;
    }
}
