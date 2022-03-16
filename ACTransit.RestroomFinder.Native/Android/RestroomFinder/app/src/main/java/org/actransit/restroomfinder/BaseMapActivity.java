//package org.actransit.restroomfinder;
//
//import android.Manifest;
//import android.annotation.SuppressLint;
//import android.content.Context;
//import android.content.Intent;
//import android.content.pm.PackageManager;
//import android.location.Location;
//import android.location.LocationManager;
//import android.os.Bundle;
//import android.os.SystemClock;
//import android.support.annotation.NonNull;
//import android.support.annotation.Nullable;
//import android.support.v4.app.ActivityCompat;
//import android.support.v4.content.ContextCompat;
//import android.util.Log;
//import android.view.View;
//import android.view.ViewGroup;
//import android.widget.ImageButton;
//import android.widget.TextView;
//import android.widget.Toast;
//
//import com.google.android.gms.common.ConnectionResult;
//import com.google.android.gms.common.api.GoogleApiClient;
//import com.google.android.gms.location.LocationListener;
//import com.google.android.gms.location.LocationRequest;
//import com.google.android.gms.location.LocationServices;
//import com.google.android.gms.maps.CameraUpdateFactory;
//import com.google.android.gms.maps.GoogleMap;
//import com.google.android.gms.maps.LocationSource;
//import com.google.android.gms.maps.MapFragment;
//import com.google.android.gms.maps.OnMapReadyCallback;
//import com.google.android.gms.maps.model.CameraPosition;
//import com.google.android.gms.maps.model.LatLng;
//import com.google.android.gms.maps.model.Marker;
//
//import org.actransit.restroomfinder.CustomMapDialog.IMapCallBack;
//import org.actransit.restroomfinder.CustomMapDialog.InfoButtonListener;
//import org.actransit.restroomfinder.CustomMapDialog.MapWrapperLayout;
//import org.actransit.restroomfinder.CustomMapDialog.OnInfoWindowElemTouchListener;
//import org.actransit.restroomfinder.Infrastructure.Constants;
//import org.actransit.restroomfinder.Infrastructure.MyApplication;
//import org.actransit.restroomfinder.Infrastructure.ServerAPI;
//import org.actransit.restroomfinder.Infrastructure.Timer;
//import org.actransit.restroomfinder.Model.FeedbackModel;
//import org.actransit.restroomfinder.Model.RestroomModel;
//import org.actransit.restroomfinder.Model.RestroomParcelable;
//
//import java.util.Collection;
//import java.util.Collections;
//import java.util.HashMap;
//import java.util.Map;
//import java.util.Set;
//import java.util.Date;
//
///**
// * Created by atajadod on 5/20/2016.
// */
////public class BaseMapActivity extends BaseActivity implements OnMapReadyCallback,GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener, LocationListener {
//public class BaseMapActivity extends BaseActivity implements OnMapReadyCallback ,GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener, android.location.LocationListener, IMapCallBack {
//    protected final int MY_PERMISSIONS_REQUEST_ACCESS_FINE_LOCATION=1;
//    protected GoogleMap mMap;
//    protected Location lastLocation;
//    //private ServerAPI server = new ServerAPI();
//    private GoogleApiClient mGoogleApiClient;
//
//    private MapWrapperLayout mapWrapperLayout;
//    private ViewGroup infoWindow;
//    private String provider=LocationManager.NETWORK_PROVIDER;
//
//    protected Map<Marker,RestroomModel> markers= Collections.synchronizedMap(new HashMap<Marker, RestroomModel>());
//
//
//    //private LocationRequest mLocationRequest;
//
//    private LocationManager locationManager ;
//    //private android.location.LocationListener locationListener;
//    private boolean followMe=false;
//    private boolean firstTimeLoaded=true;
//
//
//
//    //private FollowMeLocationSource followMe;
//
//    float latidude=37.8054f;
//    float longitude = -122.2683f;
//
//    @Override
//    protected void onCreate(@Nullable Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        Log.d("onCreate", "Started");
//
//        locationManager = (LocationManager) this.getSystemService(Context.LOCATION_SERVICE);
////        locationListener = new android.location.LocationListener() {
////            public void onLocationChanged(Location location) {
////                // Called when a new location is found by the network location provider.
////                if (followMe)
////                    setLocation(false);
////                if (location.getAccuracy()< Constants.Variables.poorBestHorizontalAccuracy) {
////                    lastLocation=location;
////                    BaseMapActivity.this.onLocationChanged();
////                }
////            }
////
////            public void onStatusChanged(String provider, int status, Bundle extras) {}
////
////            public void onProviderEnabled(String provider) {}
////
////            public void onProviderDisabled(String provider) {}
////        };
//
//
//
//            if (mGoogleApiClient == null) {
//            mGoogleApiClient = new GoogleApiClient.Builder(this)
//                    .addConnectionCallbacks(this)
//                    .addOnConnectionFailedListener(this)
//                    .addApi(LocationServices.API)
//                    .build();
//            mGoogleApiClient.connect();
//        }
//        Log.d("onCreate", "Finished");
//
//    }
//
//    @Override
//    public void onMapReady(final GoogleMap googleMap) {
//        Log.d("onMapReady", "Started");
//        mMap = googleMap;
//
//
//        final MapFragment mapFragment = (MapFragment)getFragmentManager().findFragmentById(R.id.map);
//        this.infoWindow = (ViewGroup)getLayoutInflater().inflate(R.layout.cusominfowindow, null);
//        mapWrapperLayout = (MapWrapperLayout)findViewById(R.id.map_relative_layout);
//        mapWrapperLayout.init(mMap, getPixelsFromDp(this, 39 + 20), infoWindow,this);
//
//        mapWrapperLayout.infoButtonListener=new InfoButtonListener() {
//            @Override
//            public void onInfoButtonClicked(View infoWindow, Marker marker) {
//                RestroomModel model=null;
//                if (markers.containsKey(marker)){
//                    model= markers.get(marker);
//                }
//                showFeedback(model);
//            }
//        };
//
//        setMap();
//        Log.d("onMapReady", "Finish");
////        followMe=new FollowMeLocationSource(this,mMap);
////        followMe.getBestAvailableProvider();
////        mMap.setLocationSource(followMe);
////        mMap.moveCamera(CameraUpdateFactory.zoomTo(15f));
//    }
//
//    @Override
//    protected void onStart() {
//        Log.d("onStart","Start");
//        mGoogleApiClient.connect();
//        super.onStart();
//    }
//
//    @Override
//    protected void onStop() {
//        Log.d("onStop","Stop");
//        mGoogleApiClient.disconnect();
//        super.onStop();
//    }
//
//    @Override
//    protected void onPause() {
//        Log.d("onPause","Pause");
//        stopLocationUpdates();
//        super.onPause();
//    }
//    @Override
//    public void onResume() {
//        Log.d("onResume","Resume");
//        //if (mGoogleApiClient.isConnected() && !mRequestingLocationUpdates) {
//        if (mGoogleApiClient!=null && mGoogleApiClient.isConnected()) {
//            startLocationUpdates();
//        }
//        super.onResume();
//    }
//
//
//    ////
//    @Override
//    public void onConnected(@Nullable Bundle bundle) {
//        if (!checkPermission()){
//            if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.ACCESS_FINE_LOCATION)) {
//                // Show an expanation to the user *asynchronously* -- don't block
//                // this thread waiting for the user's response! After the user
//                // sees the explanation, try again to request the permission.
//                ActivityCompat.requestPermissions(this,
//                        new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
//                        MY_PERMISSIONS_REQUEST_ACCESS_FINE_LOCATION);
//
//            } else {
//
//                ActivityCompat.requestPermissions(this,
//                        new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION},
//                        MY_PERMISSIONS_REQUEST_ACCESS_FINE_LOCATION);
//                // MY_PERMISSIONS_REQUEST_READ_CONTACTS is an
//                // app-defined int constant. The callback method gets the
//                // result of the request.
//            }
//        }
//        else{
//            startLocationUpdates();
//            setLocation(false);
//        }
//    }
////
//    @Override
//    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
//        switch (requestCode) {
//            case MY_PERMISSIONS_REQUEST_ACCESS_FINE_LOCATION: {
//                // If request is cancelled, the result arrays are empty.
//                if (grantResults.length > 0  && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
//                    if (!checkPermission()){
//                        Alert("Stop", Constants.Messages.setLocationAccess);
//                        return;
//                    }
//                    setMap();
//                    setLocation(false);
//
////                    mGoogleApiClient.disconnect();
////                    mGoogleApiClient.connect();
//////                    if (!mGoogleApiClient.isConnected()){
//////                        mGoogleApiClient.connect();
//////                    }
////
////                    try{
////                        mMap.setMyLocationEnabled(true);
////                    }catch(SecurityException e){}
//
////                    mMap.setPadding(0,110,0,100);
////                    setLocation();
////                    startLocationUpdates();
//
//                } else {
//                    // permission denied, boo! Disable the
//                    // functionality that depends on this permission.
//                    Alert("Stop", Constants.Messages.setLocationAccess);
//                }
//                return;
//            }
//
//            // other 'case' lines to check for other
//            // permissions this app might request
//        }
//    }
//
//    protected void startLocationUpdates() {
//        if (checkPermission() && provider!=""){
//            locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, (long)0, 0f, this);
//            locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, (long)0, 0f, this);
//        }
//
//
////        Log.d("startLocationUpdates","Started");
////        try{
////            if (checkPermission()){
////                mLocationRequest = LocationRequest.create()
////                        .setInterval(1000)
////                        //.setFastestInterval(500)
////                        //.setMaxWaitTime(5000)
////                        .setPriority(LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY);
////
////                //mLocationRequest.setSmallestDisplacement(0);
////                LocationServices.FusedLocationApi.requestLocationUpdates(mGoogleApiClient, mLocationRequest, this);
////            }
////        }
////        catch(SecurityException e){
////            e.printStackTrace();
////        }
////        Log.d("startLocationUpdates","Finished.");
//    }
//    protected void stopLocationUpdates() {
//        if (checkPermission()) {
//            locationManager.removeUpdates(this);
//            //LocationServices.FusedLocationApi.removeLocationUpdates(mGoogleApiClient, this);
//        }
//    }
//
////
//    @Override
//    public void onLocationChanged(Location location) {
//        Log.d("Location","Changed");
//        if (location.getAccuracy()< Constants.Variables.poorBestHorizontalAccuracy){
//            lastLocation = location;
//            if (firstTimeLoaded){
//                setLocation(false);
//            }
//            firstTimeLoaded=false;
//            onLocationChanged();
//
//        }
//    }
//
//    @Override
//    public void onProviderEnabled(String provider) {
//        Log.d("provider","provider:" + provider);
//        this.provider=provider;
//    }
//    @Override
//    public void onProviderDisabled(String provider) {this.provider=LocationManager.NETWORK_PROVIDER;
//        Log.d("disabledprovider","provider:" + provider);
//    }
//    @Override
//    public void onStatusChanged(String provider, int status, Bundle extras) {
//        Log.d("onStatusChanged","provider:" + provider);
//    }
//
//    ////
//    @Override
//    public void onConnectionFailed(@NonNull ConnectionResult connectionResult) {
//        Log.e("ConnectionFailed","Connection Failed");
//    }
//
//    @Override
//    public void onConnectionSuspended(int i) {
//        Log.e("Connection Failed","Connection Suspended");
//    }
//
//
//    public RestroomModel getRestroom(Marker marker) {
//        if (markers.containsKey(marker))
//            return markers.get(marker);
//        return null;
//    }
//
//    //
//    protected void onLocationChanged(){
//        Log.d("Location","Changed indirect");
//    }
//
//    protected void showFeedback(RestroomModel restroom){
//        Intent feedback= new Intent(MyApplication.getAppContext(),FeedbackActivity.class);
//        if (restroom!=null){
//            RestroomParcelable r= new RestroomParcelable();
//            r.value= restroom;
//            feedback.putExtra(FeedbackActivity.SharedExtras.Restroom, r);
//        }
//        startActivity(feedback);
//    }
//
//    private void setMap(){
//        if (checkPermission()) {
//            Log.d("setMap", "on Granted");
//
//            mMap.setMyLocationEnabled(true);
//            mMap.setPadding(0,110,0,100);
//
//        } else {
////            ActivityCompat.requestPermissions(this,
////                    new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION},
////                    MY_PERMISSIONS_REQUEST_ACCESS_FINE_LOCATION);
////            // Show rationale and request permission.
//        }
//
//    }
//    private void setLocation(boolean keepZoomSetting){
//        if (checkPermission()){
//            //lastLocation = LocationServices.FusedLocationApi.getLastLocation(mGoogleApiClient);
//            if (lastLocation!= null){
//                if (keepZoomSetting)
//                    mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(lastLocation.getLatitude(), lastLocation.getLongitude()),mMap.getCameraPosition().zoom));
//                else
//                    mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(lastLocation.getLatitude(), lastLocation.getLongitude()),14));
//                //onLocationChanged(lastLocation);
//            }
//        }
//    }
//
//    private boolean checkPermission(){
//        return (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED);
//    }
//
//
//
//}
