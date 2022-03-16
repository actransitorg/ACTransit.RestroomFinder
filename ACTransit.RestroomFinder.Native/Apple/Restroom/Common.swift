//
//  Common.swift
//  Restroom
//
//  Created by DevTeam on 2/11/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import UIKit
import MapKit

class Common{
    //static var navigationController : UINavigationController?
    static var currentLocation: CLLocation?
    static var currentDevice : UIDevice {
        get{
            return UIDevice.current
        }
    }

    

    static func NavigateTo(_ viewIdentifier: String) -> UIViewController{
        
        let navigationController=UIApplication.shared.keyWindow!.rootViewController as! UINavigationController;
        let storyboard = navigationController.storyboard
        let controller : UIViewController = storyboard!.instantiateViewController(withIdentifier: viewIdentifier)
        navigationController.pushViewController(controller, animated: true)
        
        return controller
    }
    
    static func NavigateToModal(_ viewIdentifier: String, modalCompletion: ((UIViewController) -> Void)?) -> UIViewController{
        
        let navigationController=UIApplication.shared.keyWindow!.rootViewController as! UINavigationController;
        let storyboard = navigationController.storyboard
        let controller : UIViewController = storyboard!.instantiateViewController(withIdentifier: viewIdentifier)
        navigationController.present(controller, animated: true){
            if (modalCompletion != nil){
                modalCompletion!(controller)
            }
        }
        
        return controller
    }
    static var _canAddRestroom : Bool = false
    static func canAddRestroom(value : Bool? = nil)->Bool{
        if (value != nil){
            _canAddRestroom = value!
        }
        return _canAddRestroom;
    }
    
    static var _canEditRestroom : Bool = false
    static func canEditRestroom(value : Bool? = nil)->Bool{
        if (value != nil){
            _canEditRestroom = value!
        }
        return _canEditRestroom;
    }
    
}
