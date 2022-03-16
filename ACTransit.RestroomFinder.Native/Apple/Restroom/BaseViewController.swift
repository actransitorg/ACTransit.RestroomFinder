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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class BaseViewController: UIViewController{
    
    var backgroundImage : UIImage?
    
    var _syncGroup: DispatchGroup? = nil
    var syncGroup: DispatchGroup {
        get{
            if (_syncGroup == nil){
                _syncGroup = DispatchGroup()
            }
            return _syncGroup!;
        }
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController._rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
    
    
    @objc func _rotated(){
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)){
            viewDidRotated(true)
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation))
        {
            viewDidRotated(false)
        }
    }
    
    
    func viewDidRotated(_ landscape: Bool){}
    
    func setNavigationBar(_ hide: Bool, backgroundColor: UIColor?){
        hideNavigationBar(hide)
        if (backgroundColor != nil){
//            //navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(),for: UIBarMetrics.default) //UIImageNamed:@"transparent.png"
//            //self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"transparent.png"),for: UIBarMetrics.default) //UIImageNamed:@"transparent.png"
//            self.navigationController?.navigationBar.shadowImage = UIImage() ////UIImageNamed:@"transparent.png"
//            self.navigationController?.navigationBar.isTranslucent = true
//            self.navigationController?.view.backgroundColor = backgroundColor
            
            self.navigationController?.navigationBar.backgroundColor = UIColor.init(displayP3Red: 200/255, green: 200/255, blue: 200/255, alpha: 0.3)
            //self.navigationController?.navigationBar.barTintColor=UIColor.clear
            //self.navigationController?.view.backgroundColor = backgroundColor
          
            //UIApplication.shared.isStatusBarHidden=true
        }
    }
    
    func hideNavigationBar(_ hide:Bool){
        self.navigationController?.navigationBar.isHidden = hide;
    }
    func hideBackButton(_ hide:Bool){
        self.navigationItem.setHidesBackButton(hide, animated: true)
    }
    
    func setNavigationButtons(_ hideBack: Bool, hideOK: Bool, hideCancel: Bool, hideFilter: Bool, showMenu: Bool = false){
        hideBackButton(hideBack)
        var rightButtons: [UIBarButtonItem]?=[]
        var leftButtons: [UIBarButtonItem]?=[]
        if (!hideOK){
            let ok = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(BaseViewController.oKClicked))
            rightButtons?.append(ok)
        }
        if (!hideFilter){
            let filter = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(BaseViewController.filterClicked))
            rightButtons?.append(filter)
        }
        
        if (showMenu){
            let menuButton = UIBarButtonItem(image: UIImage(named: "hamburger"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseViewController.menuClicked))
            if #available(iOS 13.0, *) {
                menuButton.tintColor = UIColor.label
            } else {
                if #available(iOS 12.0, *) {
                    if traitCollection.userInterfaceStyle == .light { //Light mode
                         menuButton.tintColor = UIColor.darkGray
                    } else {  //Dark Mode
                        menuButton.tintColor = UIColor.white
                    }
                } else {
                    menuButton.tintColor = UIColor.black
                }
            }
            
        
           
            rightButtons?.append(menuButton)
        }
        
        if (!hideCancel){
            let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(BaseViewController.cancelClicked))
            leftButtons?.append(cancel)
        }
        navigationItem.rightBarButtonItems = rightButtons
        navigationItem.leftBarButtonItems = leftButtons
    }
    
    func setBackgroundGradient(colorLocations:[GradientColor.ColorLocation]=GradientColor.style4){
        var style = colorLocations
        
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light { //Light mode
              // do nothing
            } else {  //Dark Mode
                style = GradientColor.style5
            }
        } else {
          // Fallback on earlier versions
        }
        
        let colors = GradientColor(colorLocations: style)
        view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer.frame = view.frame
        if view.layer.sublayers?.count > 0 && view.layer.sublayers![0] is CAGradientLayer {
            view.layer.sublayers?.removeFirst()
        }
        //
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    func NavigateTo(_ viewIdentifier: String, asModal: Bool, captureBackgroundImage: Bool?, modalCompletion: ((UIViewController) -> Void)?) -> UIViewController{
        return self.NavigateTo(viewIdentifier, asModal: asModal, captureBackgroundImage: captureBackgroundImage, beforeShow: nil, modalCompletion: modalCompletion)
    }
    func NavigateTo(_ viewIdentifier: String, asModal: Bool, captureBackgroundImage: Bool?, beforeShow: ((UIViewController) -> Void)?,modalCompletion: ((UIViewController) -> Void)?) -> UIViewController{
        let controller :UIViewController? = self.navigationController?.storyboard?.instantiateViewController(withIdentifier: viewIdentifier)
        if (captureBackgroundImage != nil && captureBackgroundImage!){
            let c1=controller as! BaseViewController
            c1.backgroundImage=updateBlur()
        }
        if (beforeShow != nil){
            beforeShow!(controller!)
        }
        if (asModal){
            self.present(controller!, animated: true, completion:{()->Void in
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
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        // 4
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot!
    }
    
    func messageBox(_ title: String,
                    message: String,
                    prefferedStyle:UIAlertControllerStyle,
                    cancelButton: Bool?,
                    oKButton: Bool?,
                    openSettingButton: Bool?,
                    done: ((_ action: UIAlertAction) -> Void)?) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: prefferedStyle)
        
        if (oKButton == true){
            let oKAction = UIAlertAction(title: Constants.Variables.actionAlert_OK, style: UIAlertActionStyle.default, handler: done)
            alertController.addAction(oKAction)
        }
        
        if (cancelButton == true){
            let cancelAction = UIAlertAction(title: Constants.Variables.actionAlert_Cancel, style: .cancel, handler: done)
            alertController.addAction(cancelAction)
        }
        
        if (openSettingButton == true){
            let openAction = UIAlertAction(title: Constants.Variables.actionAlert_OpenSettings, style: .default) { (action) in
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url,options: [:], completionHandler: nil)
                }
                done?(action)
            }
            alertController.addAction(openAction)
        }        
        self.present(alertController, animated: true, completion: nil)
                
        return alertController
    }
    
    func showWait(_ activityIndicator: UIActivityIndicatorView!, closure: () -> Void) {
        if (activityIndicator != nil){
            //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            activityIndicator.startAnimating()
        }
        closure()
        if (activityIndicator != nil){
            syncGroup.notify(queue: DispatchQueue.main) {
                //UIApplication.sharedApplication().endIgnoringInteractionEvents()
                activityIndicator.stopAnimating()
            }
        }
        
    }
        
    func Toast(_ message: String){
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 160, y: self.view.frame.size.height-50, width: 320, height: 35))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center;
        self.view.addSubview(toastLabel)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveEaseOut, animations: {
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
    
    //  // --------------------------Enterprise/Sideload version
    func checkForUpdate(_ callBack: @escaping (_ updateAvailable: Bool, _ version: VersionModel?) -> Void){
        server.getVersion{ (versions, error) in
            Threading.runInMainThread {
                if (error != nil){
                    print (error!);
                    callBack(false, nil);
                    return;
                }
                print ("version: \(Constants.version)")
                let updateAvailable = (versions.count == 1 && versions[0].appVersion.isBigger(Constants.version))
                var version :VersionModel?
                if  (versions.count == 1) {
                    version = versions[0];
                }
                callBack(updateAvailable, version);
            }
        }
    }
    
    func update(_ version: VersionModel, fail: (() -> Void)?){
        var message = Constants.Messages.newVersionAvaiable;
        //message += "\r\n" + "Current Version: \(Constants.version.toString()), Available: \(version.toString())"
        message += "\r\n Current Version: \(Constants.version.toString())\r\n Available: \(version.appVersion.toString())"
        _=self.messageBox("Update", message: message, prefferedStyle: UIAlertControllerStyle.alert, cancelButton: true, oKButton: true, openSettingButton: false, done: { (action) in
            if (action.title==Constants.Variables.actionAlert_OK){
                if let url=URL(string: version.url) {
                    UIApplication.shared.open(url, options: [:], completionHandler:{ (success) in
                        exit(0)
                    })
                }
                else {
                    fail?()
                }
            }
            else{
                fail?()
            }
        })

    }

    @objc func oKClicked(){}
    @objc func filterClicked(){}
    @objc func cancelClicked(){}
    @objc func menuClicked(){}
    
}
