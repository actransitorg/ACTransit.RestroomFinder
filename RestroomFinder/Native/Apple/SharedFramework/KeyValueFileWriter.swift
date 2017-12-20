//
//  KeyValueFileWriter.swift
//  SharedFramework
//
//  Created by DevTeam on 5/4/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
open class KeyValueFileWriter: NSObject, NSCoding {
    
    open var key:String=""
    open var value:String=""
    open var updateDate : DateTime?
    
    
    public init?(key: String, value: String, updateDate: DateTime?) {
        // Initialize stored properties.
        self.key = key
        self.value = value
        self.updateDate = updateDate
        super.init()
            // Initialization should fail if there is no name or if the rating is negative.
        if key.isEmpty {
            return nil
        }
    }
    
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let key = aDecoder.decodeObject(forKey: Keys.key) as! String
        let value = aDecoder.decodeObject(forKey: Keys.value) as! String
        let updateDateStr = aDecoder.decodeObject(forKey: Keys.updateDate) as! String
        self.init(key: key, value:value, updateDate: DateTime.parse(updateDateStr))
    }
    
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(key, forKey: Keys.key)
        aCoder.encode(value, forKey: Keys.value)
        aCoder.encode(updateDate?.toString(), forKey: Keys.updateDate)
    }

    
    
    fileprivate static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    
    
    open static func Save(_ keyvalues: [KeyValueFileWriter],pathComponent: String) -> Bool {
        return NSKeyedArchiver.archiveRootObject(keyvalues, toFile: KeyValueFileWriter.GetPath(pathComponent))
    }
    
    open static func Load(_ pathComponent: String) -> [KeyValueFileWriter]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: KeyValueFileWriter.GetPath(pathComponent)) as? [KeyValueFileWriter]
    }
    
    open static func GetPath(_ pathComponent: String) -> String{
        let ArchiveURL = DocumentsDirectory.appendingPathComponent(pathComponent)
        return ArchiveURL.path
    }
    
    
    struct Keys {
        static let key = "key"
        static let value = "value"
        static let updateDate = "UpdateDate"
    }
    
}
