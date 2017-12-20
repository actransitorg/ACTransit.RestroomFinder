//
//  ServerBaseAPI.swift
//  SharedFramework
//
//  Created by DevTeam on 5/4/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//
import Foundation

open class ServerBaseAPI: NSObject{
        
    var syncGroup: DispatchGroup
    required public init(syncGroup: DispatchGroup){
        self.syncGroup = syncGroup
    }
    
    open func get<T : BaseModel>(_ url: String) -> AjaxPromise<[T]>{
        let res = AjaxPromise<[T]>()
        let request = createRequest(url, httpMethod: "GET") as URLRequest
        let session = URLSession.shared
        
        self.syncGroup.enter()
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            defer{
                self.syncGroup.leave()
            }
            var err = error
            var values = [T]()
            defer{
                res.always.raise(AjaxResult<[T]>(data: values, err: err as NSError!))
            }
            do{
                if (err != nil){
                    if (res.fail == nil){
                        res.fail = Event<NSError>()
                    }
                    res.fail?.raise(error! as NSError)
                }
                else{
                    if (data != nil)
                    {
                        let d = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                        let dm = Mirror(reflecting: d)
                        print ("Get-> d:\(dm.subjectType), \(d)")
                        if let jsonResult = d as? NSMutableArray {
                            for obj in jsonResult
                            {
                                let dic=obj as! [String:AnyObject]
                                values.append(T(obj: dic ))
                            }
                        }
                        else if let jsonResult = d as? NSDictionary {
                            values.append(T(obj: jsonResult as! [String : AnyObject]))
                        }
                        else if let jsonResult = d as? NSArray {
                            for obj in jsonResult
                            {
                                let dic=obj as! [String:AnyObject]
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
                res.fail?.raise(err! as NSError)
            }
            
        })
        task.resume()
        return res;
    }

    open func post<T : BaseModel>(_ url: String, jsonObject: AnyObject) -> AjaxPromise<T>{
        let res = AjaxPromise<T>()
        var request = createRequest(url, httpMethod: "POST") as URLRequest
        let session = URLSession.shared
        let jsonStr = ServerBaseAPI.JSONStringify(jsonObject)
        request.httpBody =  jsonStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        
        self.syncGroup.enter()
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            var value : T!
            var err = self.getError(error as NSError!, response: response)
            
            defer{
                self.syncGroup.leave()
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
                        let d = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                        if let jsonResult = d as? [String:AnyObject] {
                            let dic = jsonResult as NSDictionary
                            value = T(obj: dic as! [String : AnyObject])
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
    
    
    fileprivate func createRequest(_ url: String, httpMethod: String) -> NSMutableURLRequest{
        let request = NSMutableURLRequest(url: URL(string:url)!)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    open static func JSONStringify(_ value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        
        
        if JSONSerialization.isValidJSONObject(value) {
            
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                
                print("error")
                //Access error here
            }
            
        }
        return ""
    }
    
    fileprivate func getError(_ error:NSError!, response: URLResponse!)->NSError! {
        var err = error
        let httpResponse = response as? HTTPURLResponse
        //print (httpResponse?.statusCode)
        if (err == nil && httpResponse != nil && httpResponse?.statusCode != 200){
            err = NSError(domain: "Http error", code: (httpResponse?.statusCode)!, userInfo: nil)
        }
        return err
    }
    
}

open class AjaxPromise<T>{
    open var done: Event<T> = Event<T>()
    open var fail: Event<NSError>?
    open var always: Event<AjaxResult<T>> = Event<AjaxResult<T>>()
}

open class AjaxResult<T>{
    public init(data: T!, err: NSError!){
        self.data = data
        self.error = err
    }
    open var data: T!
    open var error: NSError!
}
