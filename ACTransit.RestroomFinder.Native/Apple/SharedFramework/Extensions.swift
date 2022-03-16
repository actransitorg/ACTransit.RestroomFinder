//
//  Extensions.swift
//  SharedFramework
//
//  Created by DevTeam on 9/13/18.
//  Copyright © 2018 DevTeam. All rights reserved.
//

import Foundation

public extension String{
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
    func toNullableBool(_ defaultValue: Bool?) -> Bool? {
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
