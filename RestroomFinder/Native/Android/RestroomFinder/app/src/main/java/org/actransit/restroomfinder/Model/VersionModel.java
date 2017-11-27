package org.actransit.restroomfinder.Model;

import org.actransit.restroomfinder.Annotation.Property;

import java.text.DateFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

/**
 * Created by DevTeam on 7/5/16.
 */
public class VersionModel extends BaseModel {
    //private static final String DateTimeFormat="yyyy/MM/dd HH:mm:ss";
    private static final String DateTimeFormat="yyyy-MM-dd'T'HH:mm:ss";
    public String version;
    @Property(Ignore = true)
    public Date date;
    public String url;
    public String applicationType;
    public String fileName;

    @Property(Name = "date",PropertyType = Property.PropertyTypeEnum.Set)
    public void setDate(String dateStr){
        try{
            //date: "2016-07-11T07:58:17"
            SimpleDateFormat dateFormat = new SimpleDateFormat(DateTimeFormat);
            date=dateFormat.parse(dateStr);

        }catch (Exception e){
            e.printStackTrace();
        }
    }
    @Property(Name = "date",PropertyType = Property.PropertyTypeEnum.Get)
    public String getDate(){
        try{
            SimpleDateFormat dateFormat = new SimpleDateFormat(DateTimeFormat);
            return dateFormat.format(date);

        }catch (Exception e){
            e.printStackTrace();
        }
        return "";
    }

}
