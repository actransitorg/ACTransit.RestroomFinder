import Foundation
import UIKit

public class GradientColor {
    private var _colorLocations: [ColorLocation]
    private let defaultColorTop = UIColor(red: 192.0/255.0, green: 38.0/255.0, blue: 42.0/255.0, alpha: 1.0).CGColor
    private let defaultColorBottom = UIColor(red: 35.0/255.0, green: 2.0/255.0, blue: 2.0/255.0, alpha: 1.0).CGColor
    public let gl: CAGradientLayer =  CAGradientLayer()
    public init() {
        _colorLocations = [ColorLocation]()
        _colorLocations.append(ColorLocation(color: defaultColorTop, location: 0.0))
        _colorLocations.append(ColorLocation(color: defaultColorBottom, location: 1.0))
        initial()
    }
    
    public init(colorLocations: [ColorLocation]) {
        _colorLocations = colorLocations
        initial()
    }
    
    private func initial(){
        let (colors, locations) = seperate()
        gl.colors = colors
        gl.locations = locations
    }
    
    public func seperate()-> (colors: [CGColor], locations:[NSNumber]){
        var colors = [CGColor]()
        var locations = [NSNumber]()
        for i in 0 ..< colorLocations.count {
            colors.append(colorLocations[i].color)
            locations.append(colorLocations[i].location)
        }
        return (colors, locations)
    }
    
    public var colorLocations: [ColorLocation]{
        get{
            return _colorLocations
        }
        set(value){
            _colorLocations = value
        }
    }
    
    public static var style1: [ColorLocation]{
        get{
            var colorLocations : [GradientColor.ColorLocation] = []
            colorLocations.append(GradientColor.ColorLocation(color: UIColor.whiteColor().CGColor, location: 0))
            colorLocations.append(GradientColor.ColorLocation(color: UIColor(red: 48.0/255.0, green: 140.0/255.0, blue: 190.0/255.0, alpha: 1.0).CGColor, location: 0.5))
            colorLocations.append(GradientColor.ColorLocation(color: UIColor.whiteColor().CGColor, location: 1.0))
            return colorLocations
        }
    }
    
    public static var style2: [ColorLocation]{
        get{
            var colorLocations : [GradientColor.ColorLocation] = []
            colorLocations.append(GradientColor.ColorLocation(color: UIColor(red: 55.0/255.0, green: 26.0/255.0, blue: 93.0/255.0, alpha: 1.0).CGColor, location: 0))
            colorLocations.append(GradientColor.ColorLocation(color: UIColor(red: 176.0/255.0, green: 7.0/255.0, blue: 142.0/255.0, alpha: 1.0).CGColor, location: 0.5))
            colorLocations.append(GradientColor.ColorLocation(color: UIColor(red: 55.0/255.0, green: 26.0/255.0, blue: 93.0/255.0, alpha: 1.0).CGColor, location: 1.0))
            return colorLocations
        }
    }
    
    public class ColorLocation{
        var color: CGColor
        var location: NSNumber
        init (color: CGColor, location: NSNumber){
            self.color = color
            self.location = location
        }
    }
}