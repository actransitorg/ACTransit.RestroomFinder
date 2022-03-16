package org.actransit.restroomfinder.Model;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by DevTeam on 6/24/16.
 */
public class RestroomParcelable extends CustomParcelable<RestroomModel> {
    public RestroomParcelable(){
        super(RestroomModel.class, new RestroomModel());
    }
    public RestroomParcelable(Parcel in){
        super(RestroomModel.class,new RestroomModel(),in);
    }
    public static final Parcelable.Creator CREATOR = new Parcelable.Creator() {
        public RestroomParcelable createFromParcel(Parcel in) {
            return new RestroomParcelable(in);
        }
        public RestroomParcelable[] newArray(int size) {
            return new RestroomParcelable[size];
        }
    };
}