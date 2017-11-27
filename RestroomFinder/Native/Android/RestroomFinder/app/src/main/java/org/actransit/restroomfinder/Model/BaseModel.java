package org.actransit.restroomfinder.Model;

import android.os.Build;

import com.google.android.gms.iid.InstanceID;

import org.actransit.restroomfinder.Annotation.Property;
import org.actransit.restroomfinder.Infrastructure.Constants;
import org.actransit.restroomfinder.Infrastructure.MyApplication;

/**
 * Created by DevTeam on 6/14/16.
 */
public class BaseModel {
    //private static String os=System.getProperty("os.version");
    private static String os= Build.VERSION.CODENAME + ", " + Build.VERSION.RELEASE;
    @Property(PropertyType = Property.PropertyTypeEnum.Get)
    public String deviceId  = "";
    @Property(PropertyType = Property.PropertyTypeEnum.Get)
    public String deviceModel = "";
    @Property(PropertyType = Property.PropertyTypeEnum.Get)
    public String deviceOS  = "";
    public BaseModel(){
        this.deviceOS = os; // OS version
        this.deviceId= InstanceID.getInstance(MyApplication.getAppContext()).getId();
        //this.deviceId= android.os.Build.DEVICE;           // Device
        this.deviceModel= android.os.Build.MODEL;            // Model
    }
}
