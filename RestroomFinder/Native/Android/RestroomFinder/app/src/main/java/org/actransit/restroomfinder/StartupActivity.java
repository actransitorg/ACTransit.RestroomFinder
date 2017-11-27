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
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.widget.TextView;

import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.Tracker;

import org.actransit.restroomfinder.Infrastructure.AppStorage;
import org.actransit.restroomfinder.Infrastructure.Constants;
import org.actransit.restroomfinder.Infrastructure.MyApplication;
import org.actransit.restroomfinder.Infrastructure.ServerBaseAPI;
import org.actransit.restroomfinder.Infrastructure.UpdateApp;
import org.actransit.restroomfinder.Model.KeyValue;
import org.actransit.restroomfinder.Model.VersionModel;

import java.io.File;
import java.util.Calendar;
import java.util.List;
import java.util.jar.*;

public class StartupActivity extends BaseActivity{ //AppCompatActivity {
    private static final String STARTUP_ACTIVITY_CURRENT_STATE = "STARTUP_ACTIVITY_CURRENT_STATE";
    private static final int REQUEST_EXTERNAL_STORAGE = 1;
    private static String[] PERMISSIONS_STORAGE = {
            android.Manifest.permission.READ_EXTERNAL_STORAGE,
            android.Manifest.permission.WRITE_EXTERNAL_STORAGE
    };

    private ProgressDialog updateProgressDialog;
    private VersionModel versionInfo;
    private boolean updateAvailable=false;
    private boolean checkingUpdate = false;
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

//        MyApplication application = (MyApplication) getApplication();
//        mTracker = application.getDefaultTracker();

        updateProgressDialog=new ProgressDialog(this);
        updateProgressDialog.setCancelable(false);
        findViewById(R.id.startupLayout).setBackground(Gradients.getColorScala());
        TextView lblVersion= (TextView) findViewById(R.id.lblVersion);
        lblVersion.setText("Version " + Constants.getVersion());

        checkingUpdate= true;
        Server.getVersion(new ServerBaseAPI.ServerResult<VersionModel>() {
            @Override
            public void Always(VersionModel data, Exception error) {
                String v= Constants.getVersion();
                checkingUpdate= false;
                if (data!=null && data.version.compareTo(v)>0){
                    updateAvailable=true;
                    versionInfo=data;
                    requestPermission();
                    Log.d("version","----------------------------version:" + data.version);
                }
                else
                    Navigate();
            }
        });
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

        if (!checkingUpdate && !updateAvailable && hasFilePermission())
            Navigate();
        super.onResume();
    }

    private void Navigate(){
        final boolean isFirstTime =AppStorage.Current(StartupActivity.this).isFirstTimeRunningApplication();

        if (!isFirstTime){
            final KeyValue oBadge=AppStorage.Current(this).getBadge();
            final String badge= (oBadge!=null? oBadge.value:"");
            if (oBadge!=null && badge!="" &&
                            oBadge.updateDate!=null &&
                            oBadge.updateDate.getTime()> Calendar.getInstance().getTime().getTime() - Constants.Variables.maxAgeToIgnoreBadgeValidation){  //During the last 10 minutes! ignore checking the server
                NavigateTo(MapviewActivity.class);
            }
            else{
                Server.getOperation(badge, true, true, new ServerBaseAPI.ServerResult() {
                    @Override
                    public void Always(Object data, Exception error) {
                        if (error!=null)
                            NavigateTo(DisclaimerActivity.class);
                        else
                            NavigateTo(MapviewActivity.class);
                    }
                });
            }
        }
        else
            NavigateTo(DisclaimerActivity.class);

    }
    private <T> void NavigateTo(Class<T> type){
        Intent activity= new Intent(MyApplication.getAppContext(),type);
        startActivity(activity);
        //finish();
    }

    @Override
    public void onRequestPermissionsResult(final int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        Log.d("onRequestPermissi","result!!!!");
        switch (requestCode) {
            case REQUEST_EXTERNAL_STORAGE: {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0  && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    update();
                } else {
                    // permission denied, boo! Disable the
                    // functionality that depends on this permission.
                    Alert("Stop", Constants.Messages.setReadWritePermission, new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                            requestPermission();
                        }
                    }, new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                            finish();
                            Exit();
                        }
                    });
                }
                return;
            }
        }
    }

    private void requestPermission(){
        if (!hasFilePermission()) {
            ActivityCompat.requestPermissions(StartupActivity.this, PERMISSIONS_STORAGE, REQUEST_EXTERNAL_STORAGE);
        }
        else{
            update();
        }

    }

    private boolean hasFilePermission(){
        int permission = ContextCompat.checkSelfPermission(StartupActivity.this, android.Manifest.permission.WRITE_EXTERNAL_STORAGE);
        return (permission == PackageManager.PERMISSION_GRANTED);
    }
    private void update(){
        Alert("Update", Constants.Messages.newVersionAvaiable
                , new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        internalUpdate();
                    }
                }
                , new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        updateAvailable=false;
                        StartupActivity.this.Navigate();
                    }
                });
    }

    private void internalUpdate(){
        if (versionInfo != null){
            updateProgressDialog.setTitle("Downloading...");
            updateProgressDialog.setMessage("0% downloaded.");
            updateProgressDialog.show();

            UpdateApp atualizaApp = new UpdateApp(new UpdateApp.IProcess() {
                @Override
                public void percent(final int percent) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            updateProgressDialog.setMessage(percent + "% downloaded");
                        }
                    });
                }

                @Override
                public void finished(String fileName) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            updateProgressDialog.setTitle("Installing...");
                            updateProgressDialog.setMessage("Download completed. Initilizing the install...");
                        }
                    });
                    Intent intent = new Intent(Intent.ACTION_VIEW);
                    intent.setDataAndType(Uri.fromFile(new File(fileName)), "application/vnd.android.package-archive");
                    //intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK); // without this flag android returned a intent error!
                    startActivityForResult(intent,1);

                }

                @Override
                public void error(Exception e) {

                }
            });
            atualizaApp.setContext(getApplicationContext());
            atualizaApp.execute(versionInfo.url, versionInfo.fileName);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode==0) {
            updateProgressDialog.hide();
            Navigate();
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
