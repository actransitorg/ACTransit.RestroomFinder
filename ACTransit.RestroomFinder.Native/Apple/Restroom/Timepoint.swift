//
//  Timepoint.swift
//  Restroom
//
//  Created by DevTeam on 12/29/15.
//  Copyright © 2015 DevTeam. All rights reserved.
// test asd asd 

//NOTE: new class, this maps to the endpoint results from : http://(example): http://your.company.domain/path/to/transit-api/route/[route-id]/trip/[trip-id]/pattern?token=[Enter demo transit API token here]
import Foundation
import SharedFramework
class Timepoint:BaseModel {
    @objc dynamic var TripId : Int = 0
    @objc dynamic var Sequence : Int = 0
    @objc dynamic var Latitude : Double = 0
    @objc dynamic var Longitude : Double = 0
    
    required init(obj: [String:AnyObject]) {
        super.init(obj: obj)
        let tripId = obj["TripId"]
        let sequence = obj["Sequence"]
        let latitude = obj["Latitude"]
        let longitude = obj["Longitude"]
        
        if(tripId != nil) {
            self.TripId = Int(String(describing: tripId!))!
        }

        if(sequence != nil) {
            self.Sequence = Int(String(describing: sequence!))!
        }
        
        if(latitude != nil) {
            let latitudeString:String! = String(describing: latitude!)
            self.Latitude = Double(latitudeString)!
        }
        
        if(longitude != nil) {
            let longitudeString:String! = String(describing: longitude!)
            self.Longitude = Double(longitudeString)!
        }
    }
}

