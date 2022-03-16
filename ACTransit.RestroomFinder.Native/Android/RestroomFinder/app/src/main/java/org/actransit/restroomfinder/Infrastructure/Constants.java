package org.actransit.restroomfinder.Infrastructure;

import android.app.Application;
import android.content.pm.PackageInfo;
import android.content.res.Resources;
import androidx.annotation.StringRes;
import android.view.View;

import org.actransit.restroomfinder.R;

/**
 * Created by atajadod on 5/17/2016.
 */
public class Constants {
    public static boolean PublicViewEnabled = false;
    public static boolean AppStoreEnabled = false;
    public static boolean EnableAutoUpdate = false;
    public static String getVersion(){
        try{
            PackageInfo pInfo = MyApplication.getAppContext().getPackageManager().getPackageInfo(MyApplication.getAppContext().getPackageName(), 0);
            String vRaw=pInfo.versionName;
            if (Constants.AppStoreEnabled)
                return vRaw;
            else{
                String[] vs=vRaw.split("[.]");
                String v="";
                for(int i=0;i<vs.length;i++){
                    if (v!="") v += ".";
                    v = v + String.format("%02d",Integer.parseInt(vs[i]));
                }
                if (v.length()==5) v = v + ".00";
                return v;
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return null;
    }
    public static String apiKey = "";
    public static class Server {
        //private static String baseTestURL = "https://your.company.domain/path/to/test-api-root/";
        private static String baseURL = MyApplication.getAppContext().getResources().getString(R.string.baseurl);
        private static String baseRestroomURL=Constants.Server.baseURL + "restroomfinder2/api/";
        private static String baseRestroomV2URL=Constants.Server.baseURL + "restroomfinder2/api/v2/";
        //private static String baseRestroomURL=(Constants.Variables.testMode ? Constants.Server.baseTestURL : Constants.Server.baseURL) + "restroom-finder/api/";

        
        public static String publicRestroomsUrl = baseRestroomV2URL + "Restrooms/Get";
        public static String actRestroomsUrl = baseRestroomV2URL + "Restrooms/getActRestrooms";
        public static String actNewPendingRestroomsUrl = baseRestroomV2URL + "Restrooms/getNewPendingActRestrooms";
        public static String restroomByIdUrl = baseRestroomV2URL + "Restrooms/getbyid";
        public static String operationUrl = baseRestroomV2URL + "Operator";
        public static String feedbackUrl = baseRestroomV2URL + "Feedback";
        public static String versionUrl = baseRestroomURL + "Version/Android/Restroom_mdm";
        public static String sendSecurityCodeUrl = baseRestroomV2URL + "Authentication/send";
        public static String validateSecurityCodeUrl = baseRestroomV2URL + "Authentication/validateSecurityCode";
        public static String authenticateUrl = baseRestroomV2URL + "Authentication/authenticate";
        public static String savePublicRestroomUrl = baseRestroomV2URL + "Restrooms/post";
        public static String saveActRestroomUrl = baseRestroomV2URL + "Restrooms/postActRestroom";

        //public static String transitBaseApiUrl = "http://your.company.domain/path/to/prod-api-root/";
        //public static String transitBaseTestApiUrl = "http://your.company.domain/path/to/test-api-root/";
        //public static String transitApiUrl = (Constants.Variables.testMode ? Constants.Server.transitBaseTestApiUrl : Constants.Server.transitBaseApiUrl) + "transit";
        public static String transitApiUrl = Server.baseURL + "transit";

        //public static String transitApiToken = "Enter demo transit API token here";  //Production

        //public static String transitApiToken = "Enter demo transit API token here"; //Test
        public static String transitApiToken = MyApplication.getAppContext().getResources().getString(R.string.transitapitoken);

    }

    public static class Messages {
        //public static String dailyDisclaimerText = "I acknowledge that it is a violation of California Vehicle Code §23123 and Operations Center Bulletin A.C.T. No. 07-15 to use a handheld wireless telephone while operating a District vehicle. I will not use this application unless my coach is parked and turned off. By using this application I certify my agreement with this provision.";
        public static String dailyDisclaimerText =   "I acknowledge that it is a violation of California Vehicle Code ß23123 and Transportation Department Bulletin 01-15 to use a handheld wireless telephone or other electronic device while operating a District vehicle. I will not use this application unless my coach is parked and turned off. By using this application I certify my agreement with this provision.";

        //public static String onceDisclaimerText = "I acknowledge that it is a violation of California Vehicle Code §23123 and Operations Center Bulletin A.C.T. No. 07-15 to use a handheld wireless telephone while operating a District vehicle.  I will not use this application unless my coach is parked and turned off. By using this application I certify my agreement with this provision and I further understand that violation of it may subject me to disciplinary action up to and including termination. ";
        public static String onceDisclaimerText =   "I acknowledge that it is a violation of California Vehicle Code ß23123 and Transportation Department Bulletin 01-15 to use a handheld wireless telephone or other electronic device while operating a District vehicle.  I will not use this application unless my coach is parked and turned off. By using this application I certify my agreement with this provision and I further understand that violation of it may subject me to disciplinary action up to and including termination.";

        //public static String drivingDisclaimerText = "It is a violation of California Vehicle Code §23123 and Operations Center Bulletin A.C.T. No. 07-15 to use a handheld wireless telephone while operating a District vehicle. Please stop and turn off your vehicle before using this application.";
        public static String drivingDisclaimerText = "It is a violation of California Vehicle Code ß23123 and Transportation Department Bulletin 01-15 to use a handheld wireless telephone or other electronic device while operating a District vehicle. Please stop and turn off your vehicle before using this application.";


        public static String noGPSReception = "Sorry there's no GPS reception in this location. Make sure you are outdoors.";
        public static String poorGPSReception = "Sorry, GPS reception is poor in this location. Make sure you are outdoors.";

        public static String locationDisabled = "Background Location Access Disabled";
        public static String setLocationAccess = "In order to be notified about Restrooms near you, please open this app's settings and set location access to 'Always'.";
        public static String setReadWritePermission = "This application needs to have access to read/write to/from files in order to remember your last response to the application's agreement or download newer versions. Please press 'OK' to try again or 'Cancel' to exit the app.";
        public static String newVersionAvailable="A new version of application is available. Would you like to update?";

        public static String locationModeHighAccuracySetting="Location mode should be set to High accuracy, GPS and Wi-Fi. Please change the location mode in your phone setting.";
        public static String locationServiceIsDisabled="Location service is disabled. Please enable the location service.";
        //public static String feedbackEmptySubmit="Please set rating or enter your feedback!";
        public static String feedbackEmptySubmit="Please enter valid feedback note.";
        public static String feedbackSaved="Feedback saved.";

        public static String restroomEmptyServiceProviderSubmit="Service Provider can't be empty.";
        public static String restroomEmptyLocationNameSubmit="Location Name can't be empty.";
        public static String restroomEmptyContactNameSubmit="Contact Name can't be empty.";

        public static String invalidBadge = "Please enter a valid badge.";

        public static class Errors{
            public static String saveFeedback = "Could not save your feedback. Please try again later.";
        }
    }

    public static class  Variables {
        public static Integer applicationDisableSpeed = 3;
        public static Integer speedVisibility = View.INVISIBLE;
        public static Double poorBestHorizontalAccuracy = 163.0;
        public static Double averageBestHorizontalAccuracy = 40.0;
        public static Double goodBestHorizontalAccuracy = 15.0;
        public static Double minMovementToUpdateList = 160.0;  // it's 0.1 mile
        public static Integer maxAgeLocationSpeedReset = 5000;
        public static Integer maxAgeRefreshListInSecond = 3600;
        //public static Integer maxAgeToIgnoreBadgeValidation = MyApplication.getAppContext().getResources().getInteger(R.integer.maxAgeToIgnoreBadgeValidation) ; //1000 * 60 * 10  or 10 minutes
        public static Integer mapPaddingTop = 40; // in DP
        public static Integer mapPaddingBottom = 40; // in DP
        public static String Flavor=MyApplication.getAppContext().getResources().getString(R.string.flavorname);
        //public static Boolean testMode = true;
    }
}

