//
//  DisclaimerViewControler.swift
//  Restroom
//
//  Created by DevTeam on 1/27/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
import UIKit
import Darwin
import SharedFramework

class DisclaimerViewController : BaseViewController{

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var lblDisclaimerContent: UILabel!
    @IBOutlet var lblError: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.lblDisclaimerContent.text = Constants.Messages.onceDisclaimerText
        
        self.navigationController?.navigationBar.isHidden = true;
        
        setBackgroundGradient()
    }
    
    

    override func viewDidRotated(_ landscape: Bool) {
        setBackgroundGradient()
    }
    
    
    @IBAction func DisagreeClicked(_ sender: UIButton) {
        exit(0)
        //todo
    }
    

    
    
    
    
    //override viewdidRota
    
    @IBAction func AgreeClicked(_ sender: UIButton) {
        
        let firstName:String! = AppStorage.firstName
        let lastName:String! = AppStorage.lastName
        let badge: String! = AppStorage.badge
        //let phoneNumber: String! = AppStorage.phoneNumber
        //let sessionId: String! = AppStorage.sessionId
        
        showWait(activityIndicator){
            if (firstName==nil || firstName=="")
            {
                self.lblError.text = Constants.Messages.invalidFirstName
                return
            }
            if (lastName==nil || lastName=="")
            {
                self.lblError.text = Constants.Messages.invalidLastName
                return
            }
            if (badge == nil || Int(badge) == nil)
            {
                self.lblError.text = Constants.Messages.invalidBadge
                return
            }
            
            self.server.getOperationAsync(agreed: true, validating: false, callBack: {(operationInfo, error) in
                Threading.runInMainThread{
                    if (error != nil || operationInfo == nil){
                        self.lblError.text = Constants.Messages.invalidLogin
                        return
                    }
                    do{
                        
                        try AppStorage.setDisclaimerShown()
                    }
                    catch CustomErrors.parameterError(let message){
                        print (message)
                    }
                    catch{
                        print ("error while setting FirstTimeRunning application!")
                    }
                    if (!(operationInfo?.sessionApproved)!){
                        self.lblError.text = Constants.Messages.sessionApprovalNeeded
                        return
                    }
                    
                    //let _=self.NavigateTo("MapView", asModal: false, captureBackgroundImage: false, modalCompletion: nil)
                    //self.dismiss(animated: true, completion: nil)
                    //_=Common.NavigateTo("MapView")
                    //let navigationController=self.navigationController
//                    let storyboard = navigationController?.storyboard
//                    let controller :MapViewController=storyboard?.instantiateViewController(withIdentifier: "MapView") as! MapViewController
//                    self.navigationController?.pushViewController(controller, animated: true)
                }
                
                Threading.runInMainThread {
                    let _=self.NavigateTo("MapView", asModal: false, captureBackgroundImage: false, modalCompletion: nil)
                   
                }
                
            })
        }
    }
}
