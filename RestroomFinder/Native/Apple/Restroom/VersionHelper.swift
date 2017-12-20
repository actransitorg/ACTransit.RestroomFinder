//
//  VersionHelper.swift
//  Restroom
//
//  Created by DevTeam on 7/7/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
open class VersionHelper{
    fileprivate var appVersion = Constants.defaultVersion
    public init(version : String){
        self.appVersion=version
    }
    
    var majorVersion : Double {
        get{
            return Double(appVersion.components(separatedBy: ".")[0])!
        }
    }
    var minorVersion : Double {
        get{
            return Double(appVersion.components(separatedBy: ".")[1])!
        }
    }
    var buildVersion : Double {
        get{
            return Double(appVersion.components(separatedBy: ".")[2])!
        }
    }
    open func toString()->String{
        return appVersion
    }
    
    
    open func isBigger(_ v: VersionHelper)-> Bool{
        return (appVersion > v.toString())
    }
}
