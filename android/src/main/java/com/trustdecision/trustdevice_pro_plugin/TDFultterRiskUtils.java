package com.trustdecision.trustdevice_pro_plugin;

import java.util.HashMap;

import cn.tongdun.mobrisk.TDRisk;

public class TDFultterRiskUtils {
    ///Mandatory Shared Configuration
    static final String KEY_PARTNER = "partner";
    static final String KEY_APPKEY = "appKey";
    static final String KEY_APPNAME = "appName";
    static final String KEY_COUNTRY = "country";
    static final String KEY_DEBUG = "debug";
    static final String KEY_TIME_LIMIT = "timeLimit";
    static final String KEY_LOCATION = "location";
    static final String KEY_COLLECT_LEVEL = "collectLevel";

    ///Android device fingerprint configuration
    static final String KEY_FP_ANDROID_RUNNING_TASKS = "runningTasks";
    static final String KEY_FP_ANDROID_SENSOR = "sensor";
    static final String KEY_FP_ANDROID_READ_PHONE = "readPhone";
    static final String KEY_FP_ANDROID_INSTALLPACKAGE_LIST = "installPackageList";

    /**
     * 转换configMap成builder
     *
     * @param configMap
     * @return
     */
    public static TDRisk.Builder mapToBuilder(HashMap<String, Object> configMap) {
        TDRisk.Builder builder = null;
        if (configMap == null)
            return builder;
        builder = new TDRisk.Builder();
        if (configMap.containsKey(KEY_PARTNER)) {
            builder.partnerCode((String) configMap.get(KEY_PARTNER));
        }
        if (configMap.containsKey(KEY_APPKEY)) {
            builder.appKey((String) configMap.get(KEY_APPKEY));
        }
        if (configMap.containsKey(KEY_APPNAME)) {
            builder.appName((String) configMap.get(KEY_APPNAME));
        }
        if (configMap.containsKey(KEY_COUNTRY)) {
            builder.country((String) configMap.get(KEY_COUNTRY));
        }
        if (configMap.containsKey(KEY_DEBUG)) {
            Object debug = configMap.get(KEY_DEBUG);
            if (debug != null) {
                if (!(boolean) debug)
                    builder.disableDebugger();
            }
        }
        if (configMap.containsKey(KEY_TIME_LIMIT)) {
            Object timeLimit = configMap.get(KEY_TIME_LIMIT);
            if (timeLimit != null) {
                builder.httpTimeOut(((int) timeLimit) * 1000);
            }
        }
        if (configMap.containsKey(KEY_LOCATION)) {
            Object location = configMap.get(KEY_LOCATION);
            if (location != null) {
                if (!(boolean) location)
                    builder.disableGPS();
            }
        }
        if (configMap.containsKey(KEY_COLLECT_LEVEL)) {
            String collectLevel = (String) configMap.get(KEY_COLLECT_LEVEL);
            if ("M".equals(collectLevel)) {
                builder.collectLevel(TDRisk.COLLECT_LEVEL_M);
            } else if ("L".equals(collectLevel)) {
                builder.collectLevel(TDRisk.COLLECT_LEVEL_L);
            }
        }
        ///Android device fingerprint configuration
        if (configMap.containsKey(KEY_FP_ANDROID_RUNNING_TASKS)) {
            Object runningTasks = configMap.get(KEY_FP_ANDROID_RUNNING_TASKS);
            if (runningTasks != null) {
                if (!(boolean) runningTasks)
                    builder.disableRunningTasks();
            }
        }
        if (configMap.containsKey(KEY_FP_ANDROID_SENSOR)) {
            Object sensor = configMap.get(KEY_FP_ANDROID_SENSOR);
            if (sensor != null) {
                if (!(boolean) sensor)
                    builder.disableSensor();
            }
        }
        if (configMap.containsKey(KEY_FP_ANDROID_READ_PHONE)) {
            Object readPhone = configMap.get(KEY_FP_ANDROID_READ_PHONE);
            if (readPhone != null) {
                if (!(boolean) readPhone)
                    builder.disableReadPhone();
            }
        }
        if (configMap.containsKey(KEY_FP_ANDROID_INSTALLPACKAGE_LIST)) {
            Object installPackageList = configMap.get(KEY_FP_ANDROID_INSTALLPACKAGE_LIST);
            if (installPackageList != null) {
                if (!(boolean) installPackageList)
                    builder.disableInstallPackageList();
            }
        }
        return builder;
    }
}
