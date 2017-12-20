//
//  Speed.swift
//  SharedFramework
//
//  Created by DevTeam on 5/4/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
import MapKit
open class Speed
{
    open static func meterPesSecondToMPH(_ speed: CLLocationSpeed)-> Int{
        let meterPerHour = speed * 3600
        let kPerHour = meterPerHour / 1000
        let res = Int(round(kPerHour * 0.621371))
        return (res > 0 ? res : 0)
    }
    
    open static func distanceToMile(_ distance: CLLocationDistance) -> Double{
        let temp = NSString(format: "%.1f", distance * 0.000621371) as String
        return Double(temp)!
    }
}
