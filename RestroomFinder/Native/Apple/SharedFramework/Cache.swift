//
//  Cache.swift
//  SharedFramework
//
//  Created by DevTeam on 5/5/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
open class Cache{
    static var _cache = [String: NSObject]()
    
    open static func add(_ key: String, value: NSObject){
        _cache[key] = value
    }
    open static func item(_ key: String)-> NSObject! {
        return _cache[key]
    }
    
    open static func contains(_ key: String) -> Bool {
        return _cache[key] != nil
    }
}
