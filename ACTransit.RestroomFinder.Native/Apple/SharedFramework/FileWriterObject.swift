//
//  FileWriterObject.swift
//  SharedFramework
//
//  Created by DevTeam on 6/18/18.
//  Copyright © 2018 DevTeam. All rights reserved.
//

import UIKit

public struct FileWriterObject {
    public init(value:String, updateDate: DateTime?, sessionId:String?) {
        // Initialize stored properties.
        self.value = value
        self.updateDate = updateDate
        self.sessionId = sessionId
    }
    
    
    public var value: String = ""
    public var updateDate: DateTime?
    public var sessionId: String? = ""
}
