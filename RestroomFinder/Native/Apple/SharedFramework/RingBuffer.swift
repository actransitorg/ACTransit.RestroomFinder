//
//  RingBuffer.swift
//  SharedFramework
//
//  Created by DevTeam on 5/5/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation

// A fixed sized array that discards old values as new values are added.
open class RingBuffer {
    var values: [Double]
    var index: Int      // points to the newest value
    var rollOvered: Bool = false
    fileprivate var repeatedValue: Double
    public init(count: Int, repeatedValue: Double) {
        self.repeatedValue = repeatedValue
        values = Array<Double>(repeating: repeatedValue, count: count)
        index = 0
    }
    
    open var count: Int {
        return values.count
    }
    
    
    open var average: Double {
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
    
    open func clear(){
        values = Array<Double>(repeating: repeatedValue, count: count)
        index = 0
        rollOvered = false
    }
    
    open func add(_ newValue: Double) {
        index = (index + 1) % values.count
        values[index] = newValue
        if (index == 0){
            rollOvered = true
        }
    }
    
    open var oldest: Double {
        return values[(index + 1) % values.count]
    }
    
    open var newest: Double {
        return values[index]
    }
    
    // This makes no guarantees about the order the values are iterated.
    open func reduce(_ initial: Double, combine: (_ accumulator: Double, _ newValue: Double) -> Double) -> Double {
        return values.reduce(initial, combine)
    }
}
