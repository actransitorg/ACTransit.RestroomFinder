package org.actransit.restroomfinder;

import android.app.Activity;
import android.app.Application;
import android.app.Fragment;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.LinearGradient;
import android.graphics.Shader;
import android.graphics.drawable.PaintDrawable;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.shapes.RectShape;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Process;
import android.os.SystemClock;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.app.AlertDialog;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
//import android.support.annotation.Nullable;
//import android.support.v4.app.FragmentActivity;
//import android.support.v7.app.AlertDialog;
//import android.support.v7.app.AppCompatActivity;

import android.content.DialogInterface;
import android.util.Log;
import android.util.Pair;
import android.view.Gravity;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.TextView;
import android.widget.Toast;
import android.app.ProgressDialog;

import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.Tracker;

import com.google.android.play.core.appupdate.AppUpdateInfo;
import com.google.android.play.core.appupdate.AppUpdateManager;
import com.google.android.play.core.appupdate.AppUpdateManagerFactory;
import com.google.android.play.core.install.InstallState;
import com.google.android.play.core.install.InstallStateUpdatedListener;
import com.google.android.play.core.install.model.AppUpdateType;
import com.google.android.play.core.install.model.InstallStatus;
import com.google.android.play.core.install.model.UpdateAvailability;
import com.google.android.play.core.tasks.Task;

import org.actransit.restroomfinder.Infrastructure.AppStorage;
import org.actransit.restroomfinder.Infrastructure.Constants;
import org.actransit.restroomfinder.Infrastructure.MyApplication;
import org.actransit.restroomfinder.Infrastructure.ServerAPI;
import org.actransit.restroomfinder.Infrastructure.UpdateApp;
import org.actransit.restroomfinder.Model.KeyValue;
import org.actransit.restroomfinder.Model.VersionModel;

import java.io.File;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;
import com.tellexperience.jsonhelper.ServerBaseAPI;

/**
 * Created by atajadod on 5/20/2016.
 */
public abstract class BaseActivity extends AppCompatActivity //FragmentActivity   AppCompatActivity
{
    protected static final int REQUEST_EXTERNAL_STORAGE = 1;
    protected static String[] PERMISSIONS_STORAGE = {
            android.Manifest.permission.READ_EXTERNAL_STORAGE,
            android.Manifest.permission.WRITE_EXTERNAL_STORAGE
    };


    protected Tracker mTracker;
    protected ServerAPI Server;
    protected static boolean updateAvailable=false;
    protected VersionModel versionInfo;
    protected boolean initialized = false;

    AlertDialog movingDialog;

    private Timer timerEverySecond;
    private AppUpdateManager appUpdateManager;
    private int updateRequestCode=1912;
    private static int lastUpdateChecked=0;

    private boolean checkingUpdate = false;





    protected ProgressDialog updateProgressDialog;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        MyApplication application = (MyApplication) getApplication();
        //application.resetTracker();
        mTracker = application.getDefaultTracker();
        String sessionId=AppStorage.Current(this).getSessionId();

        Server = new ServerAPI(this, sessionId);

