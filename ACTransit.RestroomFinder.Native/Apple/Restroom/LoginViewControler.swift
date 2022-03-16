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


class LoginViewController : BaseViewController, UITextFieldDelegate
{

    var textFieldDelegate: TextFieldCustomDelegate!
    var text8charFiekdDelegate : TextFieldCustomDelegate!
    var text50charFieldDelegate: TextFieldCustomDelegate!
    var phoneFieldDelegate : TextFieldCustomDelegate!
    
    var sentTimer : Timer?;
    var enableGetSecurityButtonAt : DateTime?
    var btnGetSecurityCodeOriginalTitle=""
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtBadge: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtSecurityCode: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnGetSecurityCode: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true;


        text50charFieldDelegate = TextFieldCustomDelegate(limitLen: 50)
        txtFirstName.delegate = text50charFieldDelegate
        txtLastName.delegate = text50charFieldDelegate

        textFieldDelegate = TextFieldCustomDelegate(limitLen: 6)
        txtBadge.delegate = textFieldDelegate

        phoneFieldDelegate = TextFieldCustomDelegate(limitLen: 15,mask: "+1(XXX)XXX-XXXX")
        txtPhone.delegate = phoneFieldDelegate

        txtSecurityCode.delegate = text50charFieldDelegate
        
        btnNext.isEnabled = false
        btnGetSecurityCodeOriginalTitle = btnGetSecurityCode.title(for: UIControlState.normal)!
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.contentViewClicked(_:)))
        _ = UITapGestureRecognizer(target: self, action:  #selector (self.contentViewClicked (_:)))
        self.contentView.addGestureRecognizer(gesture)
        
        setBackgroundGradient();
       
        
        //
    }
    
    
    @objc func contentViewClicked(_ sender:UITapGestureRecognizer){
        hideKeyboard()
    }
    override func viewDidRotated(_ landscape: Bool) {
        setBackgroundGradient()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        exit(0)
    }
    
    @IBAction func btnGetSecurityCodeClicked(_ sender: UIButton) {
        let firstName:String! = txtFirstName.text!
        let lastName:String! = txtLastName.text!
        let badge: String! = txtBadge.text!
        let phoneNumber: String! = txtPhone.text!
        
        lblError.text = ""
        
        showWait(activityIndicator){
            if (!validateInput()) {
                return
            }
            self.server.sendSecurityCode(firstName, lastName: lastName, badge: badge,phoneNumber: phoneNumber, callBack: {(result:Bool, error) in
                Threading.runInMainThread{
                    if (error != nil || result == false){
                        self.startTimer(enable: false)
                        if (error?.userInfo != nil && error?.userInfo["message"] != nil){
                            self.lblError.text = error?.userInfo["message"] as! String 
                        }
                        else {
                            self.lblError.text = Constants.Messages.invalidLogin
                        }
                        
                        return
                    }
                    self.btnGetSecurityCode.isUserInteractionEnabled = false
                    
                    self.enableGetSecurityButtonAt = DateTime.now().add(300)
                    self.btnGetSecurityCode.setTitle("Send again in 5 Min", for: UIControlState.normal)
                    self.btnGetSecurityCode.isEnabled = false;
                    self.startTimer(enable: true);
                }
            })
        }

    }
    
    @IBAction func btnNextClicked(_ sender: UIButton) {
        let firstName:String! = txtFirstName.text!
        let lastName:String! = txtLastName.text!
        let badge: String! = txtBadge.text!
        let phoneNumber: String! = txtPhone.text!
        let securityCode: String! = txtSecurityCode.text!
        
        lblError.text = ""
        showWait(activityIndicator){
            if (!validateInput()) {
                return
            }
            self.server.validateSecurityCode(firstName, lastName: lastName, badge: badge, phoneNumber: phoneNumber, securityCode: securityCode , callBack: {(authModel:AuthenticationModel?, error) in
                Threading.runInMainThread{
                    self.startTimer(enable: false)
                    if (error != nil || authModel == nil || !authModel!.sessionApproved || (authModel!.deviceSessionId==nil || authModel!.deviceSessionId!.count<10)){
                        
                        self.lblError.text = Constants.Messages.invalidSecurityCode
                        return
                    }
                    _ = Common.canAddRestroom(value: authModel?.canAddRestroom)
                    _ = Common.canEditRestroom(value: authModel?.canEditRestroom)
                   
                    do{
             
                        try AppStorage.setCurrentLoginInformation(firstName, lastName: lastName, badge: badge,phoneNumber: phoneNumber, sessionId:(authModel?.deviceSessionId!)!)
                    }
                    catch CustomErrors.parameterError(let message){
                        print (message)
                    }
                    catch{
                        print ("error while setting FirstTimeRunning application!")
                    }
                    let _=self.NavigateTo("Disclaimer", asModal: false, captureBackgroundImage: false, modalCompletion: nil)
                    
                }
            })
        }
        
    
    }
    
    @IBAction func txtField_EditingChanged(_ sender: UITextField) {
        lblError.text=""
        if (sender.restorationIdentifier=="txtSecurityCode"){
            btnNext.isEnabled = (sender.text != "")
        }
    }

    func startTimer(enable:Bool){
        if (!enable && sentTimer != nil){
            sentTimer!.invalidate()
            sentTimer = nil;
            return;
        }
        if (enable && sentTimer == nil){
            sentTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(sentTimer_fire), userInfo: nil, repeats: true)
        }
        // either it is already enabled or already disabled.
        
    }
    @objc func sentTimer_fire()
    {
        var minuteLeft = self.enableGetSecurityButtonAt != nil ? DateTime().subtract(self.enableGetSecurityButtonAt!,calendarUnit: .minute).minute! : 0
        minuteLeft += 1
        if (minuteLeft <= 0){
            self.btnGetSecurityCode.setTitle(btnGetSecurityCodeOriginalTitle, for: UIControlState.normal)
            self.btnGetSecurityCode.isEnabled = true;
            self.btnGetSecurityCode.isUserInteractionEnabled = true
            startTimer(enable: false)
        }
        else {
            Threading.runInMainThread {
                UIView.performWithoutAnimation {
                    self.btnGetSecurityCode.setTitle("Send again in \(minuteLeft) Min", for: .normal)
                    self.btnGetSecurityCode.layoutIfNeeded()
                }
            }

        }
   
    }
    
    func validateInput()->Bool
    {
        let firstName:String! = txtFirstName.text!
        let lastName:String! = txtLastName.text!
        let badge: String! = txtBadge.text!
        let phone: String! = txtPhone.text!
        if (firstName==nil || firstName=="")
        {
            self.lblError.text = Constants.Messages.invalidFirstName
            self.txtFirstName.becomeFirstResponder()
            return false
        }
        if (lastName==nil || lastName=="")
        {
            self.lblError.text = Constants.Messages.invalidLastName
            self.txtLastName.becomeFirstResponder()
            return false
        }
        if (badge == nil || Int(badge) == nil)
        {
            self.lblError.text = Constants.Messages.invalidBadge
            self.txtBadge.becomeFirstResponder()
            return false
        }
        if (phone == nil || phone.count != 15)
        {
            self.lblError.text = Constants.Messages.invalidPhone
            self.txtPhone.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func hideKeyboard(){
        self.txtFirstName.resignFirstResponder()
        self.txtLastName.resignFirstResponder()
        self.txtBadge.resignFirstResponder()
        self.txtPhone.resignFirstResponder()
        self.txtSecurityCode.resignFirstResponder()
    }
    
    
}
