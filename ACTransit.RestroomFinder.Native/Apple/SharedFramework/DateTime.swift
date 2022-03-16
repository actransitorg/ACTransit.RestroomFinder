//
//  DateTime.swift
//  SharedFramework
//
//  Created by DevTeam on 5/4/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation

open class DateTime{
    public static let DateTimeFormat : String="MM/dd/yyyy HH:mm:ss"
    fileprivate var _dateTime: Date
    public init(){
        _dateTime = Date()
    }
    public init(datetime: Date){
        _dateTime = datetime
    }
    
    public static func now() -> DateTime{
        return DateTime()
    }
    
    public static func min() -> DateTime {
        return DateTime(datetime: Date(timeIntervalSince1970: 0))
    }

    public static func parse(_ dateStr: String, dateTimeFormat: String=DateTimeFormat) -> DateTime? {
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
    
    open func add(_ value: Int, calendarUnit: NSCalendar.Unit=[.second]) -> DateTime{
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        switch calendarUnit {
        case NSCalendar.Unit.hour:
            dateComponent.hour = value
        case NSCalendar.Unit.minute:
            dateComponent.minute = value
        case NSCalendar.Unit.second:
            dateComponent.second = value
        case NSCalendar.Unit.day:
            dateComponent.day = value
        case NSCalendar.Unit.month:
            dateComponent.month = value
        case NSCalendar.Unit.year:
            dateComponent.year = value

        default:
            dateComponent.second = value
        }
        let res = calendar.date(byAdding: dateComponent, to: _dateTime)
        return DateTime(datetime: res!)
    }
    
    public static var isWeekday:Bool{
        get{
            let components = Calendar.current.dateComponents([.weekday], from: Date())
            return components.weekday! > 1 && components.weekday! < 7
        }
    }
    public static var isSaturday:Bool{
        get{
            let components = Calendar.current.dateComponents([.weekday], from: Date())
            return components.weekday! == 7
        }
    }
    
    public static var isSunday:Bool{
        get{
            let components = Calendar.current.dateComponents([.weekday], from: Date())
            return components.weekday! == 1
        }
    }
    
    open var year: Int{
        get{
            let components = Calendar.current.dateComponents([.year], from: dateTime)
            return components.year!
        }
    }
    open var month: Int{
        get{
            let components = Calendar.current.dateComponents([.month], from: dateTime)
            return components.month!
        }
    }
    open var day: Int{
        get{
            let components = Calendar.current.dateComponents([.day], from: dateTime)
            return components.day!
        }
    }
    open var hour: Int{
        get{
            let components = Calendar.current.dateComponents([.hour], from: dateTime)
            return components.hour!
        }
    }
    open var minute: Int{
        get{
            let components = Calendar.current.dateComponents([.minute], from: dateTime)
            return components.minute!
        }
    }
    open var second: Int{
        get{
            let components = Calendar.current.dateComponents([.second], from: dateTime)
            return components.second!
        }
    }
    open var nanosecond: Int{
        get{
            let components = Calendar.current.dateComponents([.nanosecond], from: dateTime)
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
