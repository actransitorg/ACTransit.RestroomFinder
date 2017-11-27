package org.actransit.restroomfinder.Infrastructure;


import android.app.Application;
import android.content.Context;

import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Queue;

import com.google.android.gms.analytics.GoogleAnalytics;
import com.google.android.gms.analytics.Tracker;

import org.actransit.restroomfinder.R;

/**
 * Created by atajadod on 5/16/2016.
 */
public class MyApplication extends Application {
    public enum Activity_Enum{
        ACTIVITY_CURRENT_PAGE_Startup,
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

    //public static int CurrentPage=ACTIVITY_CURRENT_Page_Startup;

}
