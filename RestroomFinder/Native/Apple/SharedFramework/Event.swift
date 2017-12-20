//
//  Event.swift
//  SharedFramework
//
//  Created by DevTeam on 5/3/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation

open class Event<T> {
    
    public init(){}
    
    public typealias EventHandler = (T) -> ()
    
    fileprivate var eventHandlers = [EventHandler]()
    
    open func addHandler(_ handler: @escaping EventHandler) {
        eventHandlers.append(handler)
    }
    
    open func raise(_ data: T) {
        for handler in eventHandlers {
            handler(data)
        }
    }
}

