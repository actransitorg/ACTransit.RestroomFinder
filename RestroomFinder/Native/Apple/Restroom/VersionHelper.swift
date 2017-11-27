//
//  VersionHelper.swift
//  Restroom
//
//  Created by DevTeam on 7/7/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
public class VersionHelper{
    private var appVersion = Constants.defaultVersion
    public init(version : String){
        self.appVersion=version
    }
    
    var majorVersion : Double {
        get{
            return Double(appVersion.componentsSeparatedByString(".")[0])!
        }
    }
    var minorVersion : Double {
        get{
            return Double(appVersion.componentsSeparatedByString(".")[1])!
        }
    }
    var buildVersion : Double {
        get{
            return Double(appVersion.componentsSeparatedByString(".")[2])!
        }
    }
    public func toString()->String{
        return appVersion
    }
    
    
    public func isBigger(v: VersionHelper)-> Bool{
        return (appVersion > v.toString())
    }
}