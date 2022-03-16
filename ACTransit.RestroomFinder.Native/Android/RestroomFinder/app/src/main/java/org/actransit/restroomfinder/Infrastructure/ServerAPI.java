package org.actransit.restroomfinder.Infrastructure;

import org.actransit.restroomfinder.MapviewActivity;
import org.actransit.restroomfinder.Model.AuthenticationModel;
import org.actransit.restroomfinder.Model.BoolModel;
import org.actransit.restroomfinder.Model.FeedbackModel;
import org.actransit.restroomfinder.Model.OperationModel;
import org.actransit.restroomfinder.Model.RestroomModel;
import org.actransit.restroomfinder.Model.RouteModel;
import org.actransit.restroomfinder.Model.VersionModel;
import org.actransit.restroomfinder.StartupActivity;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Type;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Logger;

import android.content.Context;
import android.util.Log;

import com.android.volley.VolleyError;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.tellexperience.jsonhelper.JsonMapper;
import com.tellexperience.jsonhelper.ServerBaseAPI;

/**
 * Created by atajadod on 5/16/2016.
 */
public class ServerAPI extends ServerBaseAPI{

    private Context context;
    public ServerAPI(Context context,String sessionId){
        super(context);
        this.context=context;
        //if (sessionId!=null && !sessionId.isEmpty())
          //  headers.put("sessionId", sessionId);

        super.headers= getHeaders();
    }

    public void getRestrooms(String route, Double latitude, Double longitude, ServerResult callBack){
//        final int callbacks=0;
//        final int callbacksCount=2;
        ServerMultiResult internalCallback=new ServerMultiResult<List<RestroomModel>>() {
            int callbacks=0;
            int callbacksResolved=0;
            List<RestroomModel> finalData=new ArrayList<RestroomModel>();
            Exception finalError;

            @Override
            public void setCallbacks(int callbacks) {
                this.callbacks = callbacks;
            }
            @Override
            public void Always(final List<RestroomModel> data, Exception error) {
                callbacksResolved++;
                if (error != null)
                    finalError=error;
                else if (data != null)
                    finalData.addAll(data);
                if (callbacksResolved==callbacks)
                    callBack.Always(finalData,finalError);
            }
        };

        Log.d("get restroom", "here we are now......");

        int callbacksNumber=1;

        if (Common.Loggedin){
            if (Constants.PublicViewEnabled && (route==null || route.equals("")))
                callbacksNumber++;
            if (Common.canAddRestroom)
                callbacksNumber++;
        }
        internalCallback.setCallbacks(callbacksNumber);

        if (Common.Loggedin) {
            String url = getActRestroomsURL(route==null?"":route,latitude,longitude,80000, false);
            Get(url, RestroomModel.class, internalCallback);

            if (Common.canAddRestroom){
                url = getActRestroomsURL(route==null?"":route,latitude,longitude,80000, true);  //now get the new pending restrooms.
                Get(url, RestroomModel.class, internalCallback);
            }
        }
        if (Constants.PublicViewEnabled && (route==null || route.equals(""))){
            String publicUrl = getPublicRestroomsURL(route==null?"":route,latitude,longitude,80000);
            Get(publicUrl, RestroomModel.class, internalCallback);
        }

    }
    public void getRestroom(int restroomId, ServerResult callBack){
        String url = getRestroomURL(restroomId);
        Get(url, RestroomModel.class, callBack);
    }


    public void getRoutes(ServerResult callBack){
        String url = getRoutesURL();
        Get(url, RouteModel.class, callBack);
    }

    public void getOperation(boolean agreed,boolean  validating, ServerResult callBack)  {
        String surl = Constants.Server.operationUrl;
        OperationModel obj = new OperationModel();
        AppStorage storage= AppStorage.Current(MyApplication.getAppContext());
        obj.firstName = storage.getFirstName();
        obj.lastName = storage.getLastName();
        obj.badge = storage.getBadge();
        obj.agreed = agreed;
        obj.validating = validating;
        obj.deviceSessionId = storage.getSessionId();
        String d=getCurrentDateTime();
        obj.incidentDateTime= d;//Calendar.getInstance().getTime().toString();
        JSONObject jObj= JsonMapper.toJSON(obj, OperationModel.class);
        Post(surl, jObj, OperationModel.class, callBack);
    }

    public void getFeedbacks(int restStopId, ServerResult callBack) {
        String url = getFeedbacksURL(restStopId);
        Get(url, FeedbackModel.class, callBack);
    }
    public void getVersion(ServerResult callBack){
        String url=Constants.Server.versionUrl + "/" +  android.os.Build.VERSION.SDK_INT;
        Get(url, VersionModel.class,callBack);
    }

    public void saveFeedback(FeedbackModel feedback,ServerResult callBack) {
        String url = getFeedbacksURL(0);
        JSONObject jObj=JsonMapper.toJSON(feedback, FeedbackModel.class);
        Post(url,jObj,FeedbackModel.class ,callBack);
    }


