//
//  ServerBaseAPI.swift
//  SharedFramework
//
//  Created by DevTeam on 5/4/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//
import Foundation

public class ServerBaseAPI: NSObject{
        
    var syncGroup: dispatch_group_t
    required public init(syncGroup: dispatch_group_t){
        self.syncGroup = syncGroup
    }
    
    public func get<T : BaseModel>(url: String) -> AjaxPromise<[T]>{
        let res = AjaxPromise<[T]>()
        let request = createRequest(url, httpMethod: "GET")
        let session = NSURLSession.sharedSession()
        
        dispatch_group_enter(self.syncGroup)
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            defer{
                dispatch_group_leave(self.syncGroup)
            }
            var err = error
            var values = [T]()
            defer{
                res.always.raise(AjaxResult<[T]>(data: values, err: err))
            }
            do{
                if (err != nil){
                    if (res.fail == nil){
                        res.fail = Event<NSError>()
                    }
                    res.fail?.raise(error!)
                }
                else{
                    if (data != nil)
                    {
                        let d = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves)
                        let dm = Mirror(reflecting: d)
                        print ("Get-> d:\(dm.subjectType), \(d)")
                        if let jsonResult = d as? NSMutableArray {
                            for obj in jsonResult
                            {
                                let dic=obj as! NSDictionary
                                values.append(T(obj: dic))
                            }
                        }
                        else if let jsonResult = d as? NSDictionary {
                            values.append(T(obj: jsonResult))
                        }
                        else if let jsonResult = d as? NSArray {
                            for obj in jsonResult
                            {
                                let dic=obj as! NSDictionary
                                values.append(T(obj: dic))
                            }
                        }
                    }
                    res.done.raise(values)
                }
            }
            catch  let error1 as NSError  {
                print ("Get-> code:\(error1.code), \(error1.description)")
                err = NSError(domain: "Something went wrong", code: 0, userInfo: nil)
                if (res.fail == nil){
                    res.fail = Event<NSError>()
                }
                res.fail?.raise(err!)
            }
            
        })
        task.resume()
        return res;
    }

    public func post<T : BaseModel>(url: String, jsonObject: AnyObject) -> AjaxPromise<T>{
        let res = AjaxPromise<T>()
        let request = createRequest(url, httpMethod: "POST")
        let session = NSURLSession.sharedSession()
        let jsonStr = ServerBaseAPI.JSONStringify(jsonObject)
        request.HTTPBody = jsonStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        dispatch_group_enter(self.syncGroup)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var value : T!
            var err = self.getError(error, response: response)
            
            defer{
                dispatch_group_leave(self.syncGroup)
                res.always.raise(AjaxResult<T>(data: value, err: err))
            }
            
            do {
                if (err != nil){
                    if (res.fail == nil){
                        res.fail = Event<NSError>()
                    }
                    res.fail?.raise(err!)
                }
                else{
                    if (data != nil){
                        let d = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves)
                        if let jsonResult = d as? NSObject {
                            let dic = jsonResult as! NSDictionary
                            value = T(obj: dic)
                        }
                    }
                    res.done.raise(value)
                }
            }
            catch let error1 as NSError{
                print ("Post-> code:\(error1.code), \(error1.description)")
                err = NSError(domain: "Something went wrong", code: 0, userInfo: nil)
                if (res.fail == nil){
                    res.fail = Event<NSError>()
                }
                //value = nil//T(obj : [:])
                res.fail?.raise(err!)
            }
        })
        task.resume()
        return res;
    }
    
    
    private func createRequest(url: String, httpMethod: String) -> NSMutableURLRequest{
        let request = NSMutableURLRequest(URL: NSURL(string:url)!)
        request.HTTPMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    public static func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
        
        
        if NSJSONSerialization.isValidJSONObject(value) {
            
            do{
                let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            }catch {
                
                print("error")
                //Access error here
            }
            
        }
        return ""
    }
    
    private func getError(error: NSError!, response: NSURLResponse!)->NSError! {
        var err = error
        let httpResponse = response as? NSHTTPURLResponse
        print (httpResponse?.statusCode)
        if (err == nil && httpResponse != nil && httpResponse?.statusCode != 200){
            err = NSError(domain: "Http error", code: (httpResponse?.statusCode)!, userInfo: nil)
        }
        return err
    }
    
}

public class AjaxPromise<T>{
    public var done: Event<T> = Event<T>()
    public var fail: Event<NSError>?
    public var always: Event<AjaxResult<T>> = Event<AjaxResult<T>>()
}

public class AjaxResult<T>{
    public init(data: T!, err: NSError!){
        self.data = data
        self.error = err
    }
    public var data: T!
    public var error: NSError!
}
