//
//  KeyValueFileWriter.swift
//  SharedFramework
//
//  Created by DevTeam on 5/4/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
public class KeyValueFileWriter: NSObject, NSCoding {
    
    public var key:String=""
    public var value:String=""
    public var updateDate : DateTime?
    
    
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
        let key = aDecoder.decodeObjectForKey(Keys.key) as! String
        let value = aDecoder.decodeObjectForKey(Keys.value) as! String
        let updateDateStr = aDecoder.decodeObjectForKey(Keys.updateDate) as! String
        self.init(key: key, value:value, updateDate: DateTime.parse(updateDateStr))
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(key, forKey: Keys.key)
        aCoder.encodeObject(value, forKey: Keys.value)
        aCoder.encodeObject(updateDate?.toString(), forKey: Keys.updateDate)
    }

    
    
    private static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    
    
    
    public static func Save(keyvalues: [KeyValueFileWriter],pathComponent: String) -> Bool {
        return NSKeyedArchiver.archiveRootObject(keyvalues, toFile: KeyValueFileWriter.GetPath(pathComponent))
    }
    
    public static func Load(pathComponent: String) -> [KeyValueFileWriter]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(KeyValueFileWriter.GetPath(pathComponent)) as? [KeyValueFileWriter]
    }
    
    public static func GetPath(pathComponent: String) -> String{
        let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent(pathComponent)
        return ArchiveURL!.path!
    }
    
    
    struct Keys {
        static let key = "key"
        static let value = "value"
        static let updateDate = "UpdateDate"
    }
    
}
