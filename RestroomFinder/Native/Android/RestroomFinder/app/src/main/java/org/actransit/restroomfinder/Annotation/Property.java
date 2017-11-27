package org.actransit.restroomfinder.Annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Created by atajadod on 5/19/2016.
 */
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.FIELD, ElementType.METHOD}) //on class level
public @interface Property {

    public enum PropertyTypeEnum{
        Set, Get, Both
    }
    String Name() default "";
    PropertyTypeEnum PropertyType() default PropertyTypeEnum.Get;
    boolean Ignore() default false;
}