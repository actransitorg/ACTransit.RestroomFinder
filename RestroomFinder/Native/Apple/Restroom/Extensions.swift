//
//  Extensions.swift
//  Restroom
//
//  Created by DevTeam on 12/21/15.
//  Copyright © 2015 DevTeam. All rights reserved.
//

import Foundation
extension String{
    func toBool(_ defaultValue: Bool) -> Bool {
        let value=self.lowercased()
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
extension Array where Iterator.Element == KeyValue {
    func containsKey(_ key: String) -> Bool{
        return self.filter({KeyValue in return KeyValue.key==key }).first != nil
    }
    func tryGetValue(_ key: String) -> KeyValue?{
        return self.filter({KeyValue in return KeyValue.key==key }).first
    }
}
