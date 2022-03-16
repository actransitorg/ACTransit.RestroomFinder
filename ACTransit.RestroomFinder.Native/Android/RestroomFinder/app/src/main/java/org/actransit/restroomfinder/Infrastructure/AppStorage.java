package org.actransit.restroomfinder.Infrastructure;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.provider.Settings;
import androidx.core.app.ActivityCompat;
import android.telephony.TelephonyManager;

import com.tellexperience.jsonhelper.JsonMapper;

import org.actransit.restroomfinder.LoginActivity;
import org.actransit.restroomfinder.Model.KeyValue;
import org.json.JSONObject;

import java.util.Calendar;
import java.util.UUID;


/**
 * Created by DevTeam on 6/21/16.
 */
public class AppStorage extends Activity{
    private static final String PREFS_NAME = "RestroomFinderFile";
    private static final String disclaimerKey = "Disclaimer_Agreed";
    //private static final String disclaimerSessionKey = "Disclaimer_Agreed_SessionId";
    private static final String disclaimerPopupKey = "DisclaimerPopup_Agreed";


    private static final String badgeKey = "badge";
    private static final String phoneNumberKey = "phoneNumber";
    private static final String firstNameKey = "firstName";
    private static final String lastNameKey = "lastName";
    private static final String sessionKey = "SessionId";


    private static SharedPreferences settings;
    private static AppStorage current;
    private AppStorage(Context context){
        settings= context.getSharedPreferences(PREFS_NAME, 0);
    }

    private KeyValue badge;
    private KeyValue sessionId;
    private KeyValue firstName;
    private KeyValue lastName;
    private KeyValue phoneNumber;

    public static AppStorage Current(Context context){
        if (current!=null)
            return current;
        current=new AppStorage(context);
        return current;
    }

    public boolean shouldPopupDisclaimer() {
        String value=settings.getString(disclaimerPopupKey,"");
        if (value.isEmpty())
            return true;
        try{
            JSONObject jObj=new JSONObject(value);
            KeyValue keyValue= JsonMapper.toObject(jObj, KeyValue.class);
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


//    public boolean isFirstTimeRunningApplication(){
//        String disClaimerAgreed = settings.getString(disclaimerKey, "");
//        return disClaimerAgreed=="";// | true;
//    }

//    public void setFirstTimeRunningApplication(String badge, String sessionId) {
//        saveItem(disclaimerKey,badge);
//        saveItem(sessionKey,sessionId);
//    }

    public Boolean isEmpty(){
        return badge == null &&
            sessionId==null &&
            firstName == null &&
            lastName == null &&
            phoneNumber== null;
    }

    public void setDisclaimerShown() {
        saveItem(disclaimerKey,"1");
    }


    public void setCurrentLoginInformation(String firstName, String lastName, String badge, String phoneNumber, String sessionId) {
        saveItem(badgeKey,badge);
        saveItem(firstNameKey,firstName);
        saveItem(lastNameKey,lastName);
        saveItem(phoneNumberKey,phoneNumber);
        saveItem(sessionKey,sessionId);

    }
    public void logOut()  {
        Common.Loggedin=false;
        saveItem(disclaimerKey,"");
        saveItem(badgeKey,"");
        saveItem(firstNameKey,"");
        saveItem(lastNameKey,"");
        saveItem(phoneNumberKey,"");
        saveItem(sessionKey,"");

        invalidateCache();

        MyApplication.NavigateTo(LoginActivity.class);
        //let _=Common.NavigateTo("Login")
    }

    public String getBadge(){
        if (badge==null)
            badge=restoreItem(badgeKey);
        if (badge==null)
            return null;
        return badge.value;
    }
    public String getSessionId(){
        if (sessionId==null)
            sessionId=restoreItem(sessionKey);
        if (sessionId==null)
            return null;
        return sessionId.value;
    }
    public String getFirstName(){
        if (firstName==null)
            firstName=restoreItem(firstNameKey);
        if (firstName==null)
            return null;
        return firstName.value;
    }
    public String getLastName(){
        if (lastName==null)
            lastName=restoreItem(lastNameKey);
        if (lastName==null)
            return null;
        return lastName.value;
    }
    public String getPhoneNumber(){
        if (phoneNumber==null)
            phoneNumber=restoreItem(phoneNumberKey);
        if (phoneNumber==null)
            return null;
        return phoneNumber.value;
    }

    public Boolean isDisclaimerShown() {
        KeyValue disclaimer=restoreItem(disclaimerKey);
        boolean tempResult=(disclaimer==null || !disclaimer.value.equals("1") );
        boolean result = !tempResult;
        return result;
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
        if (value.isEmpty())
            return null;
        try{
            JSONObject jObj=new JSONObject(value);
            KeyValue keyValue=JsonMapper.toObject(jObj, KeyValue.class);
            return keyValue;
        }
        catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    private void invalidateCache(){

        badge=null;
        sessionId=null;
        firstName = null;
        lastName = null;
        phoneNumber= null;
    }

}
