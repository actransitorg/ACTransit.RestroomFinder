//
//  AppStore.swift
//  SharedFramework
//
//  Created by DevTeam on 9/13/18.
//  Copyright © 2018 DevTeam. All rights reserved.
//

import UIKit

open class AppStore: NSObject {
    static var _syncGroup: DispatchGroup? = nil
    static var syncGroup: DispatchGroup {
        get{
            if (_syncGroup == nil){
                _syncGroup = DispatchGroup()
            }
            return _syncGroup!;
        }
    }
    open static func getVersion(id:String,_ callBack: @escaping ([AppStoreAppInfo], NSError?) -> Void){
        let urlStr : String = "http://itunes.apple.com/lookup?id=" + id
        //let url : NSURL = NSURL(fileURLWithPath: urlStr)
        let server : ServerBaseAPI = ServerBaseAPI(syncGroup: syncGroup);
        let res = server.get(urlStr, headers: nil) as AjaxPromise<[AppStoreAppLookup]>
        res.always.addHandler({p in
            var data: [AppStoreAppInfo]
            data=p.data[0].results
           
            callBack(data,p.error)
        })
       

    }
    
    
}
