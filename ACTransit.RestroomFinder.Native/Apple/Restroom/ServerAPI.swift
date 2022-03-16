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
        
    func getRestrooms(_ route: String, location: CLLocation, isPublic:Bool, callBack: @escaping ([RestStopModel], NSError?) -> Void){
        getRestStops(route, location: location, isPublic: isPublic, callBack: callBack)
    }
    
    private func getRestStops(_ route: String, location: CLLocation, isPublic: Bool, callBack: @escaping ([RestStopModel], NSError?) -> Void){
        let lat=location.coordinate.latitude
        let long=location.coordinate.longitude
        var r = route
        if (r == "" || r == "-1" || r == "All"){
            r = ""
        }
        var surl=getRestroomURL(r,lat:String(lat), long:String(long),distance:80000, isPublic: isPublic, isPending: false)
        
        NSLog("surl: %@", surl)
        var promises : Array<AjaxPromise<[RestStopModel]>>=[]
        let res1 = super.get(surl, headers: headers) as AjaxPromise<[RestStopModel]>
        promises.append(res1)
//        res1.always.addHandler({p in
//            if (p.data==nil){
//                callBack([],p.error)
//            }
//            else{
//                callBack(p.data, p.error)
//            }
//        })
        
        if (!isPublic && Common.canAddRestroom()){
            surl=getRestroomURL(r,lat:String(lat), long:String(long),distance:80000, isPublic: isPublic, isPending: true)
            let res2 = super.get(surl, headers: headers) as AjaxPromise<[RestStopModel]>
            promises.append(res2)
        }
        
        let pHandler = PromiseHandler(promises: promises);
        pHandler.always.addHandler({arr in
            var err:NSError!
            var data:[RestStopModel] = []
            for p in arr{
                
                err = p.error
                if (err != nil){
                    break;
                }
                if (p.data != nil){
                    data.append(contentsOf: p.data)
                }
            }
            if (err != nil){
                callBack([], err)
            }
            else{
                callBack(data, err)
            }
                
        })
        pHandler.wait()
    }
    
    public func getRestStop(_ restStopId: Int, isPublic: Bool, callBack: @escaping (RestStopModel?, NSError?) -> Void){
//        let surl=getRestroomURL(restStopId, isPublic: isPublic)
//        let res = super.get(surl, headers: headers) as AjaxPromise<[RestStopModel]>
//        res.always.addHandler({p in
//            var data: RestStopModel?
//            if (p.data != nil && p.data.count>0){
//                data = p.data[0]
//            }
//            callBack(data,p.error)
//        })
        if (Common.currentLocation == nil) {
            callBack(nil, NSError(domain: "ApplicationGenerated", code: 401,
                                  userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("UnknownLocation", comment: "Location is unknown")]))
            return
        }
        self.getRestrooms("All", location: Common.currentLocation!, isPublic: false, callBack: {(jsonResult:[RestStopModel], error:NSError!) -> Void in
            DispatchQueue.main.async(execute: {
                defer{
                    if (error != nil){
                        callBack(nil,error)
                    }
                }
                for r in jsonResult {
                    if (r.id == restStopId){
                        callBack(r,nil)
                        return
                    }
                }
                
            })
        })
    }
 
    //NOTE: New method to retrieve demo-hard-coded data for the General Office and Route 1 restrooms.
