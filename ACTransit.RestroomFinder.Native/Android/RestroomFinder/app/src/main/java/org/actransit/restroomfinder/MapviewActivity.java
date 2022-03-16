package org.actransit.restroomfinder;

import android.app.Activity;
import android.app.FragmentManager;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.location.Location;
import android.os.Bundle;
import android.os.Handler;
import android.provider.Settings;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.style.ImageSpan;
import android.util.Log;
import android.util.Pair;
import android.view.ContextMenu;
import android.view.GestureDetector;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.TouchDelegate;
import android.view.View;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.play.core.appupdate.AppUpdateInfo;
import com.tellexperience.jsonhelper.ServerBaseAPI;
//import com.google.android.gms.nearby.messages.Message;

import org.actransit.restroomfinder.Adapter.CustomRestroomArrayAdapter;
import org.actransit.restroomfinder.Infrastructure.AppStorage;
import org.actransit.restroomfinder.Infrastructure.ButtonIcon;
import org.actransit.restroomfinder.Infrastructure.CallBack;
import org.actransit.restroomfinder.Infrastructure.Common;
import org.actransit.restroomfinder.Infrastructure.Constants;
import org.actransit.restroomfinder.Infrastructure.CustomListView;
import org.actransit.restroomfinder.Infrastructure.DoubleRingBuffer;
import org.actransit.restroomfinder.Infrastructure.MyApplication;
import org.actransit.restroomfinder.Infrastructure.RetainedFragment;
//import org.actransit.restroomfinder.Infrastructure.ServerBaseAPI;
import org.actransit.restroomfinder.Infrastructure.Speed;
import org.actransit.restroomfinder.Infrastructure.Task;
import org.actransit.restroomfinder.Model.AddressModel;
import org.actransit.restroomfinder.Model.RestroomModel;
import org.actransit.restroomfinder.Model.RestroomViewHolder;
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

public class MapviewActivity extends BaseFusionMapActivity implements GoogleMap.OnInfoWindowClickListener, GoogleMap.OnMapLongClickListener {

    private Button btnShowHide;
    private CustomListView lstRestrooms;
    private Button imgBtnCurrentLocation;
    private TextView lblListHeader;
    private Timer tmrDisclaimer;
    private Timer tmrSpeed;
    private Timer tmrRefresh;
    private Button btnCurrentSpeed;
    private Location lastLocationListRefreshed;
    private Date lastRestroomLoaded;


    private boolean restroomsLoading= false;
    private boolean mapEmpty=true; //To handle orientation changed. on Orientation Changed this will be reset to false because the whole Activity will be recreated by Android.
    private boolean listEmpty=true; //To handle orientation changed. on Orientation Changed this will be reset to false because the whole Activity will be recreated by Android.

    private DataState dataContainer=new DataState();
    private RetainedFragment<DataState> dataFragment;
    //private boolean disclaimerIsBeingShown = false;
    private AlertDialog disclaimerDialog;

    private DoubleRingBuffer speedBuffer=new DoubleRingBuffer(3);

    private GestureDetector gestureDetector;

    private static final int  MenuId_Login=1;
    private static final int  MenuId_Logout=4;
    private static final int MenuId_new_act_restroom=3;
    private static final int  MenuId_new_public_restroom=2;
    private static final int MenuId_refresh_restrooms=5;

    private void setVariables(){
        btnShowHide = (Button)findViewById(R.id.btnShowHide);
        lstRestrooms = (CustomListView)findViewById(R.id.lstRestrooms);
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
        tmrSpeed.scheduleAtFixedRate(new TimerTask() {
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
        },1000,2000);

        tmrRefresh = new Timer("tmrRefresh");
        tmrRefresh.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                boolean refresh= lastRestroomLoaded == null;
                if (!refresh){
                    final long diff=new Date().getTime() - lastRestroomLoaded.getTime();
                    refresh = diff > (Constants.Variables.maxAgeRefreshListInSecond * 1000);
                }
                if (refresh)
                    loadRestrooms(true);
            }
        }, 5000, 60000);
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

        currentView = btnShowHide.getRootView();

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
//        gestureDetector = new GestureDetector(this,new GestureDetector.SimpleOnGestureListener() {
//            public void onLongPress(MotionEvent e) {
//                NavigateToAddRestroom();
//                Log.e("", "Longpress detected");
//                Toast("LongPress!!");
//            }
//        });

    }

    @Override
    protected void CheckForUpdateDone(boolean available, AppUpdateInfo appUpdateInfo) {
        super.CheckForUpdateDone(available, appUpdateInfo);
        if (available)
            startUpdate(MapviewActivity.this, appUpdateInfo);

    }


