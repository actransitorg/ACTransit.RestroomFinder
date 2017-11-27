package org.actransit.restroomfinder.Infrastructure;

import android.os.Handler;

/**
 * Created by DevTeam on 7/11/16.
 */
public class Timer {

    public static void create(final long delayMillis,final TimerCallBack callback){
        final Handler h = new Handler();
        h.postDelayed(new Runnable()
        {

            @Override
            public void run()
            {
                // do stuff then
                // can call h again after work!
                if (callback.onEllapsed())
                    h.postDelayed(this, delayMillis);
            }
        }, delayMillis); // 1 s
    }


    public interface TimerCallBack {
        public boolean onEllapsed();
    }
}
