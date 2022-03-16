package org.actransit.restroomfinder.Model;

import com.tellexperience.jsonhelper.PropertyModel;

public class AuthenticationModel extends BaseModel  {

    public AuthenticationModel() { }

    public AuthenticationModel(String firstName, String lastName, String badge, String phoneNumber) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.badge = badge;
        this.phoneNumber = phoneNumber;
    }
    public AuthenticationModel(String firstName, String lastName, String badge, String phoneNumber, String confirm2FACode){
        this.firstName = firstName;
        this.lastName = lastName;
        this.badge = badge;
        this.phoneNumber = phoneNumber;
        this.confirm2FACode = confirm2FACode;
    }


    public String firstName;
    public String lastName ;
    public String badge;
    public String phoneNumber ;
    public String confirm2FACode ;
    public String incidentDateTime ;

    //public Boolean agreed = false;
    //public Boolean validating = false;
    public String deviceSessionId;

    @PropertyModel(Name="sessionApproved", PropertyType = PropertyModel.PropertyTypeEnum.Both)
    public Boolean sessionApproved = false;
    @PropertyModel(Name="canAddRestroom", PropertyType = PropertyModel.PropertyTypeEnum.Both)
    public Boolean canAddRestroom = false;
    @PropertyModel(Name="canEditRestroom", PropertyType = PropertyModel.PropertyTypeEnum.Both)
    public Boolean canEditRestroom = false;


//    public Boolean sessionApproved (){
//        return _sessionApproved==0 ? false: true;
//    }
//    public void sessionApproved (Boolean value){
//        _sessionApproved= (value!=null && value.booleanValue()) ?1:0;
//    }
//
//    public Boolean canAddRestroom (){
//        return _canAddRestroom==0 ? false: true;
//    }
//    public void canAddRestroom (Boolean value){
//        _canAddRestroom= (value!=null && value.booleanValue()) ?1:0;
//    }

}