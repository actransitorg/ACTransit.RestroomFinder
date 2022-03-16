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
    let weekdayHours: String
    let saturdayHours: String
    let sundayHours: String
    //var pinColor:MKPinAnnotationColor=MKPinAnnotationColor.Green
    dynamic var coordinate: CLLocationCoordinate2D
    let drinkingWater: Bool
    let note:String
    let approved: Bool!
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, drinkingWater:Bool,
         weekdayHours:String, saturdayHours: String, sundayHours: String,
         note: String, approved: Bool) {
        self.uuId = UUID().uuidString
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.drinkingWater=drinkingWater
        self.weekdayHours = weekdayHours
        self.saturdayHours = saturdayHours
        self.sundayHours = sundayHours
        self.note = note
        self.approved = approved
        

        super.init()

    }
    
    var subtitle: String? {
        return locationName
    }
    
    
    var sourceAction: AnnotationSourceActionEnum = .MapClicked

    
}
public enum AnnotationSourceActionEnum{
    case MapClicked
    case ListClicked
}

