import Foundation
import UIKit

open class GradientColor {
    fileprivate var _colorLocations: [ColorLocation]
    fileprivate let defaultColorTop = UIColor(red: 192.0/255.0, green: 38.0/255.0, blue: 42.0/255.0, alpha: 1.0).cgColor
    fileprivate let defaultColorBottom = UIColor(red: 35.0/255.0, green: 2.0/255.0, blue: 2.0/255.0, alpha: 1.0).cgColor
    open let gl: CAGradientLayer =  CAGradientLayer()
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
    
    fileprivate func initial(){
        let (colors, locations) = seperate()
        gl.colors = colors
        gl.locations = locations
    }
    
    open func seperate()-> (colors: [CGColor], locations:[NSNumber]){
        var colors = [CGColor]()
        var locations = [NSNumber]()
        for i in 0 ..< colorLocations.count {
            colors.append(colorLocations[i].color)
            locations.append(colorLocations[i].location)
        }
        return (colors, locations)
    }
    
    open var colorLocations: [ColorLocation]{
        get{
            return _colorLocations
        }
        set(value){
            _colorLocations = value
        }
    }
    
    open static var style1: [ColorLocation]{
        get{
            var colorLocations : [GradientColor.ColorLocation] = []
            colorLocations.append(GradientColor.ColorLocation(color: UIColor.white.cgColor, location: 0))
            colorLocations.append(GradientColor.ColorLocation(color: UIColor(red: 48.0/255.0, green: 140.0/255.0, blue: 190.0/255.0, alpha: 1.0).cgColor, location: 0.5))
            colorLocations.append(GradientColor.ColorLocation(color: UIColor.white.cgColor, location: 1.0))
            return colorLocations
        }
    }
    
    open static var style2: [ColorLocation]{
        get{
            var colorLocations : [GradientColor.ColorLocation] = []
            colorLocations.append(GradientColor.ColorLocation(color: UIColor(red: 55.0/255.0, green: 26.0/255.0, blue: 93.0/255.0, alpha: 1.0).cgColor, location: 0))
            colorLocations.append(GradientColor.ColorLocation(color: UIColor(red: 176.0/255.0, green: 7.0/255.0, blue: 142.0/255.0, alpha: 1.0).cgColor, location: 0.5))
            colorLocations.append(GradientColor.ColorLocation(color: UIColor(red: 55.0/255.0, green: 26.0/255.0, blue: 93.0/255.0, alpha: 1.0).cgColor, location: 1.0))
            return colorLocations
        }
    }
    open static var style3: [ColorLocation]{
        get{
            var colorLocations : [GradientColor.ColorLocation] = []
            colorLocations.append(GradientColor.ColorLocation(color: UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor, location: 0))
            colorLocations.append(GradientColor.ColorLocation(color: UIColor(red: 242.0/255.0, green: 253.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor, location: 0.5))
            colorLocations.append(GradientColor.ColorLocation(color: UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor, location: 1.0))
            return colorLocations
        }
    }
    
    open static var style4: [ColorLocation]{
        get{
            var colorLocations : [GradientColor.ColorLocation] = []
            colorLocations.append(GradientColor.ColorLocation(color: UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1.0).cgColor, location: 0))
            colorLocations.append(GradientColor.ColorLocation(color: UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor, location: 0.5))
            colorLocations.append(GradientColor.ColorLocation(color: UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1.0).cgColor, location: 1.0))
            return colorLocations
        }
    }
    
    open static var style5: [ColorLocation]{
        get{
            var colorLocations : [GradientColor.ColorLocation] = []
            colorLocations.append(GradientColor.ColorLocation(color: UIColor(red: 92/255.0, green: 92.0/255.0, blue: 92.0/255.0, alpha: 1.0).cgColor, location: 0))
            colorLocations.append(GradientColor.ColorLocation(color: UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor, location: 0.5))
            colorLocations.append(GradientColor.ColorLocation(color: UIColor(red: 92/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1.0).cgColor, location: 1.0))
            return colorLocations
        }
    }
    open class ColorLocation{
        var color: CGColor
        var location: NSNumber
        init (color: CGColor, location: NSNumber){
            self.color = color
            self.location = location
        }
    }
}
