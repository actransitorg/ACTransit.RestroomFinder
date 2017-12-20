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
    @objc dynamic var RouteId : String=""
    @objc dynamic var Name : String=""
    @objc dynamic var Description : String=""
    
    required init(obj : [String : AnyObject]){
        super.init(obj: obj)
        let routeId = obj["RouteId"]
        let name = obj["Name"]
        let description = obj["DescriptionCodeId"]
        
        if routeId != nil {
            self.RouteId = String(describing: routeId!)
        }
        if name != nil {
            self.Name=String(describing: name!)
        }
        if description != nil {
            self.Description=String(describing: description!)
        }
        
    }
    
  
}