//    func getRestroomsAroundGeneralOffice(_ callBack: @escaping ([RestStopModel], NSError?) -> Void) {
//        let surl = getRestURL("1", lat: "37.805413", long: "-122.268528", distance: nil)
//        let res = super.get(surl, headers: headers) as AjaxPromise<[RestStopModel]>
//        res.always.addHandler({p in
//            if (p.data==nil){
//                callBack([],p.error)
//            }
//            else{
//                callBack(p.data, p.error)
//            }
//        })
//
//    }
    func sendSecurityCode(_ firstName: String, lastName: String, badge: String, phoneNumber: String, callBack: @escaping (Bool, NSError?) -> Void){
        let surl = Constants.Server.sendSecurityCodeUrl
        let obj = AuthenticationModel()
        obj.firstName = firstName
        obj.lastName = lastName
        obj.badge = badge
        obj.phoneNumber = phoneNumber
        obj.agreed = false
        obj.validating = false
        obj.deviceSessionId = AppStorage.sessionId
        obj.incidentDateTime = DateTime.now().toString()
        let head=headers;
        let res = super.post(surl, jsonObject: obj.toJsonObject(), headers: head) as AjaxPromise<BoolModel>
        res.always.addHandler({p in
            callBack(p.data?.value ?? false,p.error)
        })
    }
    func validateSecurityCode(_ firstName: String, lastName: String, badge: String, phoneNumber: String, securityCode: String, callBack: @escaping (AuthenticationModel?, NSError?) -> Void){
        let surl = Constants.Server.validateSecurityCodeUrl
        let obj = AuthenticationModel()
        obj.firstName = firstName
        obj.lastName = lastName
        obj.badge = badge
        obj.phoneNumber = phoneNumber
        obj.confirm2FACode = securityCode
        obj.agreed = false
        obj.validating = false
        obj.deviceSessionId = AppStorage.sessionId
        obj.incidentDateTime = DateTime.now().toString()
        let head=headers;
        let res = super.post(surl, jsonObject: obj.toJsonObject(), headers: head) as AjaxPromise<AuthenticationModel>
        res.always.addHandler({p in
            callBack(p.data,p.error)
        })
    }
    
    
    func getOperationAsync(agreed: Bool, validating: Bool, callBack: @escaping (OperationModel?, NSError?) -> Void){
        let surl = Constants.Server.operationUrl
        let obj = OperationModel()
        obj.firstName = AppStorage.firstName
        obj.lastName = AppStorage.lastName
        obj.badge = AppStorage.badge
        obj.agreed = agreed
        //obj.cardNumber="123456"
        
        obj.validating = validating
        obj.deviceSessionId = AppStorage.sessionId
        obj.incidentDateTime = DateTime.now().toString()
        let head=headers;
        let res = super.post(surl, jsonObject: obj.toJsonObject(), headers: head) as AjaxPromise<OperationModel>
        res.always.addHandler({p in
            callBack(p.data,p.error)
        })
    }
    
    func authenticateAsync(callBack: @escaping (AuthenticationModel?, NSError?) -> Void){
        let surl = Constants.Server.authenticateUrl
        let obj = AuthenticationModel()
        obj.firstName = AppStorage.firstName
        obj.lastName = AppStorage.lastName
        obj.badge = AppStorage.badge
        obj.phoneNumber = AppStorage.phoneNumber
        obj.confirm2FACode = ""
    
        obj.deviceSessionId = AppStorage.sessionId
        obj.incidentDateTime = DateTime.now().toString()
        let head=headers;
        let res = super.post(surl, jsonObject: obj.toJsonObject(), headers: head) as AjaxPromise<AuthenticationModel>
        res.always.addHandler({p in
            callBack(p.data,p.error)
        })
    }
    
    
    func getTripPattern(_ route: String, tripId: Int, callBack: @escaping ([Timepoint], NSError?) -> Void) {
        let surl = getTripPatternURL(route, tripId: tripId)
        let res = super.get(surl, headers: headers) as AjaxPromise<[Timepoint]>
        res.always.addHandler({p in
            if (p.data==nil){
                callBack([],p.error)
            }
            else{
                callBack(p.data, p.error)
            }
        })
        
    }
    
    
    func getRoutes(_ callBack: @escaping ([RouteModel], NSError?) -> Void) {
        let surl = getRoutesURL()
        let res = super.get(surl, headers: nil) as AjaxPromise<[RouteModel]>
        res.always.addHandler({p in
            if (p.data==nil){
                callBack([],p.error)
            }
            else{
                callBack(p.data, p.error)
            }
        })
    }
    func getVersion(_ callBack: @escaping ([VersionModel], NSError?) -> Void) {
        let surl = Constants.Server.versionUrl
        let res = super.get(surl, headers: headers) as AjaxPromise<[VersionModel]>
        res.always.addHandler({p in
            if (p.data==nil){
                callBack([],p.error)
            }
            else{
                callBack(p.data, p.error)
            }
        })
    }
    
    func getFeedbacks(_ restroomId: Int, callBack: @escaping ([FeedbackModel], NSError?) -> Void) {
        let surl = getFeedbacksURL(restroomId)
        let res = super.get(surl, headers: headers) as AjaxPromise<[FeedbackModel]>
        res.always.addHandler({p in
            if (p.data==nil){
               callBack([],p.error)
           }
           else {
               callBack(p.data,p.error)
           }
        
        })
    }

    func saveFeedback(_ feedback: FeedbackModel, callBack: @escaping (FeedbackModel?, NSError?) -> Void) {
        let surl = getFeedbacksURL(nil)
        let res = post(surl, jsonObject: feedback.toJsonObject(), headers: headers) as AjaxPromise<FeedbackModel>
        res.always.addHandler({p in
            callBack(p.data,p.error)
        })
    }
    func saveRestroom(_ restroom: RestStopModel, isPublic:Bool, callBack: @escaping (RestStopModel?, NSError?) -> Void) {
        let surl = getRestroomURL(nil, isPublic: isPublic)
        let res = post(surl, jsonObject: restroom.toJsonObject(), headers: headers) as AjaxPromise<RestStopModel>
        res.always.addHandler({p in
            callBack(p.data,p.error)
        })
    }
    func getTripPatternURL(_ route:String, tripId:Int) -> String{
        let tripPatternURL = "\(Constants.Server.transitApiUrl)/route/\(route)/trip/\(tripId)/pattern?token=\(Constants.Server.transitApiToken)"
        print(tripPatternURL)
        return tripPatternURL
    }
    
    //NOTE: Made distance nullable
    func getRestroomURL(_ route:String, lat:String, long:String, distance:Int?,isPublic: Bool, isPending: Bool)-> String{
        let baseUrl = isPublic ? Constants.Server.restroomUrl : (isPending ? Constants.Server.actNewPendingRestroomUrl : Constants.Server.actRestroomUrl)
        let returnUrl = "\(baseUrl)?routeAlpha=\(route)&direction=&lat=\(lat)&longt=\(long)"

        if(distance != nil) {
            return "\(returnUrl)&distance=\(String(describing: distance!))";
        } else {
            return returnUrl;
        }
    }
    func getRestroomURL(_ restStopId: Int?, isPublic: Bool)-> String{
        if (restStopId != nil){
            //return  "\(isPublic ? Constants.Server.restroomUrl : Constants.Server.actRestroomUrl)/\(restStopId!)"
            return  "\(isPublic ? Constants.Server.restroombyIdUrl : Constants.Server.restroombyIdUrl)/?id=\(restStopId!)"
        }
        return "\(isPublic ? Constants.Server.saveRestroomUrl : Constants.Server.saveActRestroomUrl)/"
    }
    func getOperationURL(_ badge:String)-> String{
        return "\(Constants.Server.operationUrl)?badgeNumber=\(badge)"
    }
    
    func getRoutesURL() -> String{
        return "\(Constants.Server.transitApiUrl)/routes/?token=\(Constants.Server.transitApiToken)"
    }
    func getFeedbacksURL(_ restroomId : Int?) -> String{
        if (restroomId != nil){
            return "\(Constants.Server.feedbackUrl)/get?restroomId=\(restroomId!)"
        }
        return "\(Constants.Server.feedbackUrl)/post"
    }
  
    var  headers : [String:String]{
        get{
            return ["sessionId":AppStorage.sessionId,
                    "deviceGuid" : Common.currentDevice.identifierForVendor!.uuidString,
                    "firstName": AppStorage.firstName,
                    "lastName": AppStorage.lastName,
                    "badge": AppStorage.badge]
        }
    }
    
}



