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
    
    open func get<T : BaseModel>(_ url: String, headers:[String:String]?) -> AjaxPromise<[T]>{
        let res = AjaxPromise<[T]>()
        let request = createRequest(url, httpMethod: "GET",headers: headers) as URLRequest
        let session = URLSession.shared
        
        print("get url:" + url)
        self.syncGroup.enter()
        let task = session.dataTask(with: request){data, response, error in
            defer{
                self.syncGroup.leave()
            }
            var err = error
            var values = [T]()
            defer{
                res.always.raise(AjaxResult<[T]>(data: values, err: err as NSError!))
            }
            do{
                let httpResponse = response as? HTTPURLResponse
                if (err != nil ){
                    if (res.fail == nil){
                        res.fail = Event<NSError>()
                    }
                    res.fail?.raise(error! as NSError)
                    res.always.raise(AjaxResult<[T]>(data: nil, err: error! as NSError))
                }
                else if (httpResponse != nil && httpResponse?.statusCode != 200){
                    if (res.fail == nil){
                        res.fail = Event<NSError>()
                    }
                    let networkerror = NSError(domain: "Network", code: httpResponse!.statusCode, userInfo: ["messge":"Network Error"])
                    res.fail?.raise(networkerror)
                    res.always.raise(AjaxResult<[T]>(data: nil, err: networkerror))
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
        }
        
       
        task.resume()
        return res;
    }

    open func post<T : BaseModel>(_ url: String, jsonObject: AnyObject,headers:[String:String]?) -> AjaxPromise<T>{
        let res = AjaxPromise<T>()
        var request = createRequest(url, httpMethod: "POST",headers: headers) as URLRequest
        let session = URLSession.shared
        let jsonStr = ServerBaseAPI.JSONStringify(jsonObject)
        request.httpBody =  jsonStr.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        
        self.syncGroup.enter()
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            var value : T!
            var err = self.getError(error as NSError!, response: response, data: data)
            //let count = data?.count / sizeof(UInt8)
           
    
            defer{
                self.syncGroup.leave()
                res.always.raise(AjaxResult<T>(data: value, err: err))
            }
            
            do {
                if (err != nil){
                    print ((err?.description)!)
                    
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
    
//    open func postResAsBool(_ url: String, jsonObject: AnyObject,headers:[String:String]?) -> AjaxPromise<Bool>{
//        let res = AjaxPromise<Bool>()
//        var request = createRequest(url, httpMethod: "POST",headers: headers) as URLRequest
//        let session = URLSession.shared
//        let jsonStr = ServerBaseAPI.JSONStringify(jsonObject)
//        request.httpBody =  jsonStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
//
//
//        self.syncGroup.enter()
//
//        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
//            var value = false
//            var err = self.getError(error as NSError!, response: response)
//
//            defer{
//                self.syncGroup.leave()
//                res.always.raise(AjaxResult<Bool>(data: value, err: err))
//            }
//
//            do {
//                if (err != nil){
//                    print ((err?.description)!)
//
//                    if (res.fail == nil){
//                        res.fail = Event<NSError>()
//                    }
//                    res.fail?.raise(err!)
//                }
//                else{
//                    if (data != nil)
//                    {
//
//                        let d = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
//                        let dm = Mirror(reflecting: d)
//                        print ("Get-> d:\(dm.subjectType), \(d)")
//                        if let jsonResult = d as? NSMutableArray {
//                            for obj in jsonResult
//                            {
//                                let dic=obj as! [String:AnyObject]
//                                //values.append(T(obj: dic ))
//                            }
//                        }
//                        else if let jsonResult = d as? NSDictionary {
//                            //values.append(T(obj: jsonResult as! [String : AnyObject]))
//                        }
//                        else if let jsonResult = d as? NSArray {
//                            for obj in jsonResult
//                            {
//                                let dic=obj as! [String:AnyObject]
//                                //values.append(T(obj: dic))
//                            }
//                        }
//                    }
//                    res.done.raise(value)
//                }
//            }
//            catch let error1 as NSError{
//                print ("Post-> code:\(error1.code), \(error1.description)")
//                err = NSError(domain: "Something went wrong", code: 0, userInfo: nil)
//                if (res.fail == nil){
//                    res.fail = Event<NSError>()
//                }
//                //value = nil//T(obj : [:])
//                res.fail?.raise(err!)
//            }
//        })
//        task.resume()
//        return res;
//    }
    
    fileprivate func createRequest(_ url: String, httpMethod: String, headers:[String:String]?) -> NSMutableURLRequest{
        let request = NSMutableURLRequest(url: URL(string:url)!)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if (headers != nil){
            headers!.forEach({ (key:String, value:String) in
                print (key + ":" + value)
                request.addValue(value, forHTTPHeaderField: key)
            })

        }
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
    
    fileprivate func getError(_ error:NSError!, response: URLResponse!, data : Data?)->NSError! {
        var err = error
        let httpResponse = response as? HTTPURLResponse
        //print (httpResponse?.statusCode)
        if (err == nil && httpResponse != nil && httpResponse?.statusCode != 200){
            var userInfo:String? = nil
            if (data != nil){
                userInfo = String(data: Data(data!), encoding: .utf8)
               //print (s)
            }
            err = NSError(domain: "Http error", code: (httpResponse?.statusCode)!, userInfo: ["message":userInfo])
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

open class PromiseHandler<T>{
    open var promises: Array<AjaxPromise<T>>
    var resolvedAlwaysPromises: Int = 0
    var resolvedDonePromises: Int = 0
    var resolvedErrorPromises: Int = 0
    
    var alwaysData : Array<AjaxResult<T>>

    public init(promises: Array<AjaxPromise<T>>){
        self.promises = promises
        alwaysData = []
    }
    
    public func wait(){
        for i in 0..<promises.count{
            promises[i].always.addHandler({p in
                self.resolvedAlwaysPromises += 1
                self.alwaysData.append(p)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Change `2.0` to the desired number of seconds.
                   if (self.resolvedAlwaysPromises==self.promises.count){
                       self.always.raise(self.alwaysData)
                   }
                }
            })
        }
    }

    open var always: Event<Array<AjaxResult<T>>> = Event<Array<AjaxResult<T>>>()
    

}
