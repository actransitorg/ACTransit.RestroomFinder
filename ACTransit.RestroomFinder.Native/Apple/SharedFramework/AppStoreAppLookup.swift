//
//  AppInfoAppLookup.swift
//  SharedFramework
//
//  Created by DevTeam on 9/13/18.
//  Copyright © 2018 DevTeam. All rights reserved.
//

import Foundation


open class AppStoreAppLookup: BaseModel{
    var resultCount : Int! = 0
    var results : [AppStoreAppInfo] = [AppStoreAppInfo]()
  
    var sessionApproved : Bool = false
    
    override init() {
        super.init()
    }
    public required init(obj : [String:AnyObject]){
        super.init(obj: obj)
        
        self.resultCount = toInt(obj["resultCount"], defaultValue: 0)
        
        if (self.resultCount>0){
            let r=obj["results"]
            if let jsonResult = r as? NSArray {
                for item in jsonResult
                {
                    let dic=item as! [String:AnyObject]
                    self.results.append(AppStoreAppInfo(obj: dic))
                }
            }
            
        }
        
        
        //self.results = isNull(obj["results"],defaultValue: "")
    
    }
    
    func toJsonObject() -> AnyObject{
        return [
            "resultCount" : self.resultCount as AnyObject,
            "result" : self.results as AnyObject
        ] as AnyObject

    }
    
}
