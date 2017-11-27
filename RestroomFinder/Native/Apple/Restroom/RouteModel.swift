//
//  RouteModel.swift
//  Restroom
//
//  Created by DevTeam on 2/3/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
import SharedFramework
class RouteModel :BaseModel{
    dynamic var RouteId : String=""
    dynamic var Name : String=""
    dynamic var Description : String=""
    
    required init(obj : NSDictionary){
        super.init(obj: obj)
        let routeId = obj["RouteId"]
        let name = obj["Name"]
        let description = obj["DescriptionCodeId"]
        
        if routeId != nil {
            self.RouteId = String(routeId!)
        }
        if name != nil {
            self.Name=String(name!)
        }
        if description != nil {
            self.Description=String(description!)
        }
        
    }
}