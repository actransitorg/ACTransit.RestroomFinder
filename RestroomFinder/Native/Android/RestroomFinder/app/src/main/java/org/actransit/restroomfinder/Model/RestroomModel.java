package org.actransit.restroomfinder.Model;

import android.os.Parcel;
import android.os.Parcelable;
import android.util.Log;

import org.actransit.restroomfinder.Annotation.Property;
import org.json.JSONArray;
import org.json.JSONObject;

import java.lang.reflect.Field;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by atajadod on 5/18/2016.
 */
public class RestroomModel extends BaseModel {
    public Integer restroomId;
    @Property(Name="latDec", PropertyType = Property.PropertyTypeEnum.Both)
    public Double latitude ;
    @Property(Name="longDec", PropertyType = Property.PropertyTypeEnum.Both)
    public Double longtitude ;

    public String actRoute = "";
    public String address = "";
    public String city = "";
    public String country = "";
    public String note = "";
    public String hours = "";
    public String restroomName = "";
    public String restroomType = "";
    public String state = "";
    public Integer zip = 0;

    public boolean isPaid=false;

    @Property(Name="drinkingWater", PropertyType = Property.PropertyTypeEnum.Both)
    public String _drinkingWater = "";
    private Double _averageRating = 0.0;
    public Double distanceFromLocation = -1.0;

    public Boolean drinkingWater (){
        String value = _drinkingWater.toLowerCase();
        if (value.equals("y") ||  value.equals("yes"))
            return true;
        return false;
    }
    public void drinkingWater (boolean value){
        _drinkingWater=value?"y":"n";
    }

    @Property(PropertyType = Property.PropertyTypeEnum.Get)
    public Double averageRating (){
        return _averageRating;
    }

    @Property(PropertyType = Property.PropertyTypeEnum.Set)
    public void averageRating (Double value){
        if (value==null)
            _averageRating = 0.0;
        else
            _averageRating = value;
    }
}