//    @Override
//    public boolean dispatchTouchEvent(MotionEvent ev) {
//        return gestureDetector.onTouchEvent(ev);
//        //return super.dispatchTouchEvent(ev);
//    }


    @Override
    public void onMapLongClick(LatLng point) {
        if (Common.canAddRestroom) {
            NavigateToAddRestroom(point,!Common.Loggedin);
        }
//        gm.addMarker(new MarkerOptions()
//                .position(point)
//                .title("You are here")
//                .icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_RED)));
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

        AppStorage storage=AppStorage.Current(this);
        String firstName = storage.getFirstName();
        String lastName = storage.getLastName();
        String name= firstName + " " + lastName;

        if (Common.Loggedin)
            menu.add(2, MenuId_Logout, 5, menuIconWithText(getResources().getDrawable(R.drawable.ic_action_account), "Logout " + name));
        else
            menu.add(0, MenuId_Login, 1, menuIconWithText(getResources().getDrawable(R.drawable.ic_action_account), getString(R.string.login)));

        if (Constants.PublicViewEnabled)
            menu.add(1, MenuId_new_public_restroom, 4, menuIconWithText(getResources().getDrawable(R.drawable.ic_action_add), getString(R.string.add_restroom_public)));

        if (Common.Loggedin ){
            menu.add(1, MenuId_refresh_restrooms, 2, menuIconWithText(getResources().getDrawable(R.drawable.ic_menu_refresh), getString(R.string.refresh_restrooms)));

            if (Common.canAddRestroom)
                menu.add(1, MenuId_new_act_restroom, 3, menuIconWithText(getResources().getDrawable(R.drawable.ic_action_add), getString(R.string.add_restroom_act)));

        }



        //menu.getItem(1).setVisible(false);
        //menu.getItem(2).setVisible(true);

        //menu.getItem(0).getSubMenu().getItem(3).setVisible(false);
        //menu.getItem(0).getSubMenu().getItem(4).setVisible(true);

        return super.onCreateOptionsMenu(menu);
    }



    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        LatLng loc;
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
            case MenuId_refresh_restrooms:
                loadRestrooms(true);
                return true;
            case MenuId_new_act_restroom:  //Suggest a new Restroom
                loc=new LatLng(currentLocation.getLatitude(), currentLocation.getLongitude());
                NavigateToAddRestroom(loc,false);
                return true;
            case MenuId_new_public_restroom:  //Suggest a new Restroom
                loc=new LatLng(currentLocation.getLatitude(), currentLocation.getLongitude());
                NavigateToAddRestroom(loc,true);
                return true;
            case MenuId_Logout:
                AppStorage.Current(this).logOut();
                return true;
            case MenuId_Login:
                NavigateToLogin();
                return true;

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
            loadRestrooms(true);
