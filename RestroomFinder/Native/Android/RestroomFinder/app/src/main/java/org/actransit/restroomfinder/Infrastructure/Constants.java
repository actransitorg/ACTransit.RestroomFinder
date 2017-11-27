package org.actransit.restroomfinder.Infrastructure;

import android.content.pm.PackageInfo;
import android.view.View;

/**
 * Created by atajadod on 5/17/2016.
 */
public class Constants {
    public static String getVersion(){
        try{
            PackageInfo pInfo = MyApplication.getAppContext().getPackageManager().getPackageInfo(MyApplication.getAppContext().getPackageName(), 0);
            return pInfo.versionName;
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return null;
    }
    public static String apiKey = "";
    public static class Server {
        private static String baseURL = "http://your.company.dns/path/to/restroom-finder-api/";
        
        public static String restroomsUrl = baseURL + "Restrooms";
        public static String operationUrl = baseURL + "Operator";
        public static String feedbackUrl = baseURL + "Feedback";
        public static String versionUrl = baseURL + "Version/Android/Restroom";
        public static String transitApiUrl = "http://your.company.dns/path/to/transit-api";
        public static String transitApiToken = "Enter demo transit API token here";
    }

    public static class Messages {
        //public static String dailyDisclaimerText = "I acknowledge that it is a violation of California Vehicle Code Â§23123 and Operations Center Bulletin A.C.T. No. 07-15 to use a handheld wireless telephone while operating a District vehicle. I will not use this application unless my coach is parked and turned off. By using this application I certify my agreement with this provision.";
        public static String dailyDisclaimerText =   "I acknowledge that it is a violation of California Vehicle Code ÃŸ23123 and Transportation Department Bulletin 01-15 to use a handheld wireless telephone or other electronic device while operating a District vehicle. I will not use this application unless my coach is parked and turned off. By using this application I certify my agreement with this provision.";

        //public static String onceDisclaimerText = "I acknowledge that it is a violation of California Vehicle Code Â§23123 and Operations Center Bulletin A.C.T. No. 07-15 to use a handheld wireless telephone while operating a District vehicle.  I will not use this application unless my coach is parked and turned off. By using this application I certify my agreement with this provision and I further understand that violation of it may subject me to disciplinary action up to and including termination. ";
        public static String onceDisclaimerText =   "I acknowledge that it is a violation of California Vehicle Code ÃŸ23123 and Transportation Department Bulletin 01-15 to use a handheld wireless telephone or other electronic device while operating a District vehicle.  I will not use this application unless my coach is parked and turned off. By using this application I certify my agreement with this provision and I further understand that violation of it may subject me to disciplinary action up to and including termination.";

        //public static String drivingDisclaimerText = "It is a violation of California Vehicle Code Â§23123 and Operations Center Bulletin A.C.T. No. 07-15 to use a handheld wireless telephone while operating a District vehicle. Please stop and turn off your vehicle before using this application.";
        public static String drivingDisclaimerText = "It is a violation of California Vehicle Code ÃŸ23123 and Transportation Department Bulletin 01-15 to use a handheld wireless telephone or other electronic device while operating a District vehicle. Please stop and turn off your vehicle before using this application.";


        public static String noGPSReception = "Sorry there's no GPS reception in this location. Make sure you are outdoors.";
        public static String poorGPSReception = "Sorry, GPS reception is poor in this location. Make sure you are outdoors.";

        public static String locationDisabled = "Background Location Access Disabled";
        public static String setLocationAccess = "In order to be notified about Restrooms near you, please open this app's settings and set location access to 'Always'.";
        public static String setReadWritePermission = "This application needs to have access to read/write to/from files in order to remember your last response to the application's agreement. Please press 'OK' to try again or 'Cancel' to exit the app.";
        public static String newVersionAvaiable="A new version of application is available. Would you like to update?";

        public static String locationModeHighAccuracySetting="Location mode should be set to High accuracy, GPS and Wi-Fi. Please change the location mode in your phone setting.";
        public static String locationServiceIsDisabled="Location service is disabled. Please enable the location service.";
        public static String feedbackEmptySumbit="Please set rate or enter your feedback!";
        public static String feedbackSaved="Feedback saved.";

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
        public static Integer maxAgeToIgnoreBadgeValidation = 600000 ; //1000 * 60 * 10  or 10 minutes
        public static Integer mapPaddingTop = 40; // in DP
        public static Integer mapPaddingBottom = 40; // in DP
    }
}

