//
//  AppStoreAppInfo.swift
//  SharedFramework
//
//  Created by DevTeam on 9/13/18.
//  Copyright © 2018 DevTeam. All rights reserved.
//

import UIKit

open class AppStoreAppInfo: BaseModel{
    //var screenshotUrls : [String]! = nil
    
    public var fileSizeBytes : Double = 0
    public var trackViewUrl : String = ""
    public var minimumOsVersion : String = ""
    public var releaseNotes : String = ""
    public var sellerName : String = ""
    public var releaseDate : String = ""
    public var primaryGenreName : String = ""
    public var primaryGenreId : Double = 0
    public var version : String = ""
    public var description : String = ""
    public var artistId : Double = 0
    public var artistName : String = ""
    public var price : Double = 0
    public var trackId : Double = 0
    public var trackName : String = ""
    public var bundleId : String = ""
    
    var currentVersionReleaseDate : String = ""
   


    override init() {
        super.init()
    }
    public required init(obj : [String: AnyObject]){
        super.init(obj: obj)
        
        
        self.fileSizeBytes = toDouble(obj["fileSizeBytes"], defaultValue: 0)
        self.trackViewUrl = isNull(obj["trackViewUrl"],defaultValue: "")
        self.minimumOsVersion = isNull(obj["minimumOsVersion"],defaultValue: "")
        self.releaseNotes = isNull(obj["releaseNotes"],defaultValue: "")
        self.sellerName = isNull(obj["sellerName"],defaultValue: "")
        self.releaseDate = isNull(obj["releaseDate"],defaultValue: "")
        self.primaryGenreName = isNull(obj["primaryGenreName"],defaultValue: "")
        self.primaryGenreId = toDouble(obj["primaryGenreId"], defaultValue: 0)
        self.version = isNull(obj["version"],defaultValue: "")
        self.description = isNull(obj["description"],defaultValue: "")
        self.artistId = toDouble(obj["artistId"], defaultValue: 0)
        self.artistName = isNull(obj["artistName"],defaultValue: "")
        self.price = toDouble(obj["price"], defaultValue: 0)
        self.trackId = toDouble(obj["trackId"], defaultValue: 0)
        self.trackName = isNull(obj["trackName"],defaultValue: "")
        self.bundleId = isNull(obj["bundleId"],defaultValue: "")
        
        
        
   
    }
    
    func toJsonObject() -> AnyObject{
        return [
            "version": self.version as AnyObject,
            "description" : self.description as  AnyObject
        ] as AnyObject

    }
    
}

