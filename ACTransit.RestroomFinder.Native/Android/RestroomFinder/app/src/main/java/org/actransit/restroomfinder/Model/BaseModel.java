package org.actransit.restroomfinder.Model;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.provider.Settings;
//import android.support.v4.app.ActivityCompat;
import android.telephony.TelephonyManager;

import com.google.firebase.iid.FirebaseInstanceId;
import com.tellexperience.jsonhelper.PropertyModel;

import org.actransit.restroomfinder.Infrastructure.AppStorage;
import org.actransit.restroomfinder.Infrastructure.Constants;
import org.actransit.restroomfinder.Infrastructure.MyApplication;

import android.content.Context;
import android.telephony.TelephonyManager;
import android.view.View;

import java.math.BigDecimal;
import java.util.UUID;


/**
 * Created by DevTeam on 6/14/16.
 */
public class BaseModel {
    //private static String os=System.getProperty("os.version");
    private static String os = Build.VERSION.CODENAME + ", " + Build.VERSION.RELEASE;
    //@PropertyModel(PropertyType = PropertyModel.PropertyTypeEnum.Get)
    public String deviceGuid = "";
    //@PropertyModel(PropertyType = PropertyModel.PropertyTypeEnum.Get)
    public String deviceModel = "";
    //@PropertyModel(PropertyType = PropertyModel.PropertyTypeEnum.Get)
    public String deviceOS = "";

    public String deviceName = "";

    public String systemName = "";

    public String systemVersion = "";

    public String localizedModel = "";

    public String batteryLevel = "";

    public String batteryState = "";

    public double currentLatitude;

    public double currentLongtitude;

    public double currentAltitude;

    public double currentSpeed;

    public double currentHorizontalAccuracy;

    public double currentVerticalAccuracy;

    public BaseModel() {
        final Context context=MyApplication.getAppContext();
        this.deviceOS = os; // OS version
        //this.deviceId= InstanceID.getInstance(MyApplication.getAppContext()).getId();
        //this.deviceId = TelephonyManager.getDeviceId(); //FirebaseInstanceId.getInstance().getId();
        //this.deviceId= android.os.Build.DEVICE;           // Device
        this.deviceModel = android.os.Build.MODEL;            // Model
        this.deviceGuid = MyApplication.getDeviceId();

    }
}
