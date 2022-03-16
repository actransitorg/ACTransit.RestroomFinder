package org.actransit.restroomfinder.Model;

import android.os.Parcel;
import android.os.Parcelable;
import android.util.Log;

import com.tellexperience.jsonhelper.PropertyModel;

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
    @PropertyModel(Name="latDec", PropertyType = PropertyModel.PropertyTypeEnum.Both)
    public Double latitude ;
    @PropertyModel(Name="longDec", PropertyType = PropertyModel.PropertyTypeEnum.Both)
    public Double longtitude ;

    public String actRoute = "";
    public String address = "";
    public String city = "";
    public String country = "";
    public String note = "";
    public String nearestIntersection = "";
    public String weekdayHours = "";
    public String saturdayHours = "";
    public String sundayHours = "";
    public String restroomName = "";
    public String serviceProvider = "";
    public String restroomType = "";
    public String contactName = "";
    public String contactTitle = "";
    public String contactPhone = "";
    public String contactEmail = "";
    public String state = "";
    public Integer zip = 0;

    public Boolean approved = false;
    public Boolean isPublic = false;
    public Boolean isHistory = false;
    public Boolean isToiletAvailable = true;
    public Boolean addressChanged=false;
    public Integer toiletGenderId=0;
    public String  labelId = "";

    public boolean isPaid=false;

    @PropertyModel(Name="drinkingWater", PropertyType = PropertyModel.PropertyTypeEnum.Both)
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

    @PropertyModel(PropertyType = PropertyModel.PropertyTypeEnum.Get)
    public Double averageRating (){
        return _averageRating;
    }

    @PropertyModel(PropertyType = PropertyModel.PropertyTypeEnum.Set)
    public void averageRating (Double value){
        if (value==null)
            _averageRating = 0.0;
        else
            _averageRating = value;
    }


    @PropertyModel(Ignore = true)
    public boolean isSelected=false;
}


