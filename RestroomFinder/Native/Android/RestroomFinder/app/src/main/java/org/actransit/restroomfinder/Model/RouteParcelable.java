package org.actransit.restroomfinder.Model;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by DevTeam on 6/15/16.
 */
public class RouteParcelable extends CustomParcelable<RouteModel> {
    public RouteParcelable(){
        super(RouteModel.class, new RouteModel());
    }
    public RouteParcelable(Parcel in){
        super(RouteModel.class,new RouteModel(),in);
    }
    public static final Parcelable.Creator CREATOR = new Parcelable.Creator() {
        public RouteParcelable createFromParcel(Parcel in) {
            return new RouteParcelable(in);
        }
        public RouteParcelable[] newArray(int size) {
            return new RouteParcelable[size];
        }
    };
}
