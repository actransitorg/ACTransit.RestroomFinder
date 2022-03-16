//
//  BaseModel.swift
//  SharedFramework
//
//  Created by DevTeam on 5/4/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation


open class BaseModel{
    public init(){}
    //required public init(obj : NSDictionary){}
    required public init(obj:[String:AnyObject]){}
    
    open func toInt64(_ obj: AnyObject!, defaultValue: Int64) -> Int64{
        if (obj == nil){
            return defaultValue
        }
        let value = Int64(String(describing: obj!))
        if (value == nil){
            return defaultValue
        }
        return value!
    }
    open func toInt(_ obj: AnyObject!, defaultValue: Int) -> Int{
        if (obj == nil){
            return defaultValue
        }
        return isNull(Int(String(describing: obj!)) as AnyObject, defaultValue: defaultValue as NSObject) as! Int
    }
    open func toNullableInt(_ obj: AnyObject!, defaultValue: Int?) -> Int?{
        if (obj == nil || obj is NSNull){
            return defaultValue
        }
        let o = Int(String(describing: obj!))
        if (o == nil){
            return defaultValue
        }
        return o
       
    }
    open func toDouble(_ obj: AnyObject!, defaultValue: Double) -> Double{
        if (obj == nil){
            return defaultValue
        }
        return isNull(Double(String(describing: obj!)) as AnyObject, defaultValue: defaultValue as NSObject) as! Double
    }
    open func toBool(_ obj: AnyObject!, defaultValue: Bool) -> Bool{
        if (obj == nil){
            return defaultValue
        }
        return (isNull(obj, defaultValue: defaultValue as NSObject) as! String).toBool(defaultValue)
    }
    open func toNullableBool(_ obj: AnyObject!, defaultValue: Bool?) -> Bool?{
        if (obj == nil || obj is NSNull){
            return defaultValue
        }
        return String(describing:obj!).toNullableBool(defaultValue)
    }
    open func isNull(_ obj: AnyObject!, defaultValue: String) -> String{
        if (obj == nil || obj is NSNull){
            return defaultValue
        }
        return obj as! String
    }
    
    open func isNull(_ obj: AnyObject!, defaultValue: NSObject) -> NSObject{
        if (obj == nil || obj is NSNull){
            return defaultValue
        }
        return obj as! NSObject
    }
}
