package org.actransit.restroomfinder;

import android.*;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.os.SystemClock;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import android.util.Log;
import android.widget.TextView;

import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.Tracker;
import com.google.android.play.core.appupdate.AppUpdateInfo;
import com.tellexperience.jsonhelper.ServerBaseAPI;

import org.actransit.restroomfinder.Infrastructure.AppStorage;
import org.actransit.restroomfinder.Infrastructure.Common;
import org.actransit.restroomfinder.Infrastructure.Constants;
import org.actransit.restroomfinder.Infrastructure.MyApplication;
import org.actransit.restroomfinder.Infrastructure.UpdateApp;
import org.actransit.restroomfinder.Model.AuthenticationModel;
import org.actransit.restroomfinder.Model.KeyValue;
import org.actransit.restroomfinder.Model.OperationModel;
import org.actransit.restroomfinder.Model.VersionModel;

import java.io.File;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.jar.*;

public class StartupActivity extends BaseActivity{ //AppCompatActivity {
    private static final String STARTUP_ACTIVITY_CURRENT_STATE = "STARTUP_ACTIVITY_CURRENT_STATE";




//    private Tracker mTracker;

    static int counter =0;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if ((getIntent().getFlags() & Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT) != 0) {
            finish();
            return;
        }
        setContentView(R.layout.activity_startup);

        updateProgressDialog=new ProgressDialog(this);
        updateProgressDialog.setCancelable(false);
        findViewById(R.id.startupLayout).setBackground(Gradients.getColorScala());
        TextView lblVersion= (TextView) findViewById(R.id.lblVersion);
        String version="Version " + Constants.getVersion();
        version += Constants.Variables.Flavor;

        lblVersion.setText(version);
    }

    @Override
    protected void CheckForUpdateDone(boolean available, AppUpdateInfo appUpdateInfo) {
        super.CheckForUpdateDone(available, appUpdateInfo);
        if (available)
            startUpdate(StartupActivity.this, appUpdateInfo);
        else
            navigate();
    }

    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState) {
        super.onRestoreInstanceState(savedInstanceState);
    }

    @Override
    public void onSaveInstanceState(Bundle outState, PersistableBundle outPersistentState) {
        //outState.putInt(ACTIVITY_CURRENT_STATE,currentState);
        super.onSaveInstanceState(outState, outPersistentState);
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    @Override
    protected void onResume() {
//        mTracker.setScreenName(currentActivity().name());
//        mTracker.send(new HitBuilders.ScreenViewBuilder().build());

        //if (!checkingUpdate && !updateAvailable && hasFilePermission())
        if (initialized && !updateAvailable)
            navigate();
        super.onResume();
    }


    private void navigate(){
        Boolean isFirstTime = AppStorage.Current(StartupActivity.this).isEmpty();
        if (!isFirstTime){
            Server.authenticateAsync(new ServerBaseAPI.ServerResult<AuthenticationModel>() {
                @Override
                public void Always(AuthenticationModel authenticationModel, Exception e) {
                    if (authenticationModel != null){
                        Common.canAddRestroom= authenticationModel.canAddRestroom;
                        Common.canEditRestroom= authenticationModel.canEditRestroom;
                    }
                    boolean firstTime=true;
                    if (authenticationModel!=null)
                        firstTime = !authenticationModel.sessionApproved;
                    handleNavigation(firstTime ,e);
                }
            });
        }
        else{
            handleNavigation(true, null);
        }

    }

    private void  handleNavigation(Boolean firstTime, Exception error){
        Common.Loggedin= error == null && !firstTime;

        Boolean showDisclaimer= Common.Loggedin && !AppStorage.Current(this).isDisclaimerShown();
        Class c = (showDisclaimer ?  DisclaimerActivity.class : (Constants.PublicViewEnabled || Common.Loggedin) ? MapviewActivity.class : LoginActivity.class);
        NavigateTo(c);
    }

//    private void Navigate(){
//        final boolean isFirstTime =AppStorage.Current(StartupActivity.this).isEmpty();
//        final String sessionId=AppStorage.Current(StartupActivity.this).getSessionId();
//        if (!isFirstTime && sessionId!=null && sessionId !=null && !sessionId.isEmpty()){
//            Boolean showDisclaimer= AppStorage.Current(this).isDisclaimerShown();
//            if (showDisclaimer)
//                NavigateTo(DisclaimerActivity.class);
//            else
//                NavigateTo(MapviewActivity.class);
//
////            final String badge=AppStorage.Current(this).getBadge();
////            final Date now=Calendar.getInstance().getTime();
////            final long nowLong=now.getTime();
////
////            if (oBadge!=null && badge!="" &&
////                            oBadge.updateDate!=null &&
////                        badgeTimeLong> nowLong - Constants.Variables.maxAgeToIgnoreBadgeValidation){  //During the last 10 minutes! ignore checking the server
////                NavigateTo(MapviewActivity.class);
////            }
////            else{
////                Server.getOperation(badge, true, true, new ServerBaseAPI.ServerResult<OperationModel>() {
////                    @Override
////                    public void Always(OperationModel data, Exception error) {
////                        if (error!=null || data.sessionId==null || data.sessionId.isEmpty())
////                            NavigateTo(LoginActivity.class);
////                        else{
////                            if (sessionId!=data.sessionId)
////                                AppStorage.Current(StartupActivity.this).setFirstTimeRunningApplication(badge,data.sessionId);
////                            NavigateTo(MapviewActivity.class);
////                        }
////
////                    }
////                });
////            }
//        }
//        else
//            NavigateTo(LoginActivity.class);
//
//    }
    private <T> void NavigateTo(Class<T> type){
        Intent activity= new Intent(MyApplication.getAppContext(),type);
        startActivity(activity);
        //finish();
    }

    @Override
    public void onRequestPermissionsResult(final int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        onRequestPermissionsResult(StartupActivity.this, requestCode, permissions, grantResults);
    }

//    @Override
//    protected void requestPermission(){
//        if (!hasFilePermission()) {
//            if (ActivityCompat.shouldShowRequestPermissionRationale(StartupActivity.this,
//                    android.Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
//                showDialog("Storage Access",
//                        "Restroom Finder application requires your permission to use your device storage in order to download the newer version of this application.",
//                        new DialogInterface.OnClickListener() {
//                            @Override
//                            public void onClick(DialogInterface dialog, int which) {
//                                if (which != DialogInterface.BUTTON_POSITIVE){
//                                    finishAffinity();
//                                    return;
//                                }
//                                requestPermission();
//                            }
//                        });
//            }
//            ActivityCompat.requestPermissions(StartupActivity.this, PERMISSIONS_STORAGE, REQUEST_EXTERNAL_STORAGE);
//        }
//        else
//            internalUpdate();
//    }

//    private void update(){
//        Alert("Update", Constants.Messages.newVersionAvailable
//                , new DialogInterface.OnClickListener() {
//                    @Override
//                    public void onClick(DialogInterface dialog, int which) {
//                        internalUpdate();
//                    }
//                }
//                , new DialogInterface.OnClickListener() {
//                    @Override
//                    public void onClick(DialogInterface dialog, int which) {
//                        updateAvailable=false;
//                        StartupActivity.this.navigate();
//                    }
//                });
//    }



    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode==0) {
            updateProgressDialog.hide();
            navigate();
        }
    }

    @Override
    public void onBackPressed() {
        // do nothing
    }

    @Override
    public MyApplication.Activity_Enum currentActivity(){
        return MyApplication.Activity_Enum.ACTIVITY_CURRENT_PAGE_Startup;
    }
}
