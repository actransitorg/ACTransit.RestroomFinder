//
//  LoginViewController.swift
//  Restroom
//
//  Created by DevTeam on 12/17/15.
//  Copyright © 2015 DevTeam. All rights reserved.
//

import UIKit
import MapKit

class StartupViewController: BaseViewController {

    
    @IBOutlet weak var lblVersion: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(true)
        
        // Do any additional setup after loading the view.
        
        
        //NOTE: Travis added this:  This allows us to dismiss the keyboard when a user clicks on the background, outside of the textbox.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StartupViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        setBackgroundGradient()
        var version = "Verson: \(Constants.version.toString())"
        if (Constants.Variables.testMode) {
            version += " !!!Test!!!"
        }
        lblVersion.text = version
        let sec:Int64 = Constants.Variables.testMode ? 5 : 1
        let triggerTime = (Int64(NSEC_PER_SEC) * sec)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(triggerTime) / Double(NSEC_PER_SEC), execute: { () -> Void in
            self.check();
        })
       
     }
    func check(){
        checkForUpdate { (updateAvailable, version) in
            if (updateAvailable){
                self.update(version!)
            }
            else{
                self.navigate()
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Startup")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as! [AnyHashable: Any])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidRotated(_ landscape: Bool) {
        setBackgroundGradient()
    }
    
    //NOTE: Travis added this:  This allows us to dismiss the keyboard when a user clicks on the background, outside of the textbox.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func navigate(){
        let isFirstTime = AppStorage.isFirstTimeRunningApplication()
        if !(isFirstTime){
            let badge = AppStorage.badge!
            let server = ServerAPI(syncGroup: syncGroup)
            server.getOperationAsync(badge, agreed: true, validating: true, callBack: {(operationInfo, error) in
                Threading.runInMainThread{
                    let viewName = (error != nil) ? "Disclaimer" : "MapView"
                    let _=super.NavigateTo(viewName, asModal: false, captureBackgroundImage: false, modalCompletion: nil)
                }
            })
        }
        else{
            Threading.runInMainThread{
                let viewName = isFirstTime ? "Disclaimer" : "MapView"
                let _=self.NavigateTo(viewName, asModal: false, captureBackgroundImage: false, modalCompletion: nil)
            }
           
        }

    }
    
    func checkForUpdate(_ callBack: @escaping (_ updateAvailable: Bool, _ version: VersionModel?) -> Void){
//        callBack(updateAvailable: true, version: VersionHelper(version: "00.00.05"));
        server.getVersion { (versions, error) in
            if (error != nil){
                print (error!)
                callBack(false, nil);
                return;
            }
            print ("version: \(Constants.version)")
            let updateAvailable = (versions.count == 1 && versions[0].appVersion.isBigger(Constants.version))
            var version :VersionModel?
            if(versions.count == 1){
                version=versions[0];
            }
            callBack(updateAvailable, version);
        }
        
    }
    func update(_ version: VersionModel){
        var message = Constants.Messages.newVersionAvaiable;
        //message += "\r\n" + "Current Version: \(Constants.version.toString()), Available: \(version.toString())"
        message += "\r\n Current Version: \(Constants.version.toString())\r\n Available: \(version.appVersion.toString())"
        _=self.messageBox("Update", message: message, prefferedStyle: UIAlertControllerStyle.alert, cancelButton: true, oKButton: true, openSettingButton: false, done: { (action) in
            if (action.title==Constants.Variables.actionAlert_OK){
                let url=URL(string: version.url);
                if (UIApplication.shared.openURL(url!)){
                    exit(0)
                }
            }
            else{
                self.navigate()
            }
        })

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
