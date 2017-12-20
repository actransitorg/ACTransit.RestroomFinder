package org.actransit.restroomfinder;

import android.app.Activity;
import android.app.FragmentManager;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.location.Location;
import android.os.Bundle;
import android.provider.Settings;
import android.support.v7.app.AlertDialog;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.nearby.messages.Message;

import org.actransit.restroomfinder.Adapter.CustomRestroomArrayAdapter;
import org.actransit.restroomfinder.Infrastructure.AppStorage;
import org.actransit.restroomfinder.Infrastructure.CallBack;
import org.actransit.restroomfinder.Infrastructure.Constants;
import org.actransit.restroomfinder.Infrastructure.DoubleRingBuffer;
import org.actransit.restroomfinder.Infrastructure.MyApplication;
import org.actransit.restroomfinder.Infrastructure.RetainedFragment;
import org.actransit.restroomfinder.Infrastructure.ServerBaseAPI;
import org.actransit.restroomfinder.Infrastructure.Speed;
import org.actransit.restroomfinder.Infrastructure.Task;
import org.actransit.restroomfinder.Model.RestroomModel;
import org.actransit.restroomfinder.Model.RouteModel;
import org.actransit.restroomfinder.Model.RouteParcelable;

import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;


public class MapviewActivity extends BaseFusionMapActivity implements GoogleMap.OnInfoWindowClickListener {

    private Button btnShowHide;
    private ListView lstRestrooms;
    private Button imgBtnCurrentLocation;
    private TextView lblListHeader;
    private Timer tmrDisclaimer;
    private Timer tmrSpeed;
    private Button btnCurrentSpeed;
    private Location lastLocationListRefreshed;


    CustomRestroomArrayAdapter dataSource;


    private boolean restroomsLoading= false;
    private boolean mapEmpty=true; //To handle orientation changed. on Orientation Changed this will be reset to false because the whole Activity will be recreated by Android.
    private boolean listEmpty=true; //To handle orientation changed. on Orientation Changed this will be reset to false because the whole Activity will be recreated by Android.

    private DataState dataContainer=new DataState();
    private RetainedFragment<DataState> dataFragment;
    //private boolean disclaimerIsBeingShown = false;
    private AlertDialog disclaimerDialog;

    private DoubleRingBuffer speedBuffer=new DoubleRingBuffer(3);


