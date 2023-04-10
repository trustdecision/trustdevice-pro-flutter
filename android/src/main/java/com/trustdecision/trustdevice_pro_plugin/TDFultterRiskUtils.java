package com.trustdecision.trustdevice_pro_plugin;

import java.util.HashMap;

import cn.tongdun.mobrisk.TDRisk;

public class TDFultterRiskUtils {

    //必传共有配置
    static final String KEY_PARTNER = "partner";
    static final String KEY_APPKEY = "appKey";
    static final String KEY_APPNAME = "appName";
    static final String KEY_COUNTRY = "country";

    //可选的共有配置（行为验证配置）
    static final String KEY_PB_LANGUAGE = "language";
    static final String KEY_PB_TAPTOCLOSE = "tapToClose";
    static final String KEY_PB_NEEDSEQID = "needSeqid";
    static final String KEY_PB_HIDELOADHUB = "hideLoadHud";
    static final String KEY_PB_HIDEWEBCLOSEBUTTON = "hideWebCloseButton";
    static final String KEY_PB_OPENLOG = "openLog";
    static final String KEY_PB_SKIPCAPTCHA = "skipCaptcha";
    static final String KEY_PB_MFAID = "mfaId";

    //android设备指纹配置
    static final String KEY_FP_ANDROID_TIMELIMIT = "httpTimeout";
    static final String KEY_FP_ANDROID_COLLECTLEVEL = "collectLevel";
    static final String KEY_FP_ANDROID_BLACKBOX_MAXSIZE = "blackBoxMaxSize";
    static final String KEY_FP_ANDROID_CUSTOM_PROCESSNAME = "customProcessName";
    static final String KEY_FP_ANDROID_FORCE_TLSVERSION = "forceTLSVersion";
    static final String KEY_FP_ANDROID_DISABLE_DEBUGGER = "disableDebugger";
    static final String KEY_FP_ANDROID_DISABLE__RUNNINGTASKS = "disableRunningTasks";
    static final String KEY_FP_ANDROID_DISABLE__GPS = "disableGPS";
    static final String KEY_FP_ANDROID_DISABLE__SENSOR = "disableSensor";
    static final String KEY_FP_ANDROID_DISABLE__READPHONE = "disableReadPhone";
    static final String KEY_FP_ANDROID_DISABLE__PACKAGELIST = "disableInstallPackageList";

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
        //可选的共有配置（行为验证配置）
        if (configMap.containsKey(KEY_PB_LANGUAGE)) {
            builder.language((Integer) configMap.get(KEY_PB_LANGUAGE));
        }
        if (configMap.containsKey(KEY_PB_TAPTOCLOSE)) {
            builder.tapToClose((Boolean) configMap.get(KEY_PB_TAPTOCLOSE));
        }
        if (configMap.containsKey(KEY_PB_NEEDSEQID)) {
            builder.needSeqId((Boolean) configMap.get(KEY_PB_NEEDSEQID));
        }
        if (configMap.containsKey(KEY_PB_HIDELOADHUB)) {
            builder.hideLoadHud((Boolean) configMap.get(KEY_PB_HIDELOADHUB));
        }
        if (configMap.containsKey(KEY_PB_HIDEWEBCLOSEBUTTON)) {
            builder.hideWebCloseButton((Boolean) configMap.get(KEY_PB_HIDEWEBCLOSEBUTTON));
        }
        if (configMap.containsKey(KEY_PB_OPENLOG)) {
            builder.openLog((Boolean) configMap.get(KEY_PB_OPENLOG));
        }
        if (configMap.containsKey(KEY_PB_SKIPCAPTCHA)) {
            builder.skipCaptcha((Boolean) configMap.get(KEY_PB_SKIPCAPTCHA));
        }
        if (configMap.containsKey(KEY_PB_MFAID)) {
            builder.mfaId((String) configMap.get(KEY_PB_MFAID));
        }
        //android设备指纹配置
        if (configMap.containsKey(KEY_FP_ANDROID_TIMELIMIT)) {
            builder.httpTimeOut((Integer) configMap.get(KEY_FP_ANDROID_TIMELIMIT));
        }
        if (configMap.containsKey(KEY_FP_ANDROID_COLLECTLEVEL)) {
            builder.collectLevel((String) configMap.get(KEY_FP_ANDROID_COLLECTLEVEL));
        }
        if (configMap.containsKey(KEY_FP_ANDROID_BLACKBOX_MAXSIZE)) {
            builder.blackBoxMaxSize((Integer) configMap.get(KEY_FP_ANDROID_BLACKBOX_MAXSIZE));
        }
        if (configMap.containsKey(KEY_FP_ANDROID_CUSTOM_PROCESSNAME)) {
            builder.customProcessName((String) configMap.get(KEY_FP_ANDROID_CUSTOM_PROCESSNAME));
        }
        if (configMap.containsKey(KEY_FP_ANDROID_FORCE_TLSVERSION)) {
            builder.forceTLSVersion((Boolean) configMap.get(KEY_FP_ANDROID_FORCE_TLSVERSION));
        }
        if (configMap.containsKey(KEY_FP_ANDROID_DISABLE_DEBUGGER)) {
            if ((boolean) configMap.get(KEY_FP_ANDROID_DISABLE_DEBUGGER))
                builder.disableDebugger();
        }
        if (configMap.containsKey(KEY_FP_ANDROID_DISABLE__RUNNINGTASKS)) {
            if ((boolean) configMap.get(KEY_FP_ANDROID_DISABLE__RUNNINGTASKS))
                builder.disableRunningTasks();
        }
        if (configMap.containsKey(KEY_FP_ANDROID_DISABLE__GPS)) {
            if ((boolean) configMap.get(KEY_FP_ANDROID_DISABLE__GPS))
                builder.disableGPS();
        }
        if (configMap.containsKey(KEY_FP_ANDROID_DISABLE__SENSOR)) {
            if ((boolean) configMap.get(KEY_FP_ANDROID_DISABLE__SENSOR))
                builder.disableSensor();
        }
        if (configMap.containsKey(KEY_FP_ANDROID_DISABLE__READPHONE)) {
            if ((boolean) configMap.get(KEY_FP_ANDROID_DISABLE__READPHONE))
                builder.disableReadPhone();
        }
        if (configMap.containsKey(KEY_FP_ANDROID_DISABLE__PACKAGELIST)) {
            if ((boolean) configMap.get(KEY_FP_ANDROID_DISABLE__PACKAGELIST))
                builder.disableInstallPackageList();
        }
        return builder;
    }
}
