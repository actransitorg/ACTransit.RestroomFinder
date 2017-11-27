package org.actransit.restroomfinder.Infrastructure;

/**
 * Created by DevTeam on 6/29/16.
 */
public class Speed
{
    public static int meterPesSecondToMPH(float speed){
        float meterPerHour = speed * 3600;
        float kPerHour = meterPerHour / 1000;
        int res = Math.round(kPerHour * 0.621371f);
        return (res > 0 ? res : 0);
    }

    public static double distanceToMile(float distance){
        String temp = String.format("%.1f",distance * 0.000621371);
        return Double.valueOf(temp);
    }
}
