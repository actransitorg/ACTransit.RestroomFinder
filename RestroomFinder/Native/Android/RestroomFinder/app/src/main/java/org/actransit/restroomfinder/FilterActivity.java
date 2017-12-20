package org.actransit.restroomfinder;

import android.support.v7.app.ActionBar;
import android.app.Activity;
import android.app.Instrumentation;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.widget.Spinner;
import android.widget.ArrayAdapter;
import android.widget.Switch;

import org.actransit.restroomfinder.Infrastructure.MyApplication;
import org.actransit.restroomfinder.Model.RouteModel;
import org.actransit.restroomfinder.Model.RouteParcelable;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by DevTeam on 6/13/16.
 */
public class FilterActivity extends BaseActivity {

    private Spinner spnRoutes;
    private Switch chkPortableWater;
    private List<RouteModel> Routes;
    private List<String> Names;

    private String selectedRoute;
    private boolean waterOnly;

    private void setVariables(){
        Intent activity=getIntent();
        ArrayList tempArray= activity.getParcelableArrayListExtra(SharedExtras.Routes);
        ArrayList<RouteParcelable> ps= (ArrayList<RouteParcelable>)tempArray;
        Routes=new ArrayList();
        Names = new ArrayList();
        for (RouteParcelable p:ps) {
            Routes.add(p.value);
            Names.add(p.value.name);
        }

        spnRoutes = (Spinner)findViewById(R.id.spnRoutes);
        chkPortableWater = (Switch)findViewById(R.id.chkPortableWater);

        selectedRoute=activity.getStringExtra(SharedExtras.SelectedRoute);
        waterOnly = activity.getBooleanExtra(SharedExtras.PortableWaterOnly,false);
        hideWait();
    }
    private void setDefaultUI(){
        chkPortableWater.setChecked(waterOnly);
        Integer position=((ArrayAdapter)spnRoutes.getAdapter()).getPosition(selectedRoute);
        if (position>=0)
            spnRoutes.setSelection(position);
    }

    protected void onCreate(Bundle savedInstanceState) {
        //getWindow().requestFeature(Window.FEATURE_ACTION_BAR_OVERLAY);
        //requestWindowFeature(Window.FEATURE_ACTION_BAR);
        //requestWindowFeature(Window.FEATURE_ACTION_BAR_OVERLAY);
        //requestWindowFeature(Window.FEATURE_ACTION_MODE_OVERLAY);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_filter);
        //getSupportActionBar().setDisplayHomeAsUpEnabled(false);
        showActionBar();

        setVariables();


        //View v=getLayoutInflater().inflate(R.layout.activity_filter,null);
        //v.setBackgroundColor(Color.parseColor("#AABBBBBB"));
        //Drawable background = v.getBackground();
        //v.setAlpha((float)(0.8));
        //findViewById(R.layout.activity_filter);

        // Obtain the SupportMapFragment and get notified when the map is ready to be used.

//        Context context = MyApplication.getAppContext();
//
//        ConnectivityManager cm = (ConnectivityManager)context.getSystemService(Context.CONNECTIVITY_SERVICE);
//        NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
//        boolean isConnected = activeNetwork != null &&
//                activeNetwork.isConnectedOrConnecting();

        //String[] items=  new String[]{"1", "2", "three"};
        //ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_dropdown_item, items);
        String[] items=new String[Names.size()];
        items=Names.toArray(items);
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, R.layout.support_simple_spinner_dropdown_item, items);
        spnRoutes.setAdapter(adapter);

        setDefaultUI();

    }


    @Override
    public void onBackPressed() {
        finish();
    }

    private void showActionBar() {
        LayoutInflater inflator = (LayoutInflater) this
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View v = inflator.inflate(R.layout.actionbar_cancel_filter, null);
        ActionBar actionBar = getSupportActionBar();
        actionBar.setDisplayHomeAsUpEnabled(false);
        actionBar.setDisplayShowHomeEnabled (false);
        actionBar.setDisplayShowCustomEnabled(true);
        actionBar.setDisplayShowTitleEnabled(false);
        actionBar.setCustomView(v);
        v.findViewById(R.id.action_DoFilter).setOnClickListener(new View.OnClickListener(){
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

    private void onActionBarClick(View item){
        switch (item.getId()) {
            case R.id.action_DoFilter:
                Intent result= new Intent();
                Activity parent= getParent();
                if (parent == null) {
                    waterOnly=chkPortableWater.isChecked();
                    Object obj= spnRoutes.getSelectedItem();
                    if ("All".equals(obj))
                        selectedRoute=null;
                    else
                        selectedRoute = obj.toString();
                    result.putExtra(SharedExtras.SelectedRoute,selectedRoute);
                    result.putExtra(SharedExtras.PortableWaterOnly,waterOnly);
                    setResult(Activity.RESULT_OK, result);
                    sendGoogleEvent("Filtered, Route:" + selectedRoute + ", water: " + Boolean.toString(waterOnly));
                    finish();
                    //finishActivity(1);
                }
                else {
                    parent.setResult(1, result);
                    finish();
                    //parent.finishActivity(1);
                }
                break;
            //return true;
            case R.id.action_DoCancel:
                finish();
                break;
            //return true;
        }
    }

    public static class SharedExtras
    {
        public static String  Routes="routes";
        public static String  SelectedRoute="selectedRoute";
        public static String  PortableWaterOnly="portableWaterOnly";
    }
    @Override
    public MyApplication.Activity_Enum currentActivity(){
        return MyApplication.Activity_Enum.ACTIVITY_CURRENT_PAGE_Filter;
    }

}
