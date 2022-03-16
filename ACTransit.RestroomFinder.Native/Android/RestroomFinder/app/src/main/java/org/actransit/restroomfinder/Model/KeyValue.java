package org.actransit.restroomfinder.Model;

import com.tellexperience.jsonhelper.PropertyModel;


import java.util.Calendar;
import java.util.Date;

/**
 * Created by DevTeam on 6/22/16.
 */

public class KeyValue{
    public KeyValue(){}
    public String key="";
    public String value="";
    @PropertyModel(Ignore = true)
    public Date updateDate;

    @PropertyModel(Name="updateDate", PropertyType = PropertyModel.PropertyTypeEnum.Get)
    public long getUpdateDate(){
        return updateDate.getTime();
    }
    @PropertyModel(Name="updateDate", PropertyType = PropertyModel.PropertyTypeEnum.Set)
    public void setUpdateDate(long date){
        updateDate = Calendar.getInstance().getTime();
        updateDate.setTime(date);
    }

}