        timerEverySecond = new Timer();
        timerEverySecond.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                onEverySecond();
            }
        },0,1000);


        Log.d("onCreate", "onCreate: before create appUpdateManager.");
        // Creates instance of the manager.
        appUpdateManager = AppUpdateManagerFactory.create(getApplicationContext());
        Log.d("CheckUpdate","On Create...");
        //checkForUpdate();

        // Returns an intent object that you use to check for an update.


    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == updateRequestCode) {
            if (resultCode != RESULT_OK) {
                Log.d("", "onActivityResult: Update flow failed! Result code: " + resultCode);
                checkForUpdate();
                // If the update is cancelled or fails,
                // you can request to start the update again.
            }
        }
    }


    protected void CheckForUpdateDone(boolean available, AppUpdateInfo appUpdateInfo){

    }

    private void checkForUpdate(){
        if (!Constants.EnableAutoUpdate) {
            CheckForUpdateDone(false,null);
            return;
        }
        Log.d("CheckUpdate","Checking for update!");
        int currentTime= (int)((new Date()).getTime()/1000);
        if (lastUpdateChecked>=currentTime - (300)){
            Log.d("CheckUpdate", "Les then 300, returning... . " + lastUpdateChecked + " : " + currentTime);
            CheckForUpdateDone(updateAvailable,null);
            return;
        }
        lastUpdateChecked = currentTime;

        if (Constants.AppStoreEnabled) {
            Task<AppUpdateInfo> appUpdateInfoTask = appUpdateManager.getAppUpdateInfo();
            // Checks that the platform will allow the specified type of update.
            appUpdateInfoTask.addOnSuccessListener(appUpdateInfo -> {
                if (appUpdateInfo.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE
                        // For a flexible update, use AppUpdateType.FLEXIBLE
                        && appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)) {

                    String name = appUpdateInfo.packageName();
                    int version = appUpdateInfo.availableVersionCode();
                    Log.i("BaseActivity",name + " ,Version: " + Integer.toString(version)  +  " is now available.");

                    CheckForUpdateDone(true,appUpdateInfo);
                    //startUpdate(appUpdateInfo);

                    // Request the update.
                }
                else {
                    CheckForUpdateDone(false,appUpdateInfo);
                }
            })
                    .addOnFailureListener(e->{
                        Log.e("BaseActivity",e.getMessage());
                        CheckForUpdateDone(false,null);
                    });
        }
        else{
            checkingUpdate= true;
            Server.getVersion(new ServerBaseAPI.ServerResult<VersionModel>() {
                @Override
                public void Always(VersionModel data, Exception error) {
                    try{
                        String v= Constants.getVersion();
                        checkingUpdate= false;
                        if (data!=null && data.version.compareTo(v)>0){
                            updateAvailable=true;
                            versionInfo=data;
                            CheckForUpdateDone(true,null);
                            //requestPermission();
                            Log.d("version","----------------------------version:" + data.version);
                        }
                        else
                            CheckForUpdateDone(false,null);
                    }
                    finally {
                        initialized = true;
                    }
                }
            });
        }




    }
    protected void startUpdate(Activity activity, AppUpdateInfo appUpdateInfo){
        try {
            if (Constants.AppStoreEnabled){
                appUpdateManager.startUpdateFlowForResult(
                        // Pass the intent that is returned by 'getAppUpdateInfo()'.
                        appUpdateInfo,
                        // Or 'AppUpdateType.FLEXIBLE' for flexible updates.
                        AppUpdateType.IMMEDIATE,
                        // The current activity making the update request.
                        this,
                        // Include a request code to later monitor this update request.
                        updateRequestCode);
            }
            else {
                Alert("Update", Constants.Messages.newVersionAvailable
                    , new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            requestPermission(activity);

                        }
                    }
                    , new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            finishAffinity();
                            return;
                        }
                    });
            }
        }
        catch (Exception ex){
            Log.e("", "startUpdate: ",ex );
        }
    }


    protected void internalUpdate(){
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
                            updateProgressDialog.setMessage("Download completed. Initializing the install...");
                        }
                    });


                    String mimeType = "application/vnd.android.package-archive";
                    File file = new File(fileName);



                    Intent intent = new Intent(Intent.ACTION_VIEW);
                    //intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK); // without this flag android returned a intent error!
                    //Old approach
                    ////String path =  file.getPath();
                    ////Uri uri = Uri.parse("content:///" + path);
                    //intent.setDataAndType(Uri.fromFile(file), mimeType);
                    ////intent.setDataAndType(uri, mimeType);
                    //end old approach
                    // new approach
                    Uri uri = Uri.fromFile(file);
                    if (Build.VERSION.SDK_INT > Build.VERSION_CODES.M) {
                        String appId=getApplicationContext()
                                .getPackageName() + ".provider";
                        uri = FileProvider.getUriForFile(
                                MyApplication.getAppContext(),
                                appId, file);
                    }

                    intent.setDataAndType(uri, mimeType);
                    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_GRANT_READ_URI_PERMISSION);
                    intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

                    //intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
                    // end new approach

                    //getApplicationContext().startActivity(intent);
                    //startActivityForResult(intent,1);
                    startActivity(intent);

                    finish();





                }

                @Override
                public void error(Exception e) {
                    Log.d("error updating...", "error: " + e.getMessage());
                }
            });
            atualizaApp.setContext(getApplicationContext());
            atualizaApp.execute(versionInfo.url, versionInfo.fileName);
        }
    }


    protected boolean hasFilePermission(Activity activity){
        int permission = ContextCompat.checkSelfPermission(activity, android.Manifest.permission.WRITE_EXTERNAL_STORAGE);
        return (permission == PackageManager.PERMISSION_GRANTED);
    }
    protected void requestPermission(Activity activity){
        if (!hasFilePermission(activity)) {
            if (ActivityCompat.shouldShowRequestPermissionRationale(activity,
                    android.Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
                showDialog("Storage Access",
                        "Restroom Finder application requires your permission to use your device storage in order to download the newer version of this application.",
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                if (which != DialogInterface.BUTTON_POSITIVE){
                                    finishAffinity();
                                    return;
                                }
                                requestPermission(activity);
                            }
                        });
            }
            ActivityCompat.requestPermissions(activity, PERMISSIONS_STORAGE, REQUEST_EXTERNAL_STORAGE);
        }
        else
            internalUpdate();
    }

    protected void onRequestPermissionsResult(Activity activity, final int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        Log.d("BaseActivity","onRequestPermissionsResult!!!!");
        switch (requestCode) {
            case REQUEST_EXTERNAL_STORAGE: {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0  && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    internalUpdate();
                } else {
                    // permission denied, boo! Disable the
                    // functionality that depends on this permission.
                    Alert("Stop", Constants.Messages.setReadWritePermission, new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                            requestPermission(activity);
                        }
                    }, new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                            finishAffinity();
                            Exit();
                        }
                    });
                }
                return;
            }
        }
    }
