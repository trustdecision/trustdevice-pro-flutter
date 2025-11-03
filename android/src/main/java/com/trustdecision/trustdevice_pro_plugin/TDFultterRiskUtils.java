package com.trustdecision.trustdevice_pro_plugin;

import android.text.TextUtils;

import java.util.HashMap;
import java.util.Map;
import java.util.function.Supplier;

import com.trustdecision.mobrisk.TDRisk;
import com.trustdecision.mobrisk.TDDeviceManager;

public class TDFultterRiskUtils {
    ///Mandatory Shared Configuration
    static final String KEY_PARTNER = "partner";
    static final String KEY_APPKEY = "appKey";
    static final String KEY_APPNAME = "appName";
    static final String KEY_CHANNEL = "channel";
    static final String KEY_COUNTRY = "country";
    static final String KEY_URL = "url";
    static final String KEY_PROFILE_URL = "profileUrl";
    static final String KEY_DEBUG = "debug";
    static final String KEY_TIME_LIMIT = "timeLimit";
    static final String KEY_LOCATION = "location";
    static final String KEY_COLLECT_LEVEL = "collectLevel";
    static final String KEY_LANGUAGE = "language";
    static final String KEY_CUSTOM_MESSAGE = "customMessage";
    

    ///Android device fingerprint configuration
    static final String KEY_FP_ANDROID_RUNNING_TASKS = "runningTasks";
    static final String KEY_FP_ANDROID_SENSOR = "sensor";
    static final String KEY_FP_ANDROID_READ_PHONE = "readPhone";
    static final String KEY_FP_ANDROID_INSTALLPACKAGE_LIST = "installPackageList";
    static final String KEY_FP_ANDROID_WIFI_MAC = "wifiMac";


    static final String KEY_FP_ANDROID_GOOGLE_AID = "googleAid";
    static final String KEY_FP_ANDROID_OAID = "OAID";
    static final String KEY_FP_ANDROID_AID = "AID";
    static final String KEY_FP_ANDROID_ANDROID_ID = "ANDROID_ID";


    ///Android device Captcha configuration
    static final String KEY_CAPTCHA_TAPTOCLOSE = "tapToClose";
    static final String KEY_CAPTCHA_NEEDSEQID = "needSeqid";
    static final String KEY_CAPTCHA_HIDE_LOADHUD = "hideLoadHud";
    static final String KEY_CAPTCHA_HIDE_WEBCLOSEBUTTON = "hideWebCloseButton";
    static final String KEY_CAPTCHA_OPENLOG = "openLog";
    static final String KEY_CAPTCHA_SKIP_CAPTCHA = "skipCaptcha";
    static final String KEY_CAPTCHA_MFAID = "mfaId";

    ///Android device liveness configuration
    static final String KEY_LIVENESS_PLAYAUDIO = "playAudio";
    static final String KEY_LIVENESS_LIVENESSDETECTIONTHRESHOLD = "livenessDetectionThreshold";
    static final String KEY_LIVENESS_LIVENESSHTTPTIMEOUT = "livenessHttpTimeOut";
    static final String KEY_LIVENESS_SHOWREADYPAGE = "showReadyPage";
    static final String KEY_LIVENESS_FACEMISSINGINTERVAL = "faceMissingInterval";
    static final String KEY_LIVENESS_PREPARESTAGETIMEOUT = "prepareStageTimeout";
    static final String KEY_LIVENESS_ACTIONSTAGETIMEOUT = "actionStageTimeout";