    public void sendSecurityCode(String firstName, String lastName, String badge, String phoneNumber, ServerResult<BoolModel>  callBack){
        String surl = Constants.Server.sendSecurityCodeUrl;
        AuthenticationModel obj = new AuthenticationModel(firstName,lastName, badge, phoneNumber);
        obj.deviceSessionId=getCurrentAppStorage().getSessionId();

        String d=getCurrentDateTime();
        obj.incidentDateTime= d;//Calendar.getInstance().getTime().toString();
        JSONObject jObj=JsonMapper.toJSON(obj, AuthenticationModel.class);
        //super.headers= getHeaders(); // AppStorage not yet set.
        Post(surl,jObj,BoolModel.class,callBack);

    }
    public void  validateSecurityCode(String firstName, String lastName, String badge, String phoneNumber, String securityCode, ServerResult<AuthenticationModel> callBack){
        String surl = Constants.Server.validateSecurityCodeUrl;
        AuthenticationModel obj = new AuthenticationModel(firstName,lastName, badge, phoneNumber,securityCode);
        obj.deviceSessionId=getCurrentAppStorage().getSessionId();

        String d=getCurrentDateTime();
        obj.incidentDateTime= d;//Calendar.getInstance().getTime().toString();

        JSONObject jObj=JsonMapper.toJSON(obj, AuthenticationModel.class);
        Post(surl,jObj,AuthenticationModel.class,callBack);
    }

    public void  authenticateAsync(ServerResult<AuthenticationModel> callBack){
        String surl = Constants.Server.authenticateUrl;
        AuthenticationModel obj = new AuthenticationModel(getCurrentAppStorage().getFirstName(),
                getCurrentAppStorage().getLastName(),
                getCurrentAppStorage().getBadge(),
                getCurrentAppStorage().getPhoneNumber(), "");
        obj.deviceSessionId=getCurrentAppStorage().getSessionId();
        String d=getCurrentDateTime();
        obj.incidentDateTime= d;//Calendar.getInstance().getTime().toString();

        JSONObject jObj=JsonMapper.toJSON(obj, AuthenticationModel.class);
        Post(surl,jObj,AuthenticationModel.class,callBack);
    }

    public void saveRestroom(RestroomModel restroom, ServerResult callBack) {
        String url = Constants.Server.saveActRestroomUrl;
        JSONObject jObj=JsonMapper.toJSON(restroom, RestroomModel.class);
        Post(url,jObj,RestroomModel.class ,callBack);
    }

    private String getPublicRestroomsURL(String route, Double latitude, Double longitude, Integer distance){
        //return "http://www.android.com/";
        String returnUrl = Constants.Server.publicRestroomsUrl +  "?routeAlpha=" + route + "&direction=&lat=" + latitude.toString() + "&longt=" + longitude.toString();
        if(distance != null) {
            return returnUrl + "&distance=" + distance;
        } else {
            return returnUrl;
        }
    }
    private String getActRestroomsURL(String route, Double latitude, Double longitude, Integer distance, boolean includeNewPendings){
        //return "http://www.android.com/";
        String returnUrl = "";
        returnUrl = Constants.Server.actRestroomsUrl +  "?routeAlpha=" + route + "&direction=&lat=" + latitude.toString() + "&longt=" + longitude.toString();
        if (includeNewPendings)
            returnUrl = Constants.Server.actNewPendingRestroomsUrl +  "?routeAlpha=" + route + "&direction=&lat=" + latitude.toString() + "&longt=" + longitude.toString();
        if(distance != null) {
            return returnUrl + "&distance=" + distance;
        } else {
            return returnUrl;
        }
    }

    private String getRestroomURL(int restroomId){
        return Constants.Server.restroomByIdUrl +  "?id=" + restroomId;
    }

    private String getRoutesURL() {
        return (Constants.Server.transitApiUrl) + "/routes/?token=" + (Constants.Server.transitApiToken);
    }

    private String getFeedbacksURL(int restroomId){
        if (restroomId != 0){
            return Constants.Server.feedbackUrl + "/get?restroomId=" + restroomId;
        }

        return Constants.Server.feedbackUrl + "/Post";

    }


    private AppStorage getCurrentAppStorage(){
        return AppStorage.Current(context);
    }

    private HashMap<String, String> getHeaders(){
        HashMap<String, String> result= new HashMap<String, String>();
        AppStorage storage= getCurrentAppStorage();
        result.put("sessionId",storage.getSessionId());
        result.put("deviceGuid" , MyApplication.getDeviceId());
        result.put("firstName", storage.getFirstName());
        result.put("lastName", storage.getLastName());
        result.put("badge", storage.getBadge());
        return result;
    }

    private String getCurrentDateTime(){
        Date date = new Date();
        DateFormat dateFormat = android.text.format.DateFormat.getDateFormat(MyApplication.getAppContext());
        return dateFormat.format(date);
    }

    public String parseVolleyError(VolleyError error) {
        try {

            String responseBody = "Fail to connect to server.";
            if (error!=null && error.networkResponse!=null)
                responseBody = new String(error.networkResponse.data, "utf-8");
            String message=responseBody;
            if (responseBody!=null && responseBody.startsWith("{")){
                JSONObject data = new JSONObject(responseBody);
                if (data.has("errors")){
                    JSONArray errors = data.getJSONArray("errors");
                    JSONObject jsonMessage = errors.getJSONObject(0);
                    data=jsonMessage;
                }
                if (data.has("message"))
                    message = data.getString("message");
                else if (data.has("errorMessage"))
                    message = data.getString("errorMessage");
                else if (data.has("error"))
                    message = data.getString("error");

            }
            return message;
            //Toast.makeText(getApplicationContext(), message, Toast.LENGTH_LONG).show();
        } catch (JSONException e) {
        } catch (UnsupportedEncodingException errorr) {
        }
        return "";
    }
}

abstract class ServerMultiResult<T> implements ServerBaseAPI.ServerResult<T>
{
    public abstract void setCallbacks(int callbacks);
}