    private void setVariables(){
        btnShowHide = (Button)findViewById(R.id.btnShowHide);
        lstRestrooms = (ListView)findViewById(R.id.lstRestrooms);
        btnCurrentSpeed = (Button)findViewById(R.id.btnCurrentSpeed);
        btnCurrentSpeed.setVisibility(Constants.Variables.speedVisibility);
        lblListHeader = new TextView(this);
        tmrDisclaimer = new Timer("tmDisclaimer");
        tmrDisclaimer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                MapviewActivity.this.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (disclaimerDialog!=null && disclaimerDialog.isShowing())
                            return;
                        try{
                            showDisclaimer();
                        }
                        finally {
                        }
                    }
                });
            }
        },5000,20000);
        tmrSpeed = new Timer("tmrSpeed");
        tmrDisclaimer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                if (currentLocation!=null){
                    final long diff=new Date().getTime() - currentLocation.getTime();
                    if (diff > Constants.Variables.maxAgeLocationSpeedReset){
                        MapviewActivity.this.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                speedBuffer.clear();
                                setSpeed(0);
                            }
                        });
                    }
                }
            }
        },5000,2000);

    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_mapview);

        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);

        setVariables();


        setTextAppearance(lblListHeader,android.R.style.TextAppearance_Large);
        lstRestrooms.addHeaderView(lblListHeader);

        Context context = MyApplication.getAppContext();


        FragmentManager fm = getFragmentManager();
        dataFragment = (RetainedFragment<DataState>) fm.findFragmentByTag("data");
        // create the fragment and data the first time
        if (dataFragment == null) {
            loadRoutes();
            // add the fragment
            dataFragment = new RetainedFragment<DataState>();
            fm.beginTransaction().add(dataFragment, "data").commit();
            // load the data from the web
            dataFragment.setData(dataContainer);
        }
        else{
            dataContainer=dataFragment.getData();
        }

    }


    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
    }

    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState) {
        super.onRestoreInstanceState(savedInstanceState);
    }

    @Override
    protected void onDestroy() {
        dataFragment.setData(dataContainer);
        super.onDestroy();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.activity_main_actions, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.action_search:
                showWait();

                try{
                    Intent activity= new Intent(this, FilterActivity.class);

                    ArrayList<RouteParcelable> t= new ArrayList();

                    for(Integer i=0;i<dataContainer.Routes.size();i++){
                        //t[i].value=Routes.get(i);
                        RouteParcelable p= new RouteParcelable();
                        p.value = dataContainer.Routes.get(i);
                        t.add(p);
                    }
                    RouteParcelable p= new RouteParcelable();
                    p.value = new RouteModel();
                    p.value.routeId="-1";
                    p.value.name="All";
                    t.add(0,p);

                    activity.putParcelableArrayListExtra(FilterActivity.SharedExtras.Routes,t);
                    activity.putExtra(FilterActivity.SharedExtras.SelectedRoute,dataContainer.selectedRoute);
                    activity.putExtra(FilterActivity.SharedExtras.PortableWaterOnly,dataContainer.portableWaterOnly);
                    startActivityForResult(activity,ActivityRequestCode.PICK_FILTER_CONDITION);

                    return true;

                }
                finally {
                    //dialog.hide();
                }
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == ActivityRequestCode.PICK_FILTER_CONDITION && resultCode == Activity.RESULT_OK){
            dataContainer.selectedRoute= data.getStringExtra(FilterActivity.SharedExtras.SelectedRoute);
            dataContainer.portableWaterOnly= data.getBooleanExtra(FilterActivity.SharedExtras.PortableWaterOnly,false);
            loadRestrooms(true);
        }
        else if (requestCode == ActivityRequestCode.PICK_FEEDBACK && resultCode == Activity.RESULT_OK){
            int restroomId=data.getIntExtra(FeedbackActivity.SharedExtras.Restroom,-1);
            Server.getRestroom(restroomId, new ServerBaseAPI.ServerResult<RestroomModel>() {
                @Override
                public void Always(RestroomModel data, Exception error) {
                    if (data != null)
                        updateList(data);
                }
            });
        }
        else{
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

    @Override
    public void onMapReady(final GoogleMap googleMap) {
        super.onMapReady(googleMap);
        mMap.setOnInfoWindowClickListener(this);
    }

    @Override
    protected void onLocationChanged() {
        //super.onLocationChanged();
        int speed=0;
        if (currentLocation != null){
            loadRestrooms(false);
            loadRoutes();
            speed= Speed.meterPesSecondToMPH(currentLocation.getSpeed());
            speedBuffer.add((double)speed);
            speed = (int)Math.round(speedBuffer.average());
            //indicator += "\r\nA:" + String.format("%.4f",lastLocation.getAltitude());
        }
        else{
            speedBuffer.clear();
            speed=0;
        }
        setSpeed(speed);
    }


    /**
     * Manipulates the map once available.
     * This callback is triggered when the map is ready to be used.
     * This is where we can add markers or lines, add listeners or move the camera. In this case,
     * we just add a marker near Sydney, Australia.
     * If Google Play services is not installed on the device, the user will be prompted to install
     * it inside the SupportMapFragment. This method will only be triggered once the user has
     * installed Google Play services and returned to the app.
     */

    @Override
    public void onInfoWindowClick(Marker marker) {
        RestroomModel restroom=getRestroom(marker);
        if (restroom != null && restroom.hours!=null && !restroom.hours.equals("")){
            AlertBottom("Info", restroom.hours);
        }
    }
    @Override
    public void onBackPressed() {}


    public void btnShowHideList_onClick(View view){
        int lstVisibility= lstRestrooms.getVisibility();
        if (lstVisibility == View.INVISIBLE) {
            lstRestrooms.setVisibility(View.VISIBLE);
            btnShowHide.setText("Hide List");
        }
        else{
            lstRestrooms.setVisibility(View.INVISIBLE);
            btnShowHide.setText("Show List");
        }
    }

//    public void imgBtnCurrentLocation_onClick(View view){
//
//        Location location = super.lastLocation;
//
//        if (location != null) {
//
//            LatLng target = new LatLng(location.getLatitude(), location.getLongitude());
//            CameraPosition position = this.mMap.getCameraPosition();
//
//            CameraPosition.Builder builder = new CameraPosition.Builder();
//            builder.zoom(15);
//            builder.target(target);
//
//            this.mMap.animateCamera(CameraUpdateFactory.newCameraPosition(builder.build()));
//
//        }
//    }


    private void loadRestrooms(Boolean force){

        if (restroomsLoading || currentLocation==null)
            return;
        if (dataContainer.Restrooms==null || force)
        {
            setListHeader("",false, true);
            restroomsLoading=true;
            //Log.d("isLock: ", Boolean.toString(restroomLock.isLocked()));
            Server.getRestrooms(dataContainer.selectedRoute,currentLocation.getLatitude(), currentLocation.getLongitude(), new ServerBaseAPI.ServerResult<List<RestroomModel>>() {
                @Override
                public void Always(final List<RestroomModel> data, Exception error) {
                    try{
                        if (error != null)
                            return;
                        if (dataContainer.portableWaterOnly){
                            dataContainer.Restrooms = new ArrayList<RestroomModel>();
                            for (RestroomModel r:data) {
                                if (r.drinkingWater())
                                    dataContainer.Restrooms.add(r);
                            }
                        }
                        else
                            dataContainer.Restrooms=data;
                        MapviewActivity.this.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                populateMap(dataContainer.Restrooms);
                                populateList(dataContainer.Restrooms);
                            }
                        });
                    }
                    finally{
                        restroomsLoading=false;
                    }
                }
            });
        }
        else{
            if (mapEmpty)
                populateMap(dataContainer.Restrooms);

            if (listEmpty)
                populateList(dataContainer.Restrooms);
            else
                updateList(dataContainer.Restrooms);
        }
    }

    private void populateMap(List<RestroomModel> data){
        mMap.clear();
        markers.clear();
        if (data!=null){
            for (RestroomModel restroom:data) {
                if (restroom != null){
                    MarkerOptions markerOptions= new MarkerOptions();
                    markerOptions.title(restroom.restroomName);
                    markerOptions.snippet(restroom.address);
                    if (restroom.drinkingWater())
                        markerOptions.icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_GREEN));
                    else
                        markerOptions.icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_VIOLET));
                    markerOptions.position(new LatLng(restroom.latitude, restroom.longtitude));
                    Marker marker = mMap.addMarker(markerOptions);
                    markers.put(marker,restroom);
                }
            }
        }
        mapEmpty=false;
    }

    private void populateList(final List<RestroomModel> data){
        SortRestrooms(data, new CallBack() {
            @Override
            public void run(Object... p) {
                dataSource= new CustomRestroomArrayAdapter(MapviewActivity.this, data,CustomRestroomArrayAdapter.RestroolList, new CustomRestroomArrayAdapter.onClickListener() {
                    @Override
                    public void onClick(View v, boolean isButton) {
                        RestroomModel restroom=(RestroomModel) v.getTag();
                        if (restroom!=null)
                        {
                            if (isButton){
                                showFeedback(restroom);
                            }
                            else{
                                for (Map.Entry e:markers.entrySet()) {
                                    if (e.getValue().equals(restroom)){
                                        Marker m=(Marker)e.getKey();
                                        m.showInfoWindow();
                                        mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(m.getPosition(),mMap.getCameraPosition().zoom));
                                    }
                                }
                            }
                        }
                    }
                });
                lastLocationListRefreshed= currentLocation;
                lstRestrooms.setAdapter(dataSource);
                setListHeader(dataContainer.selectedRoute,dataContainer.portableWaterOnly, false);
                listEmpty=false;
            }
        });
    }
    private void updateList(List<RestroomModel> data){
        if (!listUpdateRequired())
            return;
        SortRestrooms(data, new CallBack() {
                    @Override
                    public void run(Object... p) {
                        lastLocationListRefreshed= currentLocation;
                        dataSource.notifyDataSetChanged();
                    }
                }
        );
    }
    private void updateList(RestroomModel data){
        for (RestroomModel restroom:dataContainer.Restrooms) {
            if (restroom.restroomId.equals(data.restroomId)){
                restroom.averageRating(data.averageRating());
                break;
            }
        }
        dataSource.notifyDataSetChanged();
    }

    private void setSpeed(int speed){
        String indicator = "S:" + speed + " MPH";
        btnCurrentSpeed.setText(indicator);
        if (speed>Constants.Variables.applicationDisableSpeed)
            setMovingDialog(false);
        else
            setMovingDialog(true);
    }

    private void SortRestrooms(final List<RestroomModel> data, final CallBack callBack){
        if (data==null){
            callBack.run();
            return;
        }
        Task.execute(new Runnable() {
            @Override
            public void run() {
                Collections.sort(data, new Comparator<RestroomModel>() {
                    @Override
                    public int compare(RestroomModel lhs, RestroomModel rhs) {
                        float[] res1=new float[1];
                        float[] res2=new float[1];
                        Location.distanceBetween(lhs.latitude, lhs.longtitude, currentLocation.getLatitude(), currentLocation.getLongitude(), res1);
                        Location.distanceBetween(rhs.latitude, rhs.longtitude, currentLocation.getLatitude(), currentLocation.getLongitude(), res2);
                        lhs.distanceFromLocation = new Double(Speed.distanceToMile(res1[0]));
                        rhs.distanceFromLocation = new Double(Speed.distanceToMile(res2[0]));
                        if (res1[0]>res2[0])
                            return 1;
                        else if (res1[0]<res2[0])
                            return -1;
                        else
                            return 0;
                    }
                });
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        callBack.run();
                    }
                });
            }
        });
    }
    private void loadRoutes(){
        if (dataContainer.Routes == null) {
            Server.getRoutes(new ServerBaseAPI.ServerResult<List<RouteModel>>() {
                @Override
                public void Always(List<RouteModel> data, Exception error) {
                    dataContainer.Routes=data;
                }
            });
        }
    }

    private void setListHeader(String route, boolean portableWaterOnly, boolean restroomsLoading){
        if (restroomsLoading)
            lblListHeader.setText("Loading...");
        else
            lblListHeader.setText("Restrooms for Route " + ((route==null || route=="")?"All":route));
    }

    private void showDisclaimer(){
        if (AppStorage.Current(this).shouldPopupDisclaimer() ){
            try{
                disclaimerDialog=showDialog("Warning", Constants.Messages.drivingDisclaimerText, false, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        AppStorage.Current(MapviewActivity.this).setPopupDisclaimer();
                        dialogInterface.dismiss();
                    }
                });
            }
            finally {
            }
        }
    }

    private boolean listUpdateRequired(){
        float[] res1=new float[1];
        if (lastLocationListRefreshed==null || currentLocation==null)
            return true;
        Location.distanceBetween(lastLocationListRefreshed.getLatitude(), lastLocationListRefreshed.getLongitude(), currentLocation.getLatitude(), currentLocation.getLongitude(), res1);
        Log.d("Distance","Distance is :" + res1[0]);
        if (res1[0]>=Constants.Variables.minMovementToUpdateList)
            return true;
        return false;
    }

    @Override
    public MyApplication.Activity_Enum currentActivity(){
        return MyApplication.Activity_Enum.ACTIVITY_CURRENT_PAGE_MAP;
    }

    private class DataState{
        public List<RestroomModel> Restrooms;
        public List<RouteModel> Routes;

        public String selectedRoute="";
        public boolean portableWaterOnly = false;
    }

}
