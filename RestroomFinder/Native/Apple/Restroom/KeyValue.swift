//
//  KeyValue.swift
//  Restroom
//
//  Created by DevTeam on 1/27/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
import SharedFramework

class KeyValue: KeyValueFileWriter {
    
    static let pathComponent = "Restroom_keyvalue";
    
    static func Save(keyvalues: [KeyValue]) -> Bool {
        return KeyValueFileWriter.Save(keyvalues, pathComponent: pathComponent)
    }
    
    static func Load() -> [KeyValue]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(KeyValueFileWriter.GetPath(pathComponent)) as? [KeyValue]
    }
}

