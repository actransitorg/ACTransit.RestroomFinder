//
//  Threading.swift
//  Restroom
//
//  Created by DevTeam on 2/5/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation

class Threading{
    static func sync(_ lock: AnyObject, closure: () -> Void) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    static func runInMainThread(_ closure: @escaping () -> Void){
        DispatchQueue.main.async(execute: {
            closure()
        })
    }
}
