package org.actransit.restroomfinder.Infrastructure;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;

import org.actransit.restroomfinder.Model.KeyValue;
import org.json.JSONObject;

import java.util.Calendar;


/**
 * Created by DevTeam on 6/21/16.
 */
public class AppStorage extends Activity{
    private static final String PREFS_NAME = "RestroolFinderFile";
    private static final String disclaimerKey = "Disclaimer_Agreed";
    private static final String disclaimerPopupKey = "DisclaimerPopup_Agreed";
    private static SharedPreferences settings;
    private static AppStorage current;
    private AppStorage(Context context){
        settings= context.getSharedPreferences(PREFS_NAME, 0);
    }

    private KeyValue badge;


    public static AppStorage Current(Context context){
        if (current!=null)
            return current;
        current=new AppStorage(context);
        return current;
    }

    public boolean shouldPopupDisclaimer() {
        String value=settings.getString(disclaimerPopupKey,"");
        if (value=="")
            return true;
        try{
            JSONObject jObj=new JSONObject(value);
            KeyValue keyValue=JSONMapper.toObject(jObj, KeyValue.class);
            Calendar now=Calendar.getInstance();
            Calendar c= Calendar.getInstance();
            c.setTime(keyValue.updateDate);
            return c.get(Calendar.YEAR) != now.get(Calendar.YEAR) ||
                    c.get(Calendar.MONTH) != now.get(Calendar.MONTH) ||
                    c.get(Calendar.DAY_OF_MONTH) != now.get(Calendar.DAY_OF_MONTH);

        }
        catch (Exception e){
            e.printStackTrace();
            return true;
        }
    }

    public void setPopupDisclaimer(){
        saveItem(disclaimerPopupKey,"set");
    }


    public boolean isFirstTimeRunningApplication(){
        String disClaimerAgreed = settings.getString(disclaimerKey, "");
        return disClaimerAgreed=="";// | true;
    }

    public void setFirstTimeRunningApplication(String badge) {
        saveItem(disclaimerKey,badge);
    }

    public KeyValue getBadge(){
        if (badge==null)
            badge=restoreItem(disclaimerKey);
        return badge;
    }


    public void saveItem(String key,String value){
        try{
            invalidateCache();
            JSONObject jObj=new JSONObject();
            jObj.put("key",key);
            jObj.put("value",value);
            jObj.put("updateDate",Calendar.getInstance().getTime().getTime());
            String v = jObj.toString();
            SharedPreferences.Editor editor = settings.edit();
            editor.putString(key, v);
            editor.commit();

        }
        catch(Exception e){
            e.printStackTrace();
        }
    }
    public KeyValue restoreItem(String key) {
        String value=settings.getString(key,"");
        if (value=="")
            return null;
        try{
            JSONObject jObj=new JSONObject(value);
            KeyValue keyValue=JSONMapper.toObject(jObj, KeyValue.class);
            return keyValue;
        }
        catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    private void invalidateCache(){
        badge=null;
    }

}
