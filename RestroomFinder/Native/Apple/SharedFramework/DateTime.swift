//
//  DateTime.swift
//  SharedFramework
//
//  Created by DevTeam on 5/4/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation

open class DateTime{
    open static let DateTimeFormat : String="MM/dd/yyyy HH:mm:ss"
    fileprivate var _dateTime: Date
    public init(){
        _dateTime = Date()
    }
    public init(datetime: Date){
        _dateTime = datetime
    }
    
    open static func now() -> DateTime{
        return DateTime()
    }
    
    open static func parse(_ dateStr: String, dateTimeFormat: String=DateTimeFormat) -> DateTime? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = dateTimeFormat
        let d = dateFormatter.date(from: dateStr)
        if (d != nil){
            return DateTime(datetime: d!)
        }
        return nil
    }
    
    open func subtract(_ fromDate: DateTime, calendarUnit: NSCalendar.Unit=[.hour]) -> DateComponents{
        let calendar = Calendar.current
        let stPatricksValentinesDayDifference = (calendar as NSCalendar).components(
            calendarUnit,
            from: dateTime,
            to: fromDate.dateTime,
            options: [])
        // The result should be 31
        return stPatricksValentinesDayDifference
    }
    
    open var year: Int{
        get{
            let components = (calendar as NSCalendar).components([.year], from: dateTime)
            return components.year!
        }
    }
    open var month: Int{
        get{
            let components = (calendar as NSCalendar).components([.month], from: dateTime)
            return components.month!
        }
    }
    open var day: Int{
        get{
            let components = (calendar as NSCalendar).components([.day], from: dateTime)
            return components.day!
        }
    }
    open var hour: Int{
        get{
            let components = (calendar as NSCalendar).components([.hour], from: dateTime)
            return components.hour!
        }
    }
    open var minute: Int{
        get{
            let components = (calendar as NSCalendar).components([.minute], from: dateTime)
            return components.minute!
        }
    }
    open var second: Int{
        get{
            let components = (calendar as NSCalendar).components([.second], from: dateTime)
            return components.second!
        }
    }
    open var nanosecond: Int{
        get{
            let components = (calendar as NSCalendar).components([.nanosecond], from: dateTime)
            return components.nanosecond!
        }
    }
    
    
    open func toString(_ style: DateFormatter.Style)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self._dateTime)
    }
    open func toString(_ dateTimeFormat: String="MM/dd/yyyy HH:mm:ss")-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = dateTimeFormat
        return dateFormatter.string(from: self._dateTime)
    }
    
    open var dateTime: Date{
        get{
            return _dateTime
        }
    }
    
    var _calendar: Calendar?
    open var calendar: Calendar{
        get{
            if (_calendar == nil){
                _calendar = Calendar.current
            }
            return _calendar!
        }
    }
}
