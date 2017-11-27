package org.actransit.restroomfinder;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.Switch;
import android.widget.TextView;

import org.actransit.restroomfinder.Infrastructure.AppStorage;
import org.actransit.restroomfinder.Infrastructure.Constants;
import org.actransit.restroomfinder.Infrastructure.MyApplication;
import org.actransit.restroomfinder.Infrastructure.ServerBaseAPI;
import org.actransit.restroomfinder.Model.RouteParcelable;
import org.w3c.dom.Text;

import java.util.ArrayList;
import android.view.View;

public class DisclaimerActivity extends BaseActivity {
    public static final String PREFS_NAME = "MyPrefsFile";
    private EditText txtBadge;
    private TextView lblDisclaimer;
    private ScrollView dislaimerScrollView;
    private Button btnDisclaimerDisagree;
    private Button btnDisclaimerAgree;
    private void setVariables(){
        txtBadge = (EditText) findViewById(R.id.txtBadge);
        lblDisclaimer = (TextView) findViewById(R.id.lblDisclaimer);
        dislaimerScrollView = (ScrollView) findViewById(R.id.dislaimerScrollView);
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
                Exit();
            }
        });
        btnDisclaimerAgree.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final String badge=txtBadge.getText().toString();

                Server.getOperation(badge, true, false, new ServerBaseAPI.ServerResult() {
                    @Override
                    public void Always(Object data, Exception error) {
                        if (error!=null)
                            showDialog("Error","Please enter a valid badge.");
                        else{
                            AppStorage.Current(DisclaimerActivity.this).setFirstTimeRunningApplication(badge);
                            NavigateToMap();
                        }

                    }
                });
            }
        });

        dismissKeyboard();
    }


    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        dismissKeyboard();
        return super.dispatchTouchEvent(ev);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        dismissKeyboard();
        return super.onTouchEvent(event);
    }

    @Override
    public void onBackPressed() {

    }

    private void NavigateToMap(){
        Intent activity= new Intent(DisclaimerActivity.this, MapviewActivity.class);
        startActivity(activity);
        finish();
    }

    private void dismissKeyboard(){
        InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.hideSoftInputFromWindow(txtBadge.getWindowToken(), 0);
    }
    @Override
    public MyApplication.Activity_Enum currentActivity(){
        return MyApplication.Activity_Enum.ACTIVITY_CURRENT_PAGE_Disclaimer;
    }

}

