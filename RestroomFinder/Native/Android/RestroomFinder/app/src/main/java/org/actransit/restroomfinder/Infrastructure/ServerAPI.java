package org.actransit.restroomfinder.Infrastructure;


import org.actransit.restroomfinder.Model.FeedbackModel;
import org.actransit.restroomfinder.Model.OperationModel;
import org.actransit.restroomfinder.Model.RestroomModel;
import org.actransit.restroomfinder.Model.RouteModel;
import org.actransit.restroomfinder.Model.VersionModel;
import org.json.JSONObject;

import java.util.Calendar;
import java.util.List;
import android.content.Context;

/**
 * Created by atajadod on 5/16/2016.
 */
public class ServerAPI extends ServerBaseAPI{

    public ServerAPI(Context context){
        super(context);
    }

    public void getRestrooms(String route, Double latitude, Double longitude, ServerResult callBack){
        String url = getRestroomsURL(route==null?"":route,latitude,longitude,80000);
        Get(url, RestroomModel.class, callBack);
    }
    public void getRestroom(int restroomId, ServerResult callBack){
        String url = getRestroomURL(restroomId);
        Get(url, RestroomModel.class, callBack);
    }


    public void getRoutes(ServerResult callBack){
        String url = getRoutesURL();
        Get(url, RouteModel.class, callBack);
    }

    public void getOperation(String badge,boolean agreed,boolean  validating, ServerResult callBack){
        String surl = Constants.Server.operationUrl;
        OperationModel obj = new OperationModel();
        obj.badge = badge;
        obj.agreed = agreed;
        obj.validating = validating;
        obj.incidentDateTime = Calendar.getInstance().getTime().toString();
        JSONObject jObj=JSONMapper.toJSON(obj, OperationModel.class);
        Post(surl, jObj, OperationModel.class, callBack);
    }

    public void getFeedbacks(int restStopId, ServerResult callBack) {
        String url = getFeedbacksURL(restStopId);
        Get(url, FeedbackModel.class, callBack);
    }
    public void getVersion(ServerResult callBack){
        String url=Constants.Server.versionUrl;
        Get(url, VersionModel.class,callBack);
    }

    public void saveFeedback(FeedbackModel feedback,ServerResult callBack) {
        String url = getFeedbacksURL(0);
        JSONObject jObj=JSONMapper.toJSON(feedback, FeedbackModel.class);
        Post(url,jObj,FeedbackModel.class ,callBack);
    }

    private String getRestroomsURL(String route, Double latitude, Double longitude, Integer distance){
        //return "http://www.android.com/";
        String returnUrl = Constants.Server.restroomsUrl +  "?routeAlpha=" + route + "&direction=&lat=" + latitude.toString() + "&longt=" + longitude.toString();

        if(distance != null) {
            return returnUrl + "&distance=" + distance;
        } else {
            return returnUrl;
        }
    }
    private String getRestroomURL(int restroomId){
        return Constants.Server.restroomsUrl +  "/" + restroomId;
    }

    private String getRoutesURL() {
        return (Constants.Server.transitApiUrl) + "/routes/?token=" + (Constants.Server.transitApiToken);
    }

    private String getFeedbacksURL(int restStopId){
        if (restStopId != 0){
            return Constants.Server.feedbackUrl + "?restStopId=" + restStopId;
        }
        return Constants.Server.feedbackUrl + "/";
    }


}
