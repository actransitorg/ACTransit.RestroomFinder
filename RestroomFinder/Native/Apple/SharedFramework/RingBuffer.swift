//
//  RingBuffer.swift
//  SharedFramework
//
//  Created by DevTeam on 5/5/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation

// A fixed sized array that discards old values as new values are added.
public class RingBuffer {
    var values: [Double]
    var index: Int      // points to the newest value
    var rollOvered: Bool = false
    private var repeatedValue: Double
    public init(count: Int, repeatedValue: Double) {
        self.repeatedValue = repeatedValue
        values = Array<Double>(count: count, repeatedValue: repeatedValue)
        index = 0
    }
    
    public var count: Int {
        return values.count
    }
    
    
    public var average: Double {
        get{
            var a: Double = 0
            for i in 0 ..< values.count {
                a += values[i]
            }
            return (a/Double(count))
        }
    }
    
    // zero is newest value, incrementally moving back in time
    subscript(i: Int) -> Double {
        return values[(index - (i % values.count) + values.count) % values.count]
    }
    
    public func clear(){
        values = Array<Double>(count: count, repeatedValue: repeatedValue)
        index = 0
        rollOvered = false
    }
    
    public func add(newValue: Double) {
        index = (index + 1) % values.count
        values[index] = newValue
        if (index == 0){
            rollOvered = true
        }
    }
    
    public var oldest: Double {
        return values[(index + 1) % values.count]
    }
    
    public var newest: Double {
        return values[index]
    }
    
    // This makes no guarantees about the order the values are iterated.
    public func reduce(initial: Double, combine: (accumulator: Double, newValue: Double) -> Double) -> Double {
        return values.reduce(initial, combine: combine)
    }
}
