package org.actransit.restroomfinder.Infrastructure;


import android.Manifest;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.provider.Settings;
import androidx.core.app.ActivityCompat;
import android.telephony.TelephonyManager;

import org.actransit.restroomfinder.R;

import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Queue;
import java.util.UUID;

import com.google.android.gms.analytics.GoogleAnalytics;
import com.google.android.gms.analytics.Tracker;

import org.actransit.restroomfinder.R;

/**
 * Created by atajadod on 5/16/2016.
 */
public class MyApplication extends Application {

    private static String deviceId=null;

    public enum Activity_Enum{
        ACTIVITY_CURRENT_PAGE_Startup,
        ACTIVITY_CURRENT_PAGE_Login,
        ACTIVITY_CURRENT_PAGE_AddRestroom,
        ACTIVITY_CURRENT_PAGE_Disclaimer,
        ACTIVITY_CURRENT_PAGE_MAP,
        ACTIVITY_CURRENT_PAGE_Filter,
        ACTIVITY_CURRENT_PAGE_Feedback
    }
    
    //public static Deque<Activity_Enum> Current_Activity_Queue=new ArrayDeque<>();
    private static Context context;
    private Tracker mTracker;

    @Override
    public void onCreate() {
        super.onCreate();
        MyApplication.context = getApplicationContext();
    }

    public static Context getAppContext() {
        return MyApplication.context;

    }
    public static String getDeviceId(){
        if (deviceId==null){
            Context context=getAppContext();
            final TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);

            final String tmDevice, tmSerial, androidId;
            if (ActivityCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
                // TODO: Consider calling
                //    ActivityCompat#requestPermissions
                // here to request the missing permissions, and then overriding
                //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                //                                          int[] grantResults)
                // to handle the case where the user grants the permission. See the documentation
                // for ActivityCompat#requestPermissions for more details.
                deviceId= Settings.Secure.getString(context.getContentResolver(),
                        Settings.Secure.ANDROID_ID);

            }
            else {
                tmDevice = "" + tm.getDeviceId();
                tmSerial = "" + tm.getSimSerialNumber();
                androidId = "" + android.provider.Settings.Secure.getString(context.getContentResolver(), android.provider.Settings.Secure.ANDROID_ID);

                UUID deviceUuid = new UUID(androidId.hashCode(), ((long)tmDevice.hashCode() << 32) | tmSerial.hashCode());
                deviceId= deviceUuid.toString();
            }
        }
        return deviceId;
    }
    public static int getPixelsFromDp(Context context, float dp) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int)(dp * scale + 0.5f);
    }

    /**
     * Gets the default {@link Tracker} for this {@link Application}.
     * @return tracker
     */
    synchronized public Tracker getDefaultTracker() {
        if (mTracker == null) {
            GoogleAnalytics analytics = GoogleAnalytics.getInstance(this);
            // To enable debug logging use: adb shell setprop log.tag.GAv4 DEBUG
            mTracker = analytics.newTracker(R.xml.global_tracker);
        }
        return mTracker;
    }

    synchronized public void resetTracker() {
        mTracker = null;
    }

    public static <T> void NavigateTo(Class<T> type){
        Intent activity= new Intent(MyApplication.getAppContext(),type);
        activity.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK |Intent.FLAG_ACTIVITY_CLEAR_TASK);
        MyApplication.getAppContext().startActivity(activity);
    }

    //public static int CurrentPage=ACTIVITY_CURRENT_Page_Startup;

}
