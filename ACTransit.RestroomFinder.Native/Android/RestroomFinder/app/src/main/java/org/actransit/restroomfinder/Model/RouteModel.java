package org.actransit.restroomfinder.Model;


import com.tellexperience.jsonhelper.PropertyModel;

/**
 * Created by DevTeam on 6/14/16.
 */
public class RouteModel extends BaseModel {
    @PropertyModel(Name="RouteId", PropertyType = PropertyModel.PropertyTypeEnum.Both)
    public String routeId ="";
    @PropertyModel(Name="Name", PropertyType = PropertyModel.PropertyTypeEnum.Both)
    public String name="";
    @PropertyModel(Name="DescriptionCodeId", PropertyType = PropertyModel.PropertyTypeEnum.Both)
    public String description ="";
}
