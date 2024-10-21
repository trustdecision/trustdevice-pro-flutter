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
import cn.tongdun.mobrisk.TDRiskLivenessCallback;
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

        } else if (call.method.equals("getBlackBox")) {
            mHandler.post(new Runnable() {
                @Override
                public void run() {
                    String blackBox = TDRisk.getBlackBox();
                    mMainHandler.post(new Runnable() {
                        @Override
                        public void run() {
                            result.success(blackBox);
                        }
                    });
                }
            });
        } else if (call.method.equals("getBlackBoxAsync")) {
            mHandler.post(new Runnable() {
                @Override
                public void run() {
                    TDRisk.getBlackBox(new TDRiskCallback() {
                        @Override
                        public void onEvent(String blackBox) {
                            mMainHandler.post(new Runnable() {
                                @Override
                                public void run() {
                                    result.success(blackBox);
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

        } else if (call.method.equals("showLiveness")) {
            mMainHandler.post(new Runnable() {
                @Override
                public void run() {
                    HashMap<String, Object> configMap = call.arguments();
                    TDRisk.showLiveness((String) configMap.get("license"), new TDRiskLivenessCallback() {
                        @Override
                        public void onSuccess(String jsonStr) {
                            mMainHandler.post(new Runnable() {
                                @Override
                                public void run() {
                                    HashMap<String, Object> argMap = new HashMap<>();
                                    try {
                                        JSONObject livenessresult = new JSONObject(jsonStr);
                                        argMap.put("seqId", livenessresult.getString("sequence_id"));
                                        argMap.put("errorCode", livenessresult.getInt("code"));
                                        argMap.put("errorMsg", livenessresult.getString("message"));
                                        argMap.put("score", livenessresult.getDouble("score"));
                                        argMap.put("bestImageString", livenessresult.getString("image"));
                                        argMap.put("livenessId", livenessresult.getString("liveness_id"));
                                    } catch (Throwable e) {
                                    }
                                    argMap.put("function", "onSuccess");
                                    channel.invokeMethod("showLiveness", argMap);
                                }
                            });
                        }

                        @Override
                        public void onError(String errorCode, String errorMsg, String sequenceId) {
                            mMainHandler.post(new Runnable() {
                                @Override
                                public void run() {
                                    HashMap<String, Object> argMap = new HashMap<>();
                                    argMap.put("function", "onFailed");
                                    argMap.put("errorCode", Integer.valueOf(errorCode));
                                    argMap.put("errorMsg", errorMsg);
                                    argMap.put("seqId", sequenceId);
                                    argMap.put("livenessId", "");
                                    channel.invokeMethod("showLiveness", argMap);
                                }
                            });
                        }
                    });
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
