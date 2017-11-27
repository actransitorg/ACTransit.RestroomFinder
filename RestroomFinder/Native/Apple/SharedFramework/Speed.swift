//
//  Speed.swift
//  SharedFramework
//
//  Created by DevTeam on 5/4/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
import MapKit
public class Speed
{
    public static func meterPesSecondToMPH(speed: CLLocationSpeed)-> Int{
        let meterPerHour = speed * 3600
        let kPerHour = meterPerHour / 1000
        let res = Int(round(kPerHour * 0.621371))
        return (res > 0 ? res : 0)
    }
    
    public static func distanceToMile(distance: CLLocationDistance) -> Double{
        let temp = NSString(format: "%.1f", distance * 0.000621371) as String
        return Double(temp)!
    }
}