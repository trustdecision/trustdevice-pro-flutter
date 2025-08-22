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
import java.util.Map;

import com.trustdecision.mobrisk.TDDeviceManager;
import com.trustdecision.mobrisk.TDDeviceInfoCallback;
import com.trustdecision.mobrisk.TDDeviceAPIStatus;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * TrustdeviceSePlugin
 */
public class TrustdeviceSePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
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
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "trustdevice_se_plugin");
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

                    // SDK初始化配置，标准版
                    TDDeviceManager.Builder builder = TDFultterRiskUtils.mapToBuilderSe(configMap);
                    TDDeviceManager.initWithOptions(mApplicationContext, builder);

                }
            });

        } else if (call.method.equals("getDeviceInfo")) {
            mHandler.post(new Runnable() {
                @Override
                public void run() {
                    TDDeviceManager.getDeviceInfo(new TDDeviceInfoCallback() {
                        @Override
                        public void onResult(String fpVersion,
                                            String blackBox,
                                            String anonymousId,
                                            int deviceRiskScore,
                                            TDDeviceAPIStatus apiStatus,
                                            String sealedResult) {
                            // 注：原生回调在子线程中执行，需切换回主线程处理Flutter结果
                            mMainHandler.post(new Runnable() {
                                @Override
                                public void run() {
                                    // 统一封装所有返回字段（包括TDDeviceAPIStatus）
                                    Map<String, Object> resultData = new HashMap<>();
                                    resultData.put("blackBox", blackBox);
                                    resultData.put("fpVersion", fpVersion);
                                    resultData.put("anonymousId", anonymousId);
                                    resultData.put("deviceRiskScore", deviceRiskScore);
                                    resultData.put("sealedResult", sealedResult);
                                    
                                    // 新增：添加TDDeviceAPIStatus的详细信息
                                    Map<String, Object> statusData = new HashMap<>();
                                    statusData.put("code", apiStatus.getCode());
                                    statusData.put("message", apiStatus.getMessage()); // 假设有getMsg()方法
                                    resultData.put("apiStatus", statusData);

                                    // 返回结果
                                    if (apiStatus.getCode() == 0) {
                                        result.success(resultData);
                                    } else {
                                        result.error(String.valueOf(apiStatus.getCode()),apiStatus.getMessage(),null);
                                    }
                                }
                            });
                        }
                    });
                }
            });
        } else if (call.method.equals("getSDKVersion")) {
            String sdkVersion = TDDeviceManager.getSDKVersion();
            result.success(sdkVersion);
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
