//
//  Extensions.swift
//  Restroom
//
//  Created by DevTeam on 12/21/15.
//  Copyright © 2015 DevTeam. All rights reserved.
//

import Foundation
extension String{
    func toBool(defaultValue: Bool) -> Bool {
        let value=self.lowercaseString
        switch value {
        case "true","1","y" :
            return true
        case "false","0","n" :
            return false
        default:
            return defaultValue
        }
    }
}
extension _ArrayType where Generator.Element == KeyValue {
    func containsKey(key: String) -> Bool{
        return self.filter({KeyValue in return KeyValue.key==key }).first != nil
    }
    func tryGetValue(key: String) -> KeyValue?{
        return self.filter({KeyValue in return KeyValue.key==key }).first
    }
}