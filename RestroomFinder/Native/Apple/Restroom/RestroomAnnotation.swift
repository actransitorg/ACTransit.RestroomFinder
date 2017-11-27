//
//  RestroomAnnotation.swift
//  Restroom
//
//  Created by DevTeam on 12/18/15.
//  Copyright © 2015 DevTeam. All rights reserved.
//

import Foundation
import MapKit

class RestroomAnnotation: NSObject, MKAnnotation{
    var id : Int = 0
    var uuId : String
    var title: String?
    let locationName: String
    let discipline: String
    let hours: String
    //var pinColor:MKPinAnnotationColor=MKPinAnnotationColor.Green
    dynamic var coordinate: CLLocationCoordinate2D
    let drinkingWater: Bool
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, drinkingWater:Bool, hours:String) {
        self.uuId = NSUUID().UUIDString
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.drinkingWater=drinkingWater
        self.hours = hours
        super.init()

    }
    
    var subtitle: String? {
        return locationName
    }
}