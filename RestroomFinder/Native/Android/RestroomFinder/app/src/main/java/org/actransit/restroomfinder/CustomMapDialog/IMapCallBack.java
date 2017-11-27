package org.actransit.restroomfinder.CustomMapDialog;

import com.google.android.gms.maps.model.Marker;

import org.actransit.restroomfinder.Model.RestroomModel;

/**
 * Created by DevTeam on 7/6/16.
 */
public interface IMapCallBack {
    public RestroomModel getRestroom(Marker marker);
}
