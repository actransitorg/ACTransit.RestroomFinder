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

class DisclaimerViewController : BaseViewController{

    var textFieldDelegate: TextFieldCustomDelegate!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var txtBadge: UITextField!

    @IBOutlet weak var lblDisclaimerContent: UILabel!
    @IBOutlet var lblError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblDisclaimerContent.text = Constants.Messages.onceDisclaimerText
        
        self.navigationController?.navigationBar.hidden = true;
        
        textFieldDelegate = TextFieldCustomDelegate(limitLen: 6)
        txtBadge.delegate = textFieldDelegate
        
        setBackgroundGradient()
    }
    
    override func viewDidRotated(landscape: Bool) {
        setBackgroundGradient()
    }
    
    @IBAction func txtBadge_EditingChanged(sender: UITextField) {
        lblError.text=""
    }

    @IBAction func txtBadge_Changed(sender: UITextField) {
        
    }
    
    @IBAction func DisagreeClicked(sender: UIButton) {
        exit(0)
        //todo
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.txtBadge.resignFirstResponder()
    }
    
    //override viewdidRota
    
    @IBAction func AgreeClicked(sender: UIButton) {
        
        let badge: String! = txtBadge.text!
        showWait(activityIndicator){
            if (badge == nil || Int(badge) == nil)
            {
                self.lblError.text = Constants.Messages.invalidBadge
                return
            }
            
            self.server.getOperationAsync(badge, agreed: true, validating: false, callBack: {(operationInfo, error) in
                Threading.runInMainThread{
                    if (error != nil){
                        self.lblError.text = Constants.Messages.invalidBadge
                        return
                    }
                    AppStorage.setFirstTimeRunningApplication(badge)
                    
                    let navigationController=self.navigationController
                    let storyboard = navigationController?.storyboard
                    let controller :MapViewController=storyboard?.instantiateViewControllerWithIdentifier("MapView") as! MapViewController
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            })
        }
    }
}