//    private void popupSnackbarForCompleteUpdate() {
//        Alert("Update","An update has just been downloaded. Restarting the application to complete the installation.");
//        appUpdateManager.completeUpdate();
//    }

    protected void onEverySecond(){
        //do nothing! let every one who needs it use it!
    }

    public static int getPixelsFromDp(Context context, float dp) {
        return MyApplication.getPixelsFromDp(context, dp);
//        final float scale = context.getResources().getDisplayMetrics().density;
//        return (int)(dp * scale + 0.5f);
    }

    @Override
    protected void onStart() {
        super.onStart();
        Log.d("onStart",currentActivity().toString());
    }

    @Override
    protected void onResume() {
        String name = currentActivity().name();
        mTracker.setScreenName(name);
        mTracker.send(new HitBuilders.ScreenViewBuilder().build());

        Log.d("CheckUpdate","On Resume called.");
        super.onResume();

        checkForUpdate();
        // Checks that the update is not stalled during 'onResume()'.
        // However, you should execute this check at all entry points into the app.
//        Task<AppUpdateInfo> ui=appUpdateManager
//                .getAppUpdateInfo()
//                .addOnSuccessListener(
//                        appUpdateInfo -> {
//                            if (appUpdateInfo.updateAvailability() == UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS) {
//                                // If an in-app update is already running, resume the update.
//                                startUpdate(appUpdateInfo);
//                            }
//                        });

        Log.d("onResume",currentActivity().toString());
    }




    @Override
    protected void onPause() {
        super.onPause();
        Log.d("onPause",currentActivity().toString());
    }

    @Override
    protected void onStop() {
        super.onStop();
        Log.d("onStop",currentActivity().toString());
    }

    public AlertDialog.Builder Alert(String title, String message){
        return Alert(title, message, getText(android.R.string.yes), getText(android.R.string.no)
                , new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {

                    }
                },
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {

                    }
                }
        );
    }
    public AlertDialog.Builder Alert(String title, String message, DialogInterface.OnClickListener onOKListener, DialogInterface.OnClickListener onCancelListener){
        return Alert(title, message,getText(android.R.string.yes), getText(android.R.string.no), onOKListener, onCancelListener);
    }
    public AlertDialog.Builder  Alert(String title, String message, CharSequence positiveButtonText, CharSequence negativeButtonText,DialogInterface.OnClickListener onOKListener, DialogInterface.OnClickListener onCancelListener){
        AlertDialog.Builder alert = new AlertDialog.Builder(this);
        alert.setTitle(title)
                .setMessage(message)
                .setCancelable(false)
                .setPositiveButton(positiveButtonText, onOKListener)
                .setNegativeButton(negativeButtonText, onCancelListener)
                .setIcon(android.R.drawable.ic_dialog_alert)
                .show();
        return alert;
    }
    public void AlertBottom(String title, String message){
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setIcon(android.R.drawable.ic_dialog_info)
                .setTitle(title)
                .setMessage(message)
                .setCancelable(true)
                .setPositiveButton("OK", null);
        AlertDialog dialog= builder.create();
        WindowManager.LayoutParams wmlp = dialog.getWindow().getAttributes();
        dialog.getWindow().setBackgroundDrawableResource(R.drawable.round_layout1);
        wmlp.gravity = Gravity.BOTTOM | Gravity.CENTER;
        dialog.show();
    }

    public void setMovingDialog(boolean hide){
        if (hide && movingDialog!=null){
            movingDialog.hide();
            movingDialog.dismiss();
            movingDialog = null;
        }
        else if (!hide && movingDialog==null){
            AlertDialog.Builder builder = new AlertDialog.Builder(this);
            builder.setIcon(android.R.drawable.presence_busy)
                    .setTitle("Stop")
                    .setMessage(Constants.Messages.drivingDisclaimerText)
                    .setCancelable(false);
            movingDialog= builder.create();
            WindowManager.LayoutParams wmlp = movingDialog.getWindow().getAttributes();
            movingDialog.getWindow().setBackgroundDrawableResource(R.drawable.round_layout1);
            wmlp.gravity = Gravity.BOTTOM | Gravity.CENTER;
            movingDialog.show();
        }
    }
    public void Toast(String message){
        Toast(message, Toast.LENGTH_SHORT);
    }
    public void Toast(String message, int duration){
        Toast.makeText(this, message, duration).show();
    }

    public void setTextAppearance(TextView view, int resId) {

        if (Build.VERSION.SDK_INT < 23) {
            view.setTextAppearance(this, resId);

        } else {
            view.setTextAppearance(resId);
        }
    }
    static ProgressDialog mDialog;
    static Integer waitCount=0;
    public void showWait(){
        waitCount++;
        if (mDialog==null || !mDialog.isShowing())
            showWaitDialog();
    }
    public void hideWait(){
        //Log.d("hideWait","---------------------------------------------" + waitCount.toString());
        waitCount--;
        if (waitCount<0)
            waitCount=0;
        if (mDialog!=null && waitCount==0)
            mDialog.dismiss();
    }

    private ProgressDialog showWaitDialog(){
        //Context context=MyApplication.getAppContext();
        //ActivityManager am = (ActivityManager)context.getSystemService(Context.ACTIVITY_SERVICE);
        //ComponentName cn = am.getRunningTasks(1).get(0).topActivity;

        mDialog = new ProgressDialog(this);
        mDialog.setMessage("Please wait...");
        mDialog.setCancelable(false);
        mDialog.show();
        return mDialog;
//        return null;
    }

