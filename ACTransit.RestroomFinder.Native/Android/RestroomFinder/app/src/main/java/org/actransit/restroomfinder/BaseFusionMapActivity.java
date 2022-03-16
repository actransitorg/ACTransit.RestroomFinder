package org.actransit.restroomfinder;

import android.Manifest;
import android.app.ActionBar;
import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentSender;
import android.content.pm.PackageManager;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationManager;
import android.os.Bundle;
import android.provider.Settings;
import androidx.annotation.Nullable;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import android.util.Log;
import android.view.ContextMenu;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;
import com.google.android.gms.location.LocationSettingsResult;
import com.google.android.gms.location.LocationSettingsStatusCodes;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;

import org.actransit.restroomfinder.BaseActivity;
import org.actransit.restroomfinder.CustomMapDialog.IMapCallBack;
import org.actransit.restroomfinder.CustomMapDialog.InfoButtonListener;
import org.actransit.restroomfinder.CustomMapDialog.MapWrapperLayout;
import org.actransit.restroomfinder.FeedbackActivity;
import org.actransit.restroomfinder.Infrastructure.Common;
import org.actransit.restroomfinder.Infrastructure.Constants;
import org.actransit.restroomfinder.Infrastructure.MyApplication;
import org.actransit.restroomfinder.Model.AddressModel;
import org.actransit.restroomfinder.Model.RestroomModel;
import org.actransit.restroomfinder.Model.RestroomParcelable;
import org.actransit.restroomfinder.Model.RestroomViewHolder;
import org.actransit.restroomfinder.R;
import com.google.android.gms.analytics.HitBuilders;

import java.io.IOException;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;

/**
 * Created by DevTeam on 7/12/16.
 */
