package org.actransit.restroomfinder;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.Switch;
import android.widget.TextView;

import org.actransit.restroomfinder.Infrastructure.AppStorage;
import org.actransit.restroomfinder.Infrastructure.Constants;
import org.actransit.restroomfinder.Infrastructure.MyApplication;
import org.actransit.restroomfinder.Model.OperationModel;
import org.actransit.restroomfinder.Model.RouteParcelable;
import org.w3c.dom.Text;

import java.util.ArrayList;
import android.view.View;

import com.android.volley.TimeoutError;
import com.android.volley.VolleyError;
import com.tellexperience.jsonhelper.ServerBaseAPI;

public class DisclaimerActivity extends BaseActivity {
    public static final String PREFS_NAME = "MyPrefsFile";
    private String badge;
    private TextView lblDisclaimer;
    private ScrollView disclaimerScrollView;
    private Button btnDisclaimerDisagree;
    private Button btnDisclaimerAgree;

    private void setVariables(){
        badge= AppStorage.Current(this).getBadge();
        lblDisclaimer = (TextView) findViewById(R.id.lblDisclaimerContent);
        disclaimerScrollView = (ScrollView) findViewById(R.id.dislaimerScrollView);
        btnDisclaimerDisagree = (Button) findViewById(R.id.btnDisclaimerDisagree);
        btnDisclaimerAgree = (Button) findViewById(R.id.btnDisclaimerAgree);
    }
    public DisclaimerActivity(){
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        if ((getIntent().getFlags() & Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT) != 0) {
            finish();
            return;
        }
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_disclaimer);
        setVariables();

        lblDisclaimer.setText(Constants.Messages.onceDisclaimerText);
        btnDisclaimerDisagree.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AppStorage.Current(DisclaimerActivity.this).logOut();

            }
        });
        btnDisclaimerAgree.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showWait();
                Server.getOperation(true, false, new ServerBaseAPI.ServerResult<OperationModel>() {
                    @Override
                    public void Always(OperationModel data, Exception error) {
                        hideWait();
                        if (error==null && data!=null && data.sessionApproved){
                            AppStorage.Current(DisclaimerActivity.this).setDisclaimerShown();
                            NavigateToMap();
                        }
                        else{
                            String errStr="";
                            if (error!=null && (error instanceof VolleyError)){
                                errStr= Server.parseVolleyError((VolleyError)error);
                                Log.d("Error", "Disclaimer->Always: " + errStr);
                            }
                            if (errStr=="" || errStr==null || errStr.startsWith("<!DOCTYPE") || errStr.contains("<html>"))
                                errStr="Something went wrong. Please try again later.";
                            Alert("Error", errStr);
                        }
//
//                        if (error!=null){
//                            String errorMessage="Please enter a valid badge.";
//                            if (error instanceof TimeoutError)
//                                errorMessage="Networ Error. Please try again later.";
//                            showDialog("Error",errorMessage);
//                        }
//                        else{
//                            Log.d("Response", "SessionId: " + data.sessionId );
//                            //AppStorage.Current(DisclaimerActivity.this).setFirstTimeRunningApplication(badge,data.sessionId);
//                            AppStorage.Current(DisclaimerActivity.this).setDisclaimerShown();
//                            NavigateToMap();
//                        }

                    }
                });
            }
        });

    }



    @Override
    public void onBackPressed() {

    }

    private void NavigateToMap(){
        Intent activity= new Intent(DisclaimerActivity.this, MapviewActivity.class);
        startActivity(activity);
        finish();
    }

    @Override
    public MyApplication.Activity_Enum currentActivity(){
        return MyApplication.Activity_Enum.ACTIVITY_CURRENT_PAGE_Disclaimer;
    }

}

