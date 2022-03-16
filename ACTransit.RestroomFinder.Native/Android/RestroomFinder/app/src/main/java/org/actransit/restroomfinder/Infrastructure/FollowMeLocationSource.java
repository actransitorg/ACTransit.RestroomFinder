//package org.actransit.restroomfinder.Infrastructure;
//
//import android.Manifest;
//import android.content.Context;
//import android.content.pm.PackageManager;
//import android.location.Criteria;
//import android.location.Location;
//import android.location.LocationManager;
//
//import android.location.LocationListener;
//
//import android.os.Bundle;
//import android.support.v4.content.ContextCompat;
//import android.util.Log;
//
//import com.google.android.gms.maps.CameraUpdateFactory;
//import com.google.android.gms.maps.GoogleMap;
//import com.google.android.gms.maps.LocationSource;
//import com.google.android.gms.maps.model.LatLng;
//
//import org.actransit.restroomfinder.BaseMapActivity;
//
///**
// * Created by DevTeam on 6/28/16.
// * http://stackoverflow.com/questions/13739990/map-view-following-user-mylocationoverlay-type-functionality-for-android-maps
// */
//public class FollowMeLocationSource implements LocationSource, LocationListener {
//
//    private LocationSource.OnLocationChangedListener mListener;
//    private LocationManager locationManager;
//    private final Criteria criteria = new Criteria();
//    private String bestAvailableProvider;
//    /* Updates are restricted to one every 10 seconds, and only when
//     * movement of more than 10 meters has been detected.*/
//    private final long minTime = 500;     // minimum time interval between location updates, in milliseconds
//    private final float minDistance = 0;    // minimum distance between location updates, in meters
//
//    private Context mContext;
//    private GoogleMap mMap;
//    private BaseMapActivity mParent;
//
// //   public FollowMeLocationSource(Context context, GoogleMap map, Loca) {
//    public FollowMeLocationSource(Context context, GoogleMap map) {
//        // Get reference to Location Manager
//        mContext = context;
//        mMap = map;
//        mParent=(BaseMapActivity) context;
//        locationManager = (LocationManager) mContext.getSystemService(Context.LOCATION_SERVICE);
//        try{
//            getBestAvailableProvider();
//            onLocationChanged(locationManager.getLastKnownLocation(bestAvailableProvider));
//        }
//        catch (SecurityException e){
//
//        }
//
//
//
//        // Specify Location Provider criteria
//        criteria.setAccuracy(Criteria.ACCURACY_FINE);
//        criteria.setPowerRequirement(Criteria.POWER_LOW);
//        criteria.setAltitudeRequired(true);
//        criteria.setBearingRequired(true);
//        criteria.setSpeedRequired(true);
//        criteria.setCostAllowed(true);
//        criteria.setSpeedAccuracy(Criteria.ACCURACY_HIGH);
//        criteria.setHorizontalAccuracy(Criteria.ACCURACY_HIGH);
//        criteria.setVerticalAccuracy(Criteria.ACCURACY_HIGH);
//
//    }
//
//    public void getBestAvailableProvider() {
//            /* The preffered way of specifying the location provider (e.g. GPS, NETWORK) to use
//             * is to ask the Location Manager for the one that best satisfies our criteria.
//             * By passing the 'true' boolean we ask for the best available (enabled) provider. */
//        Log.d("getBestAvailable", "Start");
//        bestAvailableProvider = locationManager.getBestProvider(criteria, true);
//        Log.d ("getBestAvailable", "end" + bestAvailableProvider);
//    }
//
//    /* Activates this provider. This provider will notify the supplied listener
//     * periodically, until you call deactivate().
//     * This method is automatically invoked by enabling my-location layer. */
//    @Override
//    public void activate(LocationSource.OnLocationChangedListener listener) {
//        // We need to keep a reference to my-location layer's listener so we can push forward
//        // location updates to it when we receive them from Location Manager.
//        Log.d("activate", "Start");
//        mListener = listener;
//
//        // Request location updates from Location Manager
//        if (bestAvailableProvider != null) {
//            if (ContextCompat.checkSelfPermission(mContext, Manifest.permission.ACCESS_FINE_LOCATION)
//                    == PackageManager.PERMISSION_GRANTED) {
//                locationManager.requestLocationUpdates(bestAvailableProvider, minTime, minDistance, this);
//            }
//        } else {
//            // (Display a message/dialog) No Location Providers currently available.
//        }
//        Log.d("activate", "end");
//    }
//
//    /* Deactivates this provider.
//     * This method is automatically invoked by disabling my-location layer. */
//    @Override
//    public void deactivate() {
//        // Remove location updates from Location Manager
//        if (ContextCompat.checkSelfPermission(mContext, Manifest.permission.ACCESS_FINE_LOCATION)
//                == PackageManager.PERMISSION_GRANTED) {
//            locationManager.removeUpdates(this);
//        }
//
//        mListener = null;
//    }
//
//    @Override
//    public void onLocationChanged(Location location) {
//        Log.d("source","here I am");
//            /* Push location updates to the registered listener..
//             * (this ensures that my-location layer will set the blue dot at the new/received location) */
//        if (mListener != null) {
//            mListener.onLocationChanged(location);
//            mParent.onLocationChanged(location);
//        }
//
//            /* ..and Animate camera to center on that location !
//             * (the reason for we created this custom Location Source !) */
//        mMap.animateCamera(CameraUpdateFactory.newLatLng(new LatLng(location.getLatitude(), location.getLongitude())));
//    }
//
//    @Override
//    public void onStatusChanged(String s, int i, Bundle bundle) {
//
//    }
//
//    @Override
//    public void onProviderEnabled(String s) {
//
//    }
//
//    @Override
//    public void onProviderDisabled(String s) {
//
//    }
//}
//