public abstract class BaseFusionMapActivity extends BaseActivity implements
                                            OnMapReadyCallback,GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener,
                                            LocationListener, IMapCallBack,ResultCallback<LocationSettingsResult> {
    protected final int MY_PERMISSIONS_REQUEST_ACCESS_FINE_LOCATION=1;
    protected GoogleMap mMap;
    protected Location currentLocation;
    protected Location lastLocation;

    protected View currentView;

    //private ServerAPI server = new ServerAPI();
    private GoogleApiClient mGoogleApiClient;

    private MapWrapperLayout mapWrapperLayout;
    private ViewGroup infoWindow;
    private String provider= LocationManager.NETWORK_PROVIDER;

    protected Map<Marker,RestroomModel> markers= Collections.synchronizedMap(new HashMap<Marker, RestroomModel>());


    private LocationRequest mLocationRequest;
    private LocationRequest mLocationRequestForRequest;
    private LocationSettingsRequest mLocationSettingsRequest;
    private static long lastLocationSettingRequestCall=0;

    private boolean followMe=false;
    private boolean firstTimeLoaded=true;


    /**
     * Constant used in the location settings dialog.
     */
    protected static final int REQUEST_CHECK_SETTINGS = 0x1;
    protected static final String TAG = "MainActivity";


    //private FollowMeLocationSource followMe;

    float latidude=37.8054f;
    float longitude = -122.2683f;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

//        HttpsURLConnection.setDefaultHostnameVerifier(new HostnameVerifier() {
//            @Override
//            public boolean verify(String hostname, SSLSession arg1) {
//                return true;
//            }
//        });


        Log.d("onCreate", "Started");

        try{
            mLocationRequest = LocationRequest.create()
                    .setInterval(300)
                    .setSmallestDisplacement(1)
                    .setPriority(LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY);
            mLocationRequestForRequest = LocationRequest.create()
                    .setInterval(300)
                    .setSmallestDisplacement(0)
                    .setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
            if (mGoogleApiClient == null) {
                mGoogleApiClient = new GoogleApiClient.Builder(this)
                        .addConnectionCallbacks(this)
                        .addOnConnectionFailedListener(this)
                        .addApi(LocationServices.API)
                        .build();
                mGoogleApiClient.connect();
            }

        }
        catch(Exception e){
            e.printStackTrace();
        }
        Log.d("onCreate", "Finished");



    }

    @Override
    public void onMapReady(final GoogleMap googleMap) {
        Log.d("onMapReady", "Started");
        mMap = googleMap;

        //mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(latidude, longitude),14));
        currentLocation= new Location(provider);
        currentLocation.setLatitude(latidude);
        currentLocation.setLongitude(longitude);
        onLocationChanged();

        final MapFragment mapFragment = (MapFragment)getFragmentManager().findFragmentById(R.id.map);
        this.infoWindow = (ViewGroup)getLayoutInflater().inflate(R.layout.cusominfowindow, null);


        mapWrapperLayout = (MapWrapperLayout)findViewById(R.id.map_relative_layout);
        mapWrapperLayout.init(mMap, getPixelsFromDp(this, 39 + 20), infoWindow,this);

        mapWrapperLayout.infoButtonListener=new InfoButtonListener() {
            @Override
            public void onInfoButtonClicked(View infoWindow, Marker marker) {
                RestroomModel model=null;
                if (markers.containsKey(marker)){
                    model= markers.get(marker);
                    showFeedback(model);
                }
            }
        };

        setMap();
        Log.d("onMapReady", "Finish");
    }


    final int CONTEXT_MENU_EDIT = 1;
    final int CONTEXT_MENU_FEEDBACK = 2;
    @Override
    public void onCreateContextMenu (ContextMenu menu, View
            v, ContextMenu.ContextMenuInfo menuInfo){
        //Context menu
        RestroomViewHolder restroomHolder=(RestroomViewHolder)v.getTag();
        RestroomModel restroom=restroomHolder==null?null:restroomHolder.restroom ;
        if (restroom!=null)
            menu.setHeaderTitle(restroom.restroomName);

        if (Common.canEditRestroom){
            final MenuItem item1=menu.add(Menu.NONE, CONTEXT_MENU_EDIT, Menu.NONE, "Edit");
            item1.setOnMenuItemClickListener(i -> {
                if (restroom!=null)
                    editRestroom(restroom);
                return true; // Signifies you have consumed this event, so propogation can stop.
            });
        }

        final MenuItem item2=menu.add(Menu.NONE, CONTEXT_MENU_FEEDBACK, Menu.NONE, "Write a feedback");
        item2.setOnMenuItemClickListener(i -> {
            if (restroom!=null)
                showFeedback(restroom);
            return true; // Signifies you have consumed this event, so propogation can stop.
        });
    }

    @Override
    protected void onStart() {
        Log.d("onStart","Start Base Fusion-----------------------------------------------------------------------" + lastLocationSettingRequestCall);
        super.onStart();
        try{
            if (mGoogleApiClient!=null) {
                if (lastLocationSettingRequestCall<Calendar.getInstance().getTime().getTime()-1000){
                    lastLocationSettingRequestCall= Calendar.getInstance().getTime().getTime();
                    buildLocationSettingsRequest();
                    checkLocationSettings();
                }
            }

            mGoogleApiClient.connect();

        }
        catch(Exception e){
            e.printStackTrace();
        }

    }

    @Override
    protected void onStop() {
        Log.d("onStop","Stop Base Fusion");
        mGoogleApiClient.disconnect();
        super.onStop();
    }

    @Override
    protected void onPause() {
        Log.d("onPause","Pause");
        //stopLocationUpdates();
        super.onPause();
    }
    @Override
    protected void onResume() {
        //
        // checkLocationProvider();
        Log.d("onResume","Resume");
        //checkLocationProvider();
        if (mGoogleApiClient!=null && mGoogleApiClient.isConnected()) {
            startLocationUpdates();
        }
        super.onResume();
    }


    ////
    @Override
    public void onConnected(@Nullable Bundle bundle) {
        if (!checkPermission()){
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.ACCESS_FINE_LOCATION)) {
                // Show an expanation to the user *asynchronously* -- don't block
                // this thread waiting for the user's response! After the user
                // sees the explanation, try again to request the permission.
                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                        MY_PERMISSIONS_REQUEST_ACCESS_FINE_LOCATION);

            } else {

                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION},
                        MY_PERMISSIONS_REQUEST_ACCESS_FINE_LOCATION);
                // MY_PERMISSIONS_REQUEST_READ_CONTACTS is an
                // app-defined int constant. The callback method gets the
                // result of the request.
            }
        }
        else{
            startLocationUpdates();
            setLocation(false);
        }
    }
    //
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        switch (requestCode) {
            case MY_PERMISSIONS_REQUEST_ACCESS_FINE_LOCATION: {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0  && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    if (!checkPermission()){
                        Alert("Stop", Constants.Messages.setLocationAccess);
                        return;
                    }
                    setMap();
                    setLocation(false);

                } else {
                    Alert("Stop", Constants.Messages.setLocationAccess);
                }
                return;
            }

            // other 'case' lines to check for other
            // permissions this app might request
        }
    }

    protected void startLocationUpdates() {
        if (checkPermission() && provider!="") {

            //mLocationRequest.setSmallestDisplacement(0);
            LocationServices.FusedLocationApi.requestLocationUpdates(mGoogleApiClient, mLocationRequest, this);
        }
    }
    protected void stopLocationUpdates() {
        if (checkPermission()) {
            LocationServices.FusedLocationApi.removeLocationUpdates(mGoogleApiClient, this);
        }
    }

    //
    @Override
    public void onLocationChanged(Location location) {
        Log.d("Location","Changed");
        //if (location.getAccuracy()< Constants.Variables.poorBestHorizontalAccuracy){
        if (location.getAccuracy()< Constants.Variables.averageBestHorizontalAccuracy){
            lastLocation = currentLocation;
            currentLocation = location;
            if (firstTimeLoaded){
                setLocation(false);
            }
            firstTimeLoaded=false;
            onLocationChanged();

        }
    }


    ////
    @Override
    public void onConnectionFailed(@NonNull ConnectionResult connectionResult) {
        Log.e("ConnectionFailed","Connection Failed");
    }

    @Override
    public void onConnectionSuspended(int i) {
        Log.e("Connection Failed","Connection Suspended");
    }


    public RestroomModel getRestroom(Marker marker) {
        if (markers.containsKey(marker))
            return markers.get(marker);
        return null;
    }

    //
    protected void onLocationChanged(){
        Log.d("Location","Changed indirect");
    }

    protected void showFeedback(RestroomModel restroom){
        Intent feedback= new Intent(MyApplication.getAppContext(),FeedbackActivity.class);
        if (restroom!=null){
            RestroomParcelable r= new RestroomParcelable();
            r.value= restroom;
            feedback.putExtra(FeedbackActivity.SharedExtras.Restroom, r);
        }
        //startActivity(feedback);
        startActivityForResult(feedback, ActivityRequestCode.PICK_FEEDBACK);
    }

    protected void editRestroom(RestroomModel restroom){
        if (!Common.canEditRestroom) return;
        Intent intent= new Intent(MyApplication.getAppContext(),AddRestroomActivity.class);
        if (restroom!=null){
            RestroomParcelable r= new RestroomParcelable();
            r.value= restroom;
            intent.putExtra(AddRestroomActivity.SharedExtras.getRestroom(), r);
        }
        //startActivity(feedback);
        startActivityForResult(intent, ActivityRequestCode.PICK_EditRestroom);
    }

    protected void buildLocationSettingsRequest() {
        if (mLocationSettingsRequest==null){
            LocationSettingsRequest.Builder builder = new LocationSettingsRequest.Builder();
            builder.addLocationRequest(mLocationRequestForRequest);
            mLocationSettingsRequest = builder.build();
        }
    }

    /**
     * Check if the device's location settings are adequate for the app's needs using the
     * {@link com.google.android.gms.location.SettingsApi#checkLocationSettings(GoogleApiClient,
     * LocationSettingsRequest)} method, with the results provided through a {@code PendingResult}.
     */
    protected void checkLocationSettings() {
        PendingResult<LocationSettingsResult> result =
                LocationServices.SettingsApi.checkLocationSettings(
                        mGoogleApiClient,
                        mLocationSettingsRequest
                );
        result.setResultCallback(this);
    }

    @Override
    public void onResult(LocationSettingsResult locationSettingsResult) {
        final Activity me = this;
        final Status status = locationSettingsResult.getStatus();
        switch (status.getStatusCode()) {
            case LocationSettingsStatusCodes.SUCCESS:
                Log.i(TAG, "All location settings are satisfied.");
                startLocationUpdates();
                break;
            case LocationSettingsStatusCodes.RESOLUTION_REQUIRED:
                sendGoogleEvent("Location settings are not satisfied. Show the user a dialog to upgrade location settings ");
                Log.i(TAG, "Location settings are not satisfied. Show the user a dialog to upgrade location settings ");

                try {
                    // Show the dialog by calling startResolutionForResult(), and check the result
                    // in onActivityResult().
                    status.startResolutionForResult(me, REQUEST_CHECK_SETTINGS);
                } catch (IntentSender.SendIntentException e) {
                    sendGoogleEvent("PendingIntent unable to execute request.");
                    Log.i(TAG, "PendingIntent unable to execute request.");
                }
                break;
            case LocationSettingsStatusCodes.SETTINGS_CHANGE_UNAVAILABLE:
                sendGoogleEvent("Location settings are inadequate, and cannot be fixed here. Dialog not created.");
                Log.i(TAG, "Location settings are inadequate, and cannot be fixed here. Dialog not created.");
                checkLocationProvider();
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            // Check for the integer request code originally supplied to startResolutionForResult().
            case REQUEST_CHECK_SETTINGS:
                switch (resultCode) {
                    case Activity.RESULT_OK:
                        sendGoogleEvent("User agreed to make required location settings changes.");
                        Log.i(TAG, "User agreed to make required location settings changes.");
                        startLocationUpdates();
                        break;
                    case Activity.RESULT_CANCELED:
                        checkLocationProvider();
                        sendGoogleEvent("User chose not to make required location settings changes.");
                        Log.i(TAG, "User chose not to make required location settings changes.");
                        break;
                }
                break;
        }
    }

    private void setMap(){
        if (checkPermission()) {
            Log.d("setMap", "on Granted");

            mMap.setMyLocationEnabled(true);
            int height=110;
            ActionBar bar= getActionBar();
            if (bar==null){
                androidx.appcompat.app.ActionBar bar1= getSupportActionBar();
                if (bar1!=null)
                    height = bar1.getHeight() + 10;
            }
            else
                height=bar.getHeight() + 10;


            Log.d("setMap", "height: " + height);
            int p=getPixelsFromDp(this,1);
            mMap.setPadding(0,Constants.Variables.mapPaddingTop * p,0,Constants.Variables.mapPaddingBottom * p);
        }

    }
    private void setLocation(boolean keepZoomSetting){
        if (checkPermission()){
            //lastLocation = LocationServices.FusedLocationApi.getLastLocation(mGoogleApiClient);
            if (currentLocation!= null){
                if (keepZoomSetting)
                    mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(currentLocation.getLatitude(), currentLocation.getLongitude()),mMap.getCameraPosition().zoom));
                else
                    mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(currentLocation.getLatitude(), currentLocation.getLongitude()),14));
                //onLocationChanged(lastLocation);
            }
        }
    }

    private boolean checkPermission(){

        return (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED);
    }

    private Boolean locationAccuracyCanceled=false;
    protected void checkLocationProvider(){
        LocationManager lm = (LocationManager)this.getSystemService(Context.LOCATION_SERVICE);
        boolean gps_enabled = false;
        boolean network_enabled = false;

        try {
            gps_enabled = lm.isProviderEnabled(LocationManager.GPS_PROVIDER);
        } catch(Exception ex) {}

        try {
            network_enabled = lm.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
        } catch(Exception ex) {}

        if(!gps_enabled && !network_enabled && !locationAccuracyCanceled) {
            // notify user
            Alert("Warning", Constants.Messages.locationServiceIsDisabled, "Settings","Cancel",new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialogInterface, int i) {
                    Intent myIntent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                    BaseFusionMapActivity.this.startActivity(myIntent);
                }
            }, new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialogInterface, int i) {
                    locationAccuracyCanceled=true;
                }
            });
        }
        else if(!locationAccuracyCanceled && (!gps_enabled || !network_enabled)) {
            // notify user
            Alert("Warning", Constants.Messages.locationModeHighAccuracySetting, "Settings","Cancel",new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialogInterface, int i) {
                    Intent myIntent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                    BaseFusionMapActivity.this.startActivity(myIntent);
                }
            }, new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialogInterface, int i) {
                    locationAccuracyCanceled=true;
                }
            });
        }

    }

    protected AddressModel ReverseGeoCode(LatLng location) {
        AddressModel addressModel=new AddressModel();
        String result= "";
        Geocoder geocoder = new Geocoder(this, Locale.getDefault());
        List<Address> addresses=null;
        try {
            addresses = geocoder.getFromLocation(
                    location.latitude,
                    location.longitude,
                    // In this sample, get just a single address.
                    1);
        } catch (IOException ioException) {
            // Catch network or other I/O problems.
            Toast("Service is not available.");
        } catch (IllegalArgumentException illegalArgumentException) {
            // Catch invalid latitude or longitude values.
            Toast("Invalid Latitude Longitude used.");
        }

        // Handle case where no address was found.
        if (addresses == null || addresses.size()  == 0) {
            return addressModel;
        } else {
            Address address = addresses.get(0);
            addressModel.postalCode=address.getPostalCode();
            // Fetch the address lines using getAddressLine,
            // join them, and send them to the thread.
            for(int i = 0; i <= address.getMaxAddressLineIndex(); i++) {
                addressModel.address += address.getAddressLine(i);
                //result += address.getAddressLine(i);
            }

        }
        return addressModel;
    }
    protected static class ActivityRequestCode{
        public static int PICK_FILTER_CONDITION=1;
        public static int PICK_FEEDBACK = 2;
        public static int PICK_AddRestroom = 3;
        public static int PICK_EditRestroom = 4;
    }

}
