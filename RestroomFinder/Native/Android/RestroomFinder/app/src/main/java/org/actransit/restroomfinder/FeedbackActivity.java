package org.actransit.restroomfinder;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Parcelable;
import android.os.PersistableBundle;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.RatingBar;
import android.widget.ScrollView;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.vision.text.Text;

import org.actransit.restroomfinder.Adapter.CustomFeedbackArrayAdapter;
import org.actransit.restroomfinder.Adapter.CustomRestroomArrayAdapter;
import org.actransit.restroomfinder.Infrastructure.AppStorage;
import org.actransit.restroomfinder.Infrastructure.Constants;
import org.actransit.restroomfinder.Infrastructure.MyApplication;
import org.actransit.restroomfinder.Infrastructure.ServerBaseAPI;
import org.actransit.restroomfinder.Model.FeedbackModel;
import org.actransit.restroomfinder.Model.RestroomModel;
import org.actransit.restroomfinder.Model.RestroomParcelable;
import org.actransit.restroomfinder.Model.RouteParcelable;

import java.util.ArrayList;
import java.util.List;

public class FeedbackActivity extends BaseActivity {

    RestroomModel restrooom;
    EditText txtFeedback;
    ListView lstFeedbacks;
    Button btnShowHide;
    Switch chkNeedAttention;
    RatingBar ratingbarFeedback;
    CustomFeedbackArrayAdapter dataSource;
    TextView lblTitle;
    private TextView lblListHeader;

    private void setVariables(){
        Intent activity=getIntent();
        RestroomParcelable r= activity.getParcelableExtra(SharedExtras.Restroom);
        restrooom=r.value;
        txtFeedback = (EditText) findViewById(R.id.txtFeedback);
        lstFeedbacks = (ListView) findViewById(R.id.lstFeedbacks);
        chkNeedAttention = (Switch)findViewById(R.id.chkNeedAttention);
        ratingbarFeedback = (RatingBar)findViewById(R.id.ratingbarFeedback);
        btnShowHide = (Button)findViewById(R.id.btnShowHide);
        lblTitle = (TextView)findViewById(R.id.lblTitle);
        lblListHeader = new TextView(this);

        lblTitle.setText(restrooom.restroomName);
    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_feedback);
        setVariables();
        setTextAppearance(lblListHeader,android.R.style.TextAppearance_Large);
        lstFeedbacks.addHeaderView(lblListHeader);

        showActionBar();
        loadFeedbacks();
    }

    private void showActionBar() {
        LayoutInflater inflator = (LayoutInflater) this
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View v = inflator.inflate(R.layout.actionbar_feedback, null);
        ActionBar actionBar = getSupportActionBar();
        actionBar.setDisplayHomeAsUpEnabled(false);
        actionBar.setDisplayShowHomeEnabled (false);
        actionBar.setDisplayShowCustomEnabled(true);
        actionBar.setDisplayShowTitleEnabled(false);
        actionBar.setCustomView(v);
        v.findViewById(R.id.action_DoSubmit).setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                onActionBarClick(v);
            }
        });
        v.findViewById(R.id.action_DoCancel).setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                onActionBarClick(v);
            }
        });
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        dismissKeyboard();
        return super.dispatchTouchEvent(ev);
    }

    @Override
    public void onBackPressed() {
        finish();
    }

    public void btnShowHideFeedback_onClick(View view){
        int lstVisibility= lstFeedbacks.getVisibility();
        if (lstVisibility == View.INVISIBLE) {
            lstFeedbacks.setVisibility(View.VISIBLE);
            btnShowHide.setText("Hide Feedback");
        }
        else{
            lstFeedbacks.setVisibility(View.INVISIBLE);
            btnShowHide.setText("Show Feedback");
        }
    }

    private void onActionBarClick(View item){
        switch (item.getId()) {
            case R.id.action_DoSubmit:
                Submit();
                break;
            case R.id.action_DoCancel:
                finish();
                break;
            //return true;
        }
    }

    private void Submit(){
        FeedbackModel feedback=new FeedbackModel();
        feedback.feedbackText = txtFeedback.getText().toString();
        feedback.needAttention = chkNeedAttention.isChecked();
        feedback.rate = new Double(ratingbarFeedback.getRating());
        feedback.restroomId = restrooom.restroomId;
        feedback.badge = AppStorage.Current(this).getBadge().value;

        if (feedback.feedbackText.equals("") && feedback.needAttention==false && feedback.rate==0){
            Toast(Constants.Messages.feedbackEmptySumbit,1000);
            return;
        }

        Server.saveFeedback(feedback, new ServerBaseAPI.ServerResult() {
            @Override
            public void Always(Object data, Exception error) {
                if (error != null){
                    String message= error.getLocalizedMessage();
                    if (message=="")
                        message = Constants.Messages.Errors.saveFeedback;
                    Alert("Error", message);
                }
                else{
                    Intent result= new Intent();
                    result.putExtra(SharedExtras.Restroom,restrooom.restroomId);
                    setResult(Activity.RESULT_OK, result);

                    sendGoogleEvent("Feedback sent");
                    Toast(Constants.Messages.feedbackSaved);
                    setTimeout(new Runnable() {
                        @Override
                        public void run() {
                            finish();
                        }
                    },500);

                }
            }
        });
    }
    private void loadFeedbacks(){
        setListHeader(true);
        Server.getFeedbacks(restrooom.restroomId, new ServerBaseAPI.ServerResult<ArrayList<FeedbackModel>>() {
            @Override
            public void Always(ArrayList<FeedbackModel> data, Exception error) {
//                if (error!=null){
//
//                    return;
//                }
                populateFeedbacks(data);
            }
        });
    }

    private void populateFeedbacks(List<FeedbackModel> data){
        if (data == null)
            data=new ArrayList();
        dataSource= new CustomFeedbackArrayAdapter(this, data);
        lstFeedbacks.setAdapter(dataSource);
        setListHeader(false);
        //setListHeader(dataContainer.selectedRoute,dataContainer.portableWaterOnly, false);
        //listEmpty=false;
    }
    private void setListHeader(boolean loading){
        if (loading)
            lblListHeader.setText("Loading...");
        else
            lblListHeader.setText("Feedback");
    }

    private void dismissKeyboard(){
        InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.hideSoftInputFromWindow(txtFeedback.getWindowToken(), 0);
    }
    public static class SharedExtras
    {
        public static String  Restroom="restroom";
    }

    @Override
    public MyApplication.Activity_Enum currentActivity(){
        return MyApplication.Activity_Enum.ACTIVITY_CURRENT_PAGE_Feedback;
    }

}
