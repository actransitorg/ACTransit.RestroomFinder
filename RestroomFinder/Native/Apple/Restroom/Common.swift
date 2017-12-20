//
//  Common.swift
//  Restroom
//
//  Created by DevTeam on 2/11/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import UIKit
import MapKit

class Common{
    static var currentLocation: CLLocation?
    static var currentDevice : UIDevice {
        get{
            return UIDevice.current
        }
    }
}
