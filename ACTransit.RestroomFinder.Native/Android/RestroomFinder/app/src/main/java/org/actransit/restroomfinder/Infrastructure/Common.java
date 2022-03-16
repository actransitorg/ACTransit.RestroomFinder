package org.actransit.restroomfinder.Infrastructure;

import java.util.Calendar;
import java.util.Date;

public class Common {

    public static Boolean canAddRestroom=false;
    public static Boolean canEditRestroom=false;
    public static String waitingApprovalText = "waiting approval";
    public static boolean Loggedin=false;

    public static boolean isWeekday(){
        Date d= new Date();
        Calendar c = Calendar.getInstance();
        c.setTime(d);
        return !(c.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY || c.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY);
    }
    public static boolean isSaturday(){
        Date d= new Date();
        Calendar c = Calendar.getInstance();
        c.setTime(d);
        return c.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY;

    }
    public static boolean isSunday(){
        Date d= new Date();
        Calendar c = Calendar.getInstance();
        c.setTime(d);
        return c.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY;
    }

}
