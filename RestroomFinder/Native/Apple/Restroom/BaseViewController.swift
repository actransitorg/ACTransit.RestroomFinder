//
//  BaseViewController.swift
//  Restroom
//
//  Created by DevTeam on 2/1/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
import UIKit
import SharedFramework

class BaseViewController: UIViewController{
    
    var backgroundImage : UIImage?
    
    var _syncGroup: dispatch_group_t? = nil
    var syncGroup: dispatch_group_t {
        get{
            if (_syncGroup == nil){
                _syncGroup = dispatch_group_create()
            }
            return _syncGroup!;
        }
    }
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseViewController._rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func _rotated(){
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)){
            viewDidRotated(true)
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            viewDidRotated(false)
        }
    }
    
    
    func viewDidRotated(landscape: Bool){}
    
    func setNavigationBar(hide: Bool, backgroundColor: UIColor?){
        hideNavigationBar(hide)
        if (backgroundColor != nil){
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(),forBarMetrics: UIBarMetrics.Default) //UIImageNamed:@"transparent.png"
            self.navigationController?.navigationBar.shadowImage = UIImage() ////UIImageNamed:@"transparent.png"
            self.navigationController?.navigationBar.translucent = true
            self.navigationController?.view.backgroundColor = backgroundColor
        }
    }
    
    func hideNavigationBar(hide:Bool){
        self.navigationController?.navigationBar.hidden = hide;
    }
    func hideBackButton(hide:Bool){
        self.navigationItem.setHidesBackButton(hide, animated: true)
    }
    
    func setNavigationButtons(hideBack: Bool, hideOK: Bool, hideCancel: Bool, hideFilter: Bool){
        hideBackButton(hideBack)
        var rightButtons: [UIBarButtonItem]?=[]
        var leftButtons: [UIBarButtonItem]?=[]
        if (!hideOK){
            let ok = UIBarButtonItem(title: "OK", style: .Plain, target: self, action: #selector(BaseViewController.oKClicked))
            rightButtons?.append(ok)
        }
        if (!hideFilter){
            let filter = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(BaseViewController.filterClicked))
            rightButtons?.append(filter)
        }
        
        if (!hideCancel){
            let cancel = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(BaseViewController.cancelClicked))
            leftButtons?.append(cancel)
        }
        navigationItem.rightBarButtonItems = rightButtons
        navigationItem.leftBarButtonItems = leftButtons
    }
    
    func setBackgroundGradient(){
        let colors = GradientColor(colorLocations: GradientColor.style1)
        view.backgroundColor = UIColor.clearColor()
        let backgroundLayer = colors.gl
        backgroundLayer.frame = view.frame
        if view.layer.sublayers?.count > 0 && view.layer.sublayers![0] is CAGradientLayer {
            view.layer.sublayers?.removeFirst()
        }
        //
        view.layer.insertSublayer(backgroundLayer, atIndex: 0)
    }
    
    func NavigateTo(viewIdentifier: String, asModal: Bool, captureBackgroundImage: Bool?, modalCompletion: ((UIViewController) -> Void)?) -> UIViewController{
        return self.NavigateTo(viewIdentifier, asModal: asModal, captureBackgroundImage: captureBackgroundImage, beforeShow: nil, modalCompletion: modalCompletion)
    }
    func NavigateTo(viewIdentifier: String, asModal: Bool, captureBackgroundImage: Bool?, beforeShow: ((UIViewController) -> Void)?,modalCompletion: ((UIViewController) -> Void)?) -> UIViewController{
        let controller :UIViewController? = self.navigationController?.storyboard?.instantiateViewControllerWithIdentifier(viewIdentifier)
        if (captureBackgroundImage != nil && captureBackgroundImage!){
            let c1=controller as! BaseViewController
            c1.backgroundImage=updateBlur()
        }
        if (beforeShow != nil){
            beforeShow!(controller!)
        }
        if (asModal){
            self.presentViewController(controller!, animated: true, completion:{()->Void in
                if (modalCompletion != nil){
                    modalCompletion!(controller!)
                }
                
            })
        }
        else{
            self.navigationController?.pushViewController(controller!, animated: true)
        }
        return controller!
    }

    func updateBlur()-> UIImage {
        // 1
        //optionsContainerView.hidden = true
        // 2
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 1)
        // 3
        self.view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates: true)
        // 4
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot!
    }
    
    func messageBox(title: String,
                    message: String,
                    prefferedStyle:UIAlertControllerStyle,
                    cancelButton: Bool?,
                    oKButton: Bool?,
                    openSettingButton: Bool?,
                    done: ((action: UIAlertAction) -> Void)?) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: prefferedStyle)
        
        if (oKButton == true){
            let oKAction = UIAlertAction(title: Constants.Variables.actionAlert_OK, style: UIAlertActionStyle.Default, handler: done)
            alertController.addAction(oKAction)
        }
        
        if (cancelButton == true){
            let cancelAction = UIAlertAction(title: Constants.Variables.actionAlert_Cancel, style: .Cancel, handler: done)
            alertController.addAction(cancelAction)
        }
        
        if (openSettingButton == true){
            let openAction = UIAlertAction(title: Constants.Variables.actionAlert_OpenSettings, style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
                done?(action: action)
            }
            alertController.addAction(openAction)
        }        
        self.presentViewController(alertController, animated: true, completion: nil)
                
        return alertController
    }
    
    func showWait(activityIndicator: UIActivityIndicatorView!, closure: () -> Void) {
        if (activityIndicator != nil){
            //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            activityIndicator.startAnimating()
        }
        closure()
        if (activityIndicator != nil){
            dispatch_group_notify(syncGroup, dispatch_get_main_queue()) {
                //UIApplication.sharedApplication().endIgnoringInteractionEvents()
                activityIndicator.stopAnimating()
            }
        }
        
    }
        
    func Toast(message: String){
        let toastLabel = UILabel(frame: CGRectMake(self.view.frame.size.width/2 - 160, self.view.frame.size.height-50, 320, 35))
        toastLabel.backgroundColor = UIColor.blackColor()
        toastLabel.textColor = UIColor.whiteColor()
        toastLabel.textAlignment = NSTextAlignment.Center;
        self.view.addSubview(toastLabel)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        UIView.animateWithDuration(1.0, delay: 2.0, options: .CurveEaseOut, animations: {
            toastLabel.alpha = 0.0
            }, completion: nil)
    }
    
    var _server :ServerAPI!
    var server :ServerAPI {
        get{
            if (_server == nil){
                _server = ServerAPI(syncGroup: syncGroup)
            }
            return _server
        }
    }
    

    func oKClicked(){}
    func filterClicked(){}
    func cancelClicked(){}
    
}