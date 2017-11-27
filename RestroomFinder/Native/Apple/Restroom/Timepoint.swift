//
//  Timepoint.swift
//  Restroom
//
//  Created by DevTeam on 12/29/15.
//  Copyright Â© 2015 DevTeam. All rights reserved.
// test asd asd 

//NOTE: new class, this maps to the endpoint results from : http://(example): http://your.company.dns/path/to/transit-api/route/[route-id]/trip/[trip-id]/pattern?token=[Enter demo transit API token here]
import Foundation
import SharedFramework
class Timepoint:BaseModel {
    dynamic var TripId : Int = 0
    dynamic var Sequence : Int = 0
    dynamic var Latitude : Double = 0
    dynamic var Longitude : Double = 0
    
    required init(obj: NSDictionary) {
        super.init(obj: obj)
        let tripId = obj["TripId"]
        let sequence = obj["Sequence"]
        let latitude = obj["Latitude"]
        let longitude = obj["Longitude"]
        
        if(tripId != nil) {
            self.TripId = Int(String(tripId!))!
        }

        if(sequence != nil) {
            self.Sequence = Int(String(sequence!))!
        }
        
        if(latitude != nil) {
            let latitudeString:String! = String(latitude!)
            self.Latitude = Double(latitudeString)!
        }
        
        if(longitude != nil) {
            let longitudeString:String! = String(longitude!)
            self.Longitude = Double(longitudeString)!
        }
    }
}
