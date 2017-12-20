package org.actransit.restroomfinder;

import android.app.Fragment;
import android.content.Context;
import android.graphics.LinearGradient;
import android.graphics.Shader;
import android.graphics.drawable.PaintDrawable;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.shapes.RectShape;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.support.v4.app.FragmentActivity;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.content.DialogInterface;
import android.util.Log;
import android.view.Gravity;
import android.view.WindowManager;
import android.widget.TextView;
import android.widget.Toast;
import android.app.ProgressDialog;

import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.Tracker;

import org.actransit.restroomfinder.Infrastructure.Constants;
import org.actransit.restroomfinder.Infrastructure.MyApplication;
import org.actransit.restroomfinder.Infrastructure.ServerAPI;

/**
 * Created by atajadod on 5/20/2016.
 */
public abstract class BaseActivity extends AppCompatActivity//FragmentActivity   AppCompatActivity
{
    protected Tracker mTracker;
    protected ServerAPI Server;
    AlertDialog movingDialog;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        MyApplication application = (MyApplication) getApplication();
        //application.resetTracker();
        mTracker = application.getDefaultTracker();
        Server = new ServerAPI(this);

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

        super.onResume();
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


    public void setTimeout(Runnable r,long delayMillis){
        final Handler handler = new Handler();
        handler.postDelayed(r, delayMillis);
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
