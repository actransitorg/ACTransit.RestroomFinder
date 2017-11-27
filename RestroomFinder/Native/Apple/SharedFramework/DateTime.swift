//
//  DateTime.swift
//  SharedFramework
//
//  Created by DevTeam on 5/4/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation

public class DateTime{
    public static let DateTimeFormat : String="MM/dd/yyyy HH:mm:ss"
    private var _dateTime: NSDate
    public init(){
        _dateTime = NSDate()
    }
    public init(datetime: NSDate){
        _dateTime = datetime
    }
    
    public static func now() -> DateTime{
        return DateTime()
    }
    
    public static func parse(dateStr: String, dateTimeFormat: String=DateTimeFormat) -> DateTime? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = dateTimeFormat
        let d = dateFormatter.dateFromString(dateStr)
        if (d != nil){
            return DateTime(datetime: d!)
        }
        return nil
    }
    
    public func subtract(fromDate: DateTime, calendarUnit: NSCalendarUnit=[.Hour]) -> NSDateComponents{
        let calendar = NSCalendar.currentCalendar()
        let stPatricksValentinesDayDifference = calendar.components(
            calendarUnit,
            fromDate: dateTime,
            toDate: fromDate.dateTime,
            options: [])
        // The result should be 31
        return stPatricksValentinesDayDifference
    }
    
    public var year: Int{
        get{
            let components = calendar.components([.Year], fromDate: dateTime)
            return components.year
        }
    }
    public var month: Int{
        get{
            let components = calendar.components([.Month], fromDate: dateTime)
            return components.month
        }
    }
    public var day: Int{
        get{
            let components = calendar.components([.Day], fromDate: dateTime)
            return components.day
        }
    }
    public var hour: Int{
        get{
            let components = calendar.components([.Hour], fromDate: dateTime)
            return components.hour
        }
    }
    public var minute: Int{
        get{
            let components = calendar.components([.Minute], fromDate: dateTime)
            return components.minute
        }
    }
    public var second: Int{
        get{
            let components = calendar.components([.Second], fromDate: dateTime)
            return components.second
        }
    }
    public var nanosecond: Int{
        get{
            let components = calendar.components([.Nanosecond], fromDate: dateTime)
            return components.nanosecond
        }
    }
    
    
    public func toString(style: NSDateFormatterStyle)-> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateStyle = style
        return dateFormatter.stringFromDate(self._dateTime)
    }
    public func toString(dateTimeFormat: String="MM/dd/yyyy HH:mm:ss")-> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = dateTimeFormat
        return dateFormatter.stringFromDate(self._dateTime)
    }
    
    public var dateTime: NSDate{
        get{
            return _dateTime
        }
    }
    
    var _calendar: NSCalendar?
    public var calendar: NSCalendar{
        get{
            if (_calendar == nil){
                _calendar = NSCalendar.currentCalendar()
            }
            return _calendar!
        }
    }
}