    public static TDDeviceManager.Builder mapToBuilderSe(HashMap<String, Object> configMap) {
        TDDeviceManager.Builder builder = null;
        if (configMap == null) {
            return builder;
        }
        builder = new TDDeviceManager.Builder();
        if (configMap.containsKey(KEY_PARTNER)) {
            builder.partner((String) configMap.get(KEY_PARTNER));
        }
        if (configMap.containsKey(KEY_APPKEY)) {
            builder.appKey((String) configMap.get(KEY_APPKEY));
        }
        if (configMap.containsKey(KEY_APPNAME)) {
            builder.channel((String) configMap.get(KEY_APPNAME));
        }
        if (configMap.containsKey(KEY_CHANNEL)) {
            builder.channel((String) configMap.get(KEY_CHANNEL));
        }
        if (configMap.containsKey(KEY_COUNTRY)) {
            String country = (String) configMap.get(KEY_COUNTRY);
            if (!TextUtils.isEmpty(country)) {
                builder.country(country.toUpperCase());
            }
        }
        if (configMap.containsKey(KEY_URL)) {
            String url = (String) configMap.get(KEY_URL);
            if (!TextUtils.isEmpty(url)) {
                builder.url(url);
            }
        }
        if (configMap.containsKey(KEY_PROFILE_URL)) {
            String url = (String) configMap.get(KEY_PROFILE_URL);
            if (!TextUtils.isEmpty(url)) {
                builder.url(url);
            }
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

        // if (configMap.containsKey(KEY_COLLECT_LEVEL)) {
        //     String collectLevel = (String) configMap.get(KEY_COLLECT_LEVEL);
        //     if ("M".equals(collectLevel)) {
        //         builder.collectLevel(TDRisk.COLLECT_LEVEL_M);
        //     } else if ("L".equals(collectLevel)) {
        //         builder.collectLevel(TDRisk.COLLECT_LEVEL_L);
        //     }
        // }

        if (configMap.containsKey(KEY_CUSTOM_MESSAGE)) {
            String customMessage = (String) configMap.get(KEY_CUSTOM_MESSAGE);
            if (customMessage != null) {
                builder.customMessage(customMessage);
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
        // if (configMap.containsKey(KEY_FP_ANDROID_WIFI_MAC)) {
        //     Object enableWifiMac = configMap.get(KEY_FP_ANDROID_WIFI_MAC);
        //     if (enableWifiMac != null) {
        //         if ((boolean) enableWifiMac)
        //             builder.enableWifiMac();
        //     }
        // }
        if (configMap.containsKey(KEY_FP_ANDROID_GOOGLE_AID)) {
            Object enableGoogleAid = configMap.get(KEY_FP_ANDROID_GOOGLE_AID);
            if (enableGoogleAid != null) {
                if (!(boolean) enableGoogleAid)
                    builder.disableGoogleAid();
            }
        }

        if (configMap.containsKey(KEY_FP_ANDROID_OAID)) {
            Object oaid = configMap.get(KEY_FP_ANDROID_OAID);
            if (oaid != null) {
                if (!(boolean) oaid )
                    builder.disableOptions(TDDeviceManager.OPTION_OAID);
            }
        }
        if (configMap.containsKey(KEY_FP_ANDROID_AID)) {
            Object aid = configMap.get(KEY_FP_ANDROID_AID);
            if (aid != null) {
                if (!(boolean) aid)
                    builder.disableOptions(TDDeviceManager.OPTION_AID);
            }
        }
        if (configMap.containsKey(KEY_FP_ANDROID_ANDROID_ID)) {
            Object androidID = configMap.get(KEY_FP_ANDROID_ANDROID_ID);
            if (androidID != null) {
                if (!(boolean) androidID)
                    builder.disableOptions(TDDeviceManager.OPTION_ANDROID_ID);
            }
        }
        
        

        return builder;

        
    }

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
        if (configMap.containsKey(KEY_CHANNEL)) {
            builder.channel((String) configMap.get(KEY_CHANNEL));
        }
        if (configMap.containsKey(KEY_COUNTRY)) {
            String country = (String) configMap.get(KEY_COUNTRY);
            if (!TextUtils.isEmpty(country)) {
                builder.country(country.toUpperCase());
            }
        }
        if (configMap.containsKey(KEY_URL)) {
            String url = (String) configMap.get(KEY_URL);
            if (!TextUtils.isEmpty(url)) {
                builder.url(url);
            }
        }
        if (configMap.containsKey(KEY_PROFILE_URL)) {
            String url = (String) configMap.get(KEY_PROFILE_URL);
            if (!TextUtils.isEmpty(url)) {
                builder.url(url);
            }
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

         if (configMap.containsKey(KEY_CUSTOM_MESSAGE)) {
            String customMessage = (String) configMap.get(KEY_CUSTOM_MESSAGE);
            if (customMessage != null) {
                builder.customMessage(customMessage);
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

        if (configMap.containsKey(KEY_FP_ANDROID_GOOGLE_AID)) {
            Object enableGoogleAid = configMap.get(KEY_FP_ANDROID_GOOGLE_AID);
            if (enableGoogleAid != null) {
                if (!(boolean) enableGoogleAid)
                    builder.disableGoogleAid();
            }
        }

        if (configMap.containsKey(KEY_FP_ANDROID_OAID)) {
            Object oaid = configMap.get(KEY_FP_ANDROID_OAID);
            if (oaid != null) {
                if (!(boolean) oaid )
                    builder.disableOptions(TDDeviceManager.OPTION_OAID);
            }
        }
        if (configMap.containsKey(KEY_FP_ANDROID_AID)) {
            Object aid = configMap.get(KEY_FP_ANDROID_AID);
            if (aid != null) {
                if (!(boolean) aid)
                    builder.disableOptions(TDDeviceManager.OPTION_AID);
            }
        }
        if (configMap.containsKey(KEY_FP_ANDROID_ANDROID_ID)) {
            Object androidID = configMap.get(KEY_FP_ANDROID_ANDROID_ID);
            if (androidID != null) {
                if (!(boolean) androidID)
                    builder.disableOptions(TDDeviceManager.OPTION_ANDROID_ID);
            }
        }


        ///Android device Captcha configuration
        if (configMap.containsKey(KEY_CAPTCHA_TAPTOCLOSE)) {
            Object tapToCloseObj = configMap.get(KEY_CAPTCHA_TAPTOCLOSE);
            if (tapToCloseObj != null) {
                builder.tapToClose((Boolean) tapToCloseObj);
            }
        }
        if (configMap.containsKey(KEY_CAPTCHA_NEEDSEQID)) {
            Object needSeqidObj = configMap.get(KEY_CAPTCHA_NEEDSEQID);
            if (needSeqidObj != null) {
                builder.needSeqId((Boolean) needSeqidObj);
            }
        }
        if (configMap.containsKey(KEY_CAPTCHA_HIDE_LOADHUD)) {
            Object hideLoadHudObj = configMap.get(KEY_CAPTCHA_HIDE_LOADHUD);
            if (hideLoadHudObj != null) {
                builder.hideLoadHud((Boolean) hideLoadHudObj);
            }
        }
        if (configMap.containsKey(KEY_CAPTCHA_HIDE_WEBCLOSEBUTTON)) {
            Object hideWebCloseButtonObj = configMap.get(KEY_CAPTCHA_HIDE_WEBCLOSEBUTTON);
            if (hideWebCloseButtonObj != null) {
                builder.hideWebCloseButton((Boolean) hideWebCloseButtonObj);
            }
        }
        if (configMap.containsKey(KEY_CAPTCHA_OPENLOG)) {
            Object openLogObj = configMap.get(KEY_CAPTCHA_OPENLOG);
            if (openLogObj != null) {
                builder.openLog((Boolean) openLogObj);
            }
        }
        if (configMap.containsKey(KEY_CAPTCHA_SKIP_CAPTCHA)) {
            Object skipCaptchaObj = configMap.get(KEY_CAPTCHA_SKIP_CAPTCHA);
            if (skipCaptchaObj != null) {
                builder.skipCaptcha((Boolean) skipCaptchaObj);
            }
        }
        if (configMap.containsKey(KEY_CAPTCHA_MFAID)) {
            Object mfaIdObj = configMap.get(KEY_CAPTCHA_MFAID);
            if (mfaIdObj != null) {
                builder.mfaId((String) mfaIdObj);
            }
        }
        if (configMap.containsKey(KEY_FP_ANDROID_GOOGLE_AID)) {
            Object enableGoogleAid = configMap.get(KEY_FP_ANDROID_GOOGLE_AID);
            if (enableGoogleAid != null) {
                if (!(boolean) enableGoogleAid)
                    builder.disableGoogleAid();
            }
        }

        if (configMap.containsKey(KEY_LANGUAGE)) {
            Object languageObj = configMap.get(KEY_LANGUAGE);
            if (languageObj != null) {
                String languageStr = (String) languageObj;
                if (TextUtils.isDigitsOnly(languageStr)) {
                    builder.language(Integer.parseInt(languageStr));
                } else {
                    builder.language(languageStr);
                }
            }
        }

        //liveness
        if (configMap.containsKey(KEY_LIVENESS_LIVENESSDETECTIONTHRESHOLD)) {
            Object livenessDetectionThresholdObj = configMap.get(KEY_LIVENESS_LIVENESSDETECTIONTHRESHOLD);
            if (livenessDetectionThresholdObj != null) {
                builder.livenessDetectionThreshold((String) livenessDetectionThresholdObj);
            }
        }
        if (configMap.containsKey(KEY_LIVENESS_PLAYAUDIO)) {
            Object playAudio = configMap.get(KEY_LIVENESS_PLAYAUDIO);
            if (playAudio != null) {
                builder.playAudio((boolean) playAudio);
            }
        }
        if (configMap.containsKey(KEY_LIVENESS_SHOWREADYPAGE)) {
            Object showReadyPageObj = configMap.get(KEY_LIVENESS_SHOWREADYPAGE);
            if (showReadyPageObj != null) {
                builder.showReadyPage((boolean) showReadyPageObj);
            }
        }
        if (configMap.containsKey(KEY_LIVENESS_LIVENESSHTTPTIMEOUT)) {
            Object livenessHttpTimeOutObj = configMap.get(KEY_LIVENESS_LIVENESSHTTPTIMEOUT);
            if (livenessHttpTimeOutObj != null) {
                builder.livenessHttpTimeOut((int) livenessHttpTimeOutObj);
            }
        }
        if (configMap.containsKey(KEY_LIVENESS_FACEMISSINGINTERVAL)) {
            Object faceMissingInterval = configMap.get(KEY_LIVENESS_FACEMISSINGINTERVAL);
            if (faceMissingInterval != null) {
                builder.faceMissingInterval((int) faceMissingInterval);
            }
        }
        if (configMap.containsKey(KEY_LIVENESS_PREPARESTAGETIMEOUT)) {
            Object prepareStageTimeoutObj = configMap.get(KEY_LIVENESS_PREPARESTAGETIMEOUT);
            if (prepareStageTimeoutObj != null) {
                builder.prepareStageTimeout((int) prepareStageTimeoutObj);
            }
        }
        if (configMap.containsKey(KEY_LIVENESS_ACTIONSTAGETIMEOUT)) {
            Object actionStageTimeoutObj = configMap.get(KEY_LIVENESS_ACTIONSTAGETIMEOUT);
            if (actionStageTimeoutObj != null) {
                builder.actionStageTimeout((int) actionStageTimeoutObj);
            }
        }

        return builder;
    }

}
