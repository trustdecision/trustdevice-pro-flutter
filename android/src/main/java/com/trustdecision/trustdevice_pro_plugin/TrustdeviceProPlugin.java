package com.trustdecision.trustdevice_pro_plugin;

import android.app.Activity;
import android.content.Context;
import android.os.Build;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;

import androidx.annotation.NonNull;

import org.json.JSONObject;
import android.util.Log;

import java.util.HashMap;
import java.util.Map;
import java.util.Iterator;

import com.trustdecision.mobrisk.TDRisk;
import com.trustdecision.mobrisk.TDRiskCallback;
import com.trustdecision.mobrisk.TDAPISignResult;
import com.trustdecision.mobrisk.TDRiskCaptchaCallback;
import com.trustdecision.mobrisk.TDRiskLivenessCallback;
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

    private TrustdeviceSePlugin sePlugin;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "trustdevice_pro_plugin");
        channel.setMethodCallHandler(this);

        // 初始化并注册子插件
        sePlugin = new TrustdeviceSePlugin();
        sePlugin.onAttachedToEngine(flutterPluginBinding);

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
        }  else if (call.method.equals("sign")) {
            mHandler.post(new Runnable() {
                @Override
                public void run() {
                    // 获取参数
                    String url = call.arguments();

                    TDAPISignResult signResult = TDRisk.sign(mApplicationContext, url);

                    // 获取签名并使用
                    String signature = signResult.signature(); 
                    // 获取错误信息和状态码
                    String message = signResult.message();
                    int code = signResult.code();

                    // 注：原生回调在子线程中执行，需切换回主线程处理Flutter结果
                    mMainHandler.post(new Runnable() {
                        @Override
                        public void run() {
                            // 统一封装所有返回字段（包括 TDAPISignResult）
                            Map<String, Object> resultData = new HashMap<>();
                            resultData.put("sign", signature);
                            resultData.put("code", code);
                            resultData.put("msg", message);
                            
                            result.success(resultData);
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
                                        Iterator<String> keys = livenessresult.keys();
                                        while (keys.hasNext()) {
                                            String key = keys.next();
                                            Object value = livenessresult.opt(key);
                                            argMap.put(key, value);
                                        }
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
                                    argMap.put("code", Integer.valueOf(errorCode));
                                    argMap.put("message", errorMsg);
                                    argMap.put("sequence_id", sequenceId);
                                    argMap.put("liveness_id", "");
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
        // 清理子插件
        if (sePlugin != null) {
            sePlugin.onDetachedFromEngine(binding);
        }

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
