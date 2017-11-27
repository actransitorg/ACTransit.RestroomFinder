//
//  Cache.swift
//  SharedFramework
//
//  Created by DevTeam on 5/5/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
public class Cache{
    static var _cache = [String: NSObject]()
    
    public static func add(key: String, value: NSObject){
        _cache[key] = value
    }
    public static func item(key: String)-> NSObject! {
        return _cache[key]
    }
    
    public static func contains(key: String) -> Bool {
        return _cache[key] != nil
    }
}