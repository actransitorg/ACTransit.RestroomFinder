package org.actransit.restroomfinder.CustomMapDialog;

import android.view.View;

import com.google.android.gms.maps.model.Marker;

/**
 * Created by atajadod on 5/23/2016.
 */
public interface InfoButtonListener {
    void onInfoButtonClicked(View infoWindow,Marker marker);

}