//            int restroomId=data.getIntExtra(FeedbackActivity.SharedExtras.Restroom,-1);
//            Server.getRestroom(restroomId, new ServerBaseAPI.ServerResult<RestroomModel>() {
//                @Override
//                public void Always(RestroomModel data, Exception error) {
//                    if (data != null)
//                        updateList(data);
//                }
//            });
        }
        else if (requestCode == ActivityRequestCode.PICK_AddRestroom && resultCode == Activity.RESULT_OK){
            loadRestrooms(true);
        }
        else if (requestCode == ActivityRequestCode.PICK_EditRestroom && resultCode == Activity.RESULT_OK){
            loadRestrooms(true);
        }
        else{
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

    @Override
    public void onMapReady(final GoogleMap googleMap) {
        super.onMapReady(googleMap);
        mMap.setOnInfoWindowClickListener(this);
        mMap.setOnMapLongClickListener(this);
        mMap.setOnMarkerClickListener(new GoogleMap.OnMarkerClickListener() {
            @Override
            public boolean onMarkerClick(Marker marker) {
                RestroomModel restroom=getRestroom(marker);
                if (restroom==null || lstRestrooms.getDataSource()==null ) return false;
                int index= lstRestrooms.getDataSource().getPosition(restroom);
                Log.i("MarkerClick", "onMarkerClick: restroomID:" + restroom.restroomId + ", position:" + index);
                lstRestrooms.setSelection(index,true);
                //lstRestrooms.getDataSource().notifyDataSetChanged();
                //lstRestrooms.deferNotifyDataSetChanged();
                //lstRestrooms.setItemChecked(index, true);
                return false;
            }
        });
    }

    @Override
    protected void onLocationChanged() {
        //super.onLocationChanged();
        int speed=0;
        if (currentLocation != null){
            loadRestrooms(false);
            loadRoutes();
            speed= Speed.meterPesSecondToMPH(currentLocation.getSpeed());
            Log.d("speed", "onLocationChanged: Speed is " + speed);
            if (speed<1){
                speedBuffer.clear();
                speed=0;
            }
            else {
                speedBuffer.add((double)speed);
                speed = (int)Math.round(speedBuffer.average());
                //indicator += "\r\nA:" + String.format("%.4f",lastLocation.getAltitude());
            }
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
        if (restroom != null){
            String str="";
            if (Common.isWeekday() &&  restroom.weekdayHours!=null && !restroom.weekdayHours.equals(""))
                str = restroom.weekdayHours;
            else if (Common.isSaturday() &&  restroom.saturdayHours!=null && !restroom.saturdayHours.equals(""))
                str = restroom.saturdayHours;
            else if (Common.isSunday() &&  restroom.sundayHours!=null && !restroom.sundayHours.equals(""))
                str = restroom.sundayHours;
            if (!str.equals("")) str = "Hours: " + str;
            if (restroom.note!=null && !restroom.note.equals(""))
                str += "\r\n" + restroom.note;
            if (!str.equals("")) AlertBottom("Info",  str);
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
                        lastRestroomLoaded = new Date();
                        if (dataContainer.portableWaterOnly){
                            dataContainer.Restrooms = new ArrayList<RestroomModel>();
                            for (RestroomModel r:data) {
                                if (r.drinkingWater() && (r.approved || Common.canAddRestroom))
                                    dataContainer.Restrooms.add(r);
                            }
                        }
                        else{
                            dataContainer.Restrooms = new ArrayList<RestroomModel>();
                            for (RestroomModel r:data) {
                                if (r.approved || Common.canAddRestroom)
                                    dataContainer.Restrooms.add(r);
                            }
                        }

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
                    String name = restroom.restroomName;
                    if (!restroom.approved && Common.waitingApprovalText!="")
                        name += " (" + Common.waitingApprovalText + ")";
                    MarkerOptions markerOptions= new MarkerOptions();
                    markerOptions.title(name);
                    markerOptions.snippet(restroom.address);

                    if (!restroom.approved){
                        BitmapDescriptor bd = BitmapDescriptorFactory.fromResource(R.drawable.marker_grey);
                        markerOptions.icon(bd);
                    }
                    else if (restroom.drinkingWater())
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
                CustomRestroomArrayAdapter dataSource= new CustomRestroomArrayAdapter(MapviewActivity.this, data,CustomRestroomArrayAdapter.RestroomList, new CustomRestroomArrayAdapter.onClickListener() {
                    @Override
                    public void onClick(View v, boolean isButton) {
                        if (isButton){
                            registerForContextMenu(v);
                            openContextMenu(v);
                        }
                        else{
                            RestroomViewHolder restroomViewHolder=(RestroomViewHolder) v.getTag();
                            RestroomModel restroom=restroomViewHolder==null?null:restroomViewHolder.restroom;
                            if (lstRestrooms.getDataSource()==null) return;
                            Integer index= lstRestrooms.getDataSource().getPosition(restroom);
                            lstRestrooms.setSelection(index, false);
                            //lstRestrooms.getDataSource().notifyDataSetChanged();
                            Log.i("MarkerClick", "listClick: restroomID:" + restroom.restroomId + ", position:" + index);
                            for (Map.Entry e:markers.entrySet()) {
                                if (e.getValue().equals(restroom)){
                                    Marker m=(Marker)e.getKey();
                                    m.showInfoWindow();
                                    mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(m.getPosition(),mMap.getCameraPosition().zoom));
                                }
                            }
                        }
                    }
                });
                lastLocationListRefreshed= currentLocation;
                lstRestrooms.setDataSource(dataSource);
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
                        lstRestrooms.getDataSource().notifyDataSetChanged();
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
        lstRestrooms.getDataSource().notifyDataSetChanged();
    }

    private void setSpeed(int speed){
        String indicator = "S:" + speed + " MPH";
        btnCurrentSpeed.setText(indicator);

        if (speed>Constants.Variables.applicationDisableSpeed)
            setMovingDialogDebounce(false);
        else
            setMovingDialogDebounce(true);
    }

    Pair<Handler, Object> timeoutHandler=null;
    private boolean lastToBeSetValueForMovingDialog=true;
    private void setMovingDialogDebounce(final Boolean value){
        if (lastToBeSetValueForMovingDialog==value) return;
        if (timeoutHandler!=null)
            clearTimeout(timeoutHandler);
        lastToBeSetValueForMovingDialog= value;
        timeoutHandler=setTimeout(new Runnable() {
            @Override
            public void run() {
                setMovingDialog(value);
            }
        },1000);

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

    @Override
    public void onRequestPermissionsResult(final int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        Log.d("MapviewActivity","onRequestPermissionsResult!!!!");
        onRequestPermissionsResult(MapviewActivity.this, requestCode, permissions, grantResults);
    }


//
//    @Override
//    public boolean onContextItemSelected (MenuItem item){
//        // TODO Auto-generated method stub
//        switch (item.getItemId()) {
//            case CONTEXT_MENU_EDIT: {
//
//            }
//            break;
//            case CONTEXT_MENU_FEEDBACK: {
//                RestroomModel restroom=(RestroomModel) v.getTag();
//                if (restroom!=null)
//                {
//                    if (isButton){
//                        showFeedback(restroom);
//                    }
//                    else{
//                        for (Map.Entry e:markers.entrySet()) {
//                            if (e.getValue().equals(restroom)){
//                                Marker m=(Marker)e.getKey();
//                                m.showInfoWindow();
//                                mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(m.getPosition(),mMap.getCameraPosition().zoom));
//                            }
//                        }
//                    }
//                }
//
//            }
//            break;
//        }
//
//        return super.onContextItemSelected(item);
//    }


    private class DataState{
        public List<RestroomModel> Restrooms;
        public List<RouteModel> Routes;

        public String selectedRoute="";
        public boolean portableWaterOnly = false;
    }
    private CharSequence menuIconWithText(Drawable r, String title) {

        r.setBounds(0, 0, r.getIntrinsicWidth(), r.getIntrinsicHeight());
        SpannableString sb = new SpannableString("    " + title);
        ImageSpan imageSpan = new ImageSpan(r, ImageSpan.ALIGN_BOTTOM);
        sb.setSpan(imageSpan, 0, 1, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);

        return sb;
    }

    private void NavigateToAddRestroom(LatLng point, boolean isPublic){
        try{
            AddressModel addressModel=ReverseGeoCode(point);

            Intent activity= new Intent(this, AddRestroomActivity.class);


            activity.putExtra(AddRestroomActivity.SharedExtras.getLocation(),point);
            activity.putExtra(AddRestroomActivity.SharedExtras.getAddress(),addressModel.address);
            activity.putExtra(AddRestroomActivity.SharedExtras.getPostalCode(),addressModel.postalCode);
            activity.putExtra(AddRestroomActivity.SharedExtras.getPublic(),isPublic);
            startActivityForResult(activity,ActivityRequestCode.PICK_AddRestroom);


        }
        finally {
            //dialog.hide();
        }
    }

    private void NavigateToLogin(){
        try{
            Intent activity= new Intent(this, LoginActivity.class);
            startActivity(activity);
        }
        finally {
            //dialog.hide();
        }
    }
}
