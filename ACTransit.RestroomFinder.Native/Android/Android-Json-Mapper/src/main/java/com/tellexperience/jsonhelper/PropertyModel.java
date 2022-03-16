package com.tellexperience.jsonhelper;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Created by Aidin on 1/22/2017.
 */

@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.FIELD, ElementType.METHOD}) //on class level
public @interface PropertyModel {

    public enum PropertyTypeEnum{
        Set, Get, Both
    }
    String Name() default "";
    PropertyTypeEnum PropertyType() default PropertyTypeEnum.Get;
    boolean Ignore() default false;
}