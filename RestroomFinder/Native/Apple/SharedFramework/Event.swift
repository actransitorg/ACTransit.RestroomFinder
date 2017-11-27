//
//  Event.swift
//  SharedFramework
//
//  Created by DevTeam on 5/3/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation

public class Event<T> {
    
    public init(){}
    
    public typealias EventHandler = T -> ()
    
    private var eventHandlers = [EventHandler]()
    
    public func addHandler(handler: EventHandler) {
        eventHandlers.append(handler)
    }
    
    public func raise(data: T) {
        for handler in eventHandlers {
            handler(data)
        }
    }
}

