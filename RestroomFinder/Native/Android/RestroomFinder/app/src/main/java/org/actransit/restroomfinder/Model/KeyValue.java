package org.actransit.restroomfinder.Model;

import org.actransit.restroomfinder.Annotation.Property;

import java.util.Calendar;
import java.util.Date;

/**
 * Created by DevTeam on 6/22/16.
 */

public class KeyValue{
    public KeyValue(){}
    public String key="";
    public String value="";
    @Property(Ignore = true)
    public Date updateDate;

    @Property(Name="updateDate", PropertyType = Property.PropertyTypeEnum.Get)
    public long getUpdateDate(){
        return updateDate.getTime();
    }
    @Property(Name="updateDate", PropertyType = Property.PropertyTypeEnum.Set)
    public void setUpdateDate(long date){
        updateDate = Calendar.getInstance().getTime();
        updateDate.setTime(date);
    }

}