//    public ProgressDialog showWait(){
//        ProgressDialog mDialog = new ProgressDialog(this);
//        mDialog.setMessage("Please wait...");
//        mDialog.setCancelable(false);
//        mDialog.show();
//        return mDialog;
//    }

    public AlertDialog showDialog(String title, String message){
        return showDialog(title,message,true,null);
    }
    public AlertDialog showDialog(String title, String message,DialogInterface.OnClickListener okCallback){
        return showDialog(title,message,true,okCallback);
    }
    public AlertDialog showDialog(String title, String message, boolean cancelable, DialogInterface.OnClickListener okCallback){
        AlertDialog alertDialog = new AlertDialog.Builder(this).create();
        if (!cancelable)
            alertDialog.setCancelable(false);
        alertDialog.setTitle(title);
        alertDialog.setMessage(message);
        if (okCallback==null){
            okCallback=new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int which) {
                    dialog.dismiss();
                }
            };
        }
        alertDialog.setButton(AlertDialog.BUTTON_NEGATIVE, "OK",okCallback);

        alertDialog.show();
        return alertDialog;
    }


    public Pair<Handler,Object> setTimeout(Runnable r,long delayMillis){
        Object token=new Object();
        final Handler handler = new Handler();
        //handler.postDelayed(r, delayMillis);
        handler.postAtTime(r,token, SystemClock.uptimeMillis() + delayMillis );

        return new Pair<Handler,Object>(handler, token);
    }
    public void clearTimeout(Pair<Handler,Object> obj){
        obj.first.removeCallbacksAndMessages(obj.second);
    }

    public void Exit(){
        android.os.Process.killProcess(android.os.Process.myPid());
        System.exit(1);
    }

    public static class Gradients{
        public static PaintDrawable getColorScala() {
            ShapeDrawable.ShaderFactory shaderFactory = new ShapeDrawable.ShaderFactory() {
                @Override
                public Shader resize(int width, int height) {
                    LinearGradient linearGradient = new LinearGradient(0, 0, 0, height,
                            new int[] {
                                    0xFFFFFFFF,
                                    0xFFDFDFDF,
                                    0xFFCFCFCF,
                                    0xFFC0C0C0,
                                    0xFFCFCFCF,
                                    0xFFDFDFDF,
                                    0xFFFFFFFF }, //substitute the correct colors for these
                            new float[] {
                                    0,0.3f,0.5f,0.7f,0.8f,0.9f,1 },
                            Shader.TileMode.REPEAT);
                    return linearGradient;
                }
            };

            PaintDrawable paint = new PaintDrawable();
            paint.setShape(new RectShape());
            paint.setShaderFactory(shaderFactory);
            return paint;
        }
        public static PaintDrawable getColorScalaBlue() {
            ShapeDrawable.ShaderFactory shaderFactory = new ShapeDrawable.ShaderFactory() {
                @Override
                public Shader resize(int width, int height) {
                    LinearGradient linearGradient = new LinearGradient(0, 0, 0, height,
                            new int[] {
                                    0xFFFFFFFF,
                                    0xFFFFFFFF,
                                    0xFF207cFF }, //substitute the correct colors for these
                            new float[] {
                                    0,0.2f,1 },
                            Shader.TileMode.REPEAT);
                    return linearGradient;
                }
            };

            PaintDrawable paint = new PaintDrawable();
            paint.setShape(new RectShape());
            paint.setShaderFactory(shaderFactory);
            return paint;
        }

    }

    protected  void sendGoogleEvent(String action){
        if (mTracker!=null)
            mTracker.send(new HitBuilders.EventBuilder()
                .setCategory("Action")
                .setAction(action)
                .build());
    }

    public abstract MyApplication.Activity_Enum currentActivity();
}
