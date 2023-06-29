package com.trustdecision.trustdevice_pro_plugin;

import android.content.Context;
import android.os.Handler;
import android.os.HandlerThread;

import androidx.annotation.NonNull;

import java.util.HashMap;

import cn.tongdun.mobrisk.TDRisk;
import cn.tongdun.mobrisk.TDRiskCallback;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * TrustdeviceProPlugin
 */
public class TrustdeviceProPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Handler mHandler;
    private HandlerThread mHandlerThread;
    private Context mApplicationContext;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "trustdevice_pro_plugin");
        channel.setMethodCallHandler(this);
        mApplicationContext = flutterPluginBinding.getApplicationContext();
        mHandlerThread = new HandlerThread("TDFlutterPlugin_android");
        mHandlerThread.start();
        mHandler = new Handler(mHandlerThread.getLooper());
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
                    result.success(blackbox);
                }
            });
        } else if (call.method.equals("getBlackboxAsync")) {
            mHandler.post(new Runnable() {
                @Override
                public void run() {
                    TDRisk.getBlackBox(new TDRiskCallback() {
                        @Override
                        public void onEvent(String blackbox) {
                            result.success(blackbox);
                        }
                    });
                }
            });
        } else if (call.method.equals("getSDKVersion")) {
            String sdkVersion = TDRisk.getSDKVersion();
            result.success(sdkVersion);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        if (mHandlerThread != null)
            mHandlerThread.quitSafely();
    }
}
