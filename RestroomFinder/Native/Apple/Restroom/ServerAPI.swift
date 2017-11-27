//
//  ServerAPI.swift
//  Restroom
//
//  Created by DevTeam on 12/18/15.
//  Copyright © 2015 DevTeam. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SharedFramework

class ServerAPI: ServerBaseAPI {
    //let url:String="http://10.1.200.244/ToolBeltAPI/api/RestStops"
        
    func getRestStops(route: String, location: CLLocation, callBack: ([RestStopModel], NSError!) -> Void){
        let lat=location.coordinate.latitude
        let long=location.coordinate.longitude
        var r = route
        if (r == "" || r == "-1" || r == "All"){
            r = ""
        }
        let surl=getRestURL(r,lat:String(lat), long:String(long),distance:80000)
        NSLog("surl: %@", surl)
        let res = super.get(surl) as AjaxPromise<[RestStopModel]>
        res.always.addHandler({p in
            callBack(p.data!,p.error)
        })
    }
    
    func getRestStop(restStopId: Int, callBack: (RestStopModel, NSError!) -> Void){
        let surl=getRestURL(restStopId)
        let res = super.get(surl) as AjaxPromise<[RestStopModel]>
        res.always.addHandler({p in
            var data: RestStopModel!
            if (p.data.count>0){
                data = p.data[0]
            }
            callBack(data,p.error)
        })


    }
 
    //NOTE: New method to retrieve demo-hard-coded data for the General Office and Route 1 restrooms.
    func getRestroomsAroundGeneralOffice(callBack: ([RestStopModel], NSError!) -> Void) {
        let surl = getRestURL("1", lat: "37.805413", long: "-122.268528", distance: nil)
        let res = super.get(surl) as AjaxPromise<[RestStopModel]>
        res.always.addHandler({p in
            callBack(p.data,p.error)
        })
        
    }
    
    func getOperationAsync(badge: String, agreed: Bool, validating: Bool, callBack: (OperationModel!, NSError!) -> Void){
        let surl = Constants.Server.operationUrl
        let obj = OperationModel()
        obj.badge = badge
        obj.agreed = agreed
        obj.validating = validating
        obj.incidentDateTime = DateTime.now().toString()
        let res = super.post(surl, jsonObject: obj.toJsonObject()) as AjaxPromise<OperationModel>
        res.always.addHandler({p in
            callBack(p.data,p.error)
        })
    }
    
    func getTripPattern(route: String, tripId: Int, callBack: ([Timepoint], NSError!) -> Void) {
        let surl = getTripPatternURL(route, tripId: tripId)
        let res = super.get(surl) as AjaxPromise<[Timepoint]>
        res.always.addHandler({p in
            callBack(p.data,p.error)
        })
        
    }
    
    
    func getRoutes(callBack: ([RouteModel], NSError!) -> Void) {
        let surl = getRoutesURL()
        let res = super.get(surl) as AjaxPromise<[RouteModel]>
        res.always.addHandler({p in
            callBack(p.data,p.error)
        })
    }
    func getVersion(callBack: ([VersionModel], NSError!) -> Void) {
        let surl = Constants.Server.versionUrl
        let res = super.get(surl) as AjaxPromise<[VersionModel]>
        res.always.addHandler({p in
            callBack(p.data,p.error)
        })
    }
    
    func getFeedbacks(restStopId: Int, callBack: ([FeedbackModel], NSError!) -> Void) {
        let surl = getFeedbacksURL(restStopId)
        let res = super.get(surl) as AjaxPromise<[FeedbackModel]>
        res.always.addHandler({p in
            callBack(p.data,p.error)
        })
    }

    func saveFeedback(feedback: FeedbackModel, callBack: (FeedbackModel!, NSError!) -> Void) {
        let surl = getFeedbacksURL(nil)
        let res = post(surl, jsonObject: feedback.toJsonObject()) as AjaxPromise<FeedbackModel>
        res.always.addHandler({p in
            callBack(p.data,p.error)
        })
    }

    func getTripPatternURL(route:String, tripId:Int) -> String{
        let tripPatternURL = "\(Constants.Server.transitApiUrl)/route/\(route)/trip/\(tripId)/pattern?token=\(Constants.Server.transitApiToken)"
        print(tripPatternURL)
        return tripPatternURL
    }
    
    //NOTE: Made distance nullable
    func getRestURL(route:String, lat:String, long:String, distance:Int?)-> String{
        let returnUrl = "\(Constants.Server.restUrl)?routeAlpha=\(route)&direction=&lat=\(lat)&longt=\(long)"

        if(distance != nil) {
            return "\(returnUrl)&distance=\(distance)";
        } else {
            return returnUrl;
        }
    }
    func getRestURL(restStopId: Int)-> String{
        return  "\(Constants.Server.restUrl)/\(restStopId)"
    }
    func getOperationURL(badge:String)-> String{
        return "\(Constants.Server.operationUrl)?badgeNumber=\(badge)"
    }
    
    func getRoutesURL() -> String{
        return "\(Constants.Server.transitApiUrl)/routes/?token=\(Constants.Server.transitApiToken)"
    }
    func getFeedbacksURL(restStopId : Int?) -> String{
        if (restStopId != nil){
            return "\(Constants.Server.baseRestroomURL)/Feedbasck?restStopId=\(restStopId!)"
        }
        return "\(Constants.Server.baseRestroomURL)/Feedback/"
    }
    
}



