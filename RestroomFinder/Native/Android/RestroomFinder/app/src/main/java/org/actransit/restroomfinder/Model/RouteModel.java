package org.actransit.restroomfinder.Model;

import org.actransit.restroomfinder.Annotation.Property;

/**
 * Created by DevTeam on 6/14/16.
 */
public class RouteModel extends BaseModel {
    @Property(Name="RouteId", PropertyType = Property.PropertyTypeEnum.Both)
    public String routeId ="";
    @Property(Name="Name", PropertyType = Property.PropertyTypeEnum.Both)
    public String name="";
    @Property(Name="DescriptionCodeId", PropertyType = Property.PropertyTypeEnum.Both)
    public String description ="";
}
