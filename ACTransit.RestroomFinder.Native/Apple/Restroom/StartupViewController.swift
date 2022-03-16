//
//  LoginViewController.swift
//  Restroom
//
//  Created by DevTeam on 12/17/15.
//  Copyright © 2015 DevTeam. All rights reserved.
//

import UIKit
import MapKit
import SharedFramework
class StartupViewController: BaseViewController {

    
    @IBOutlet weak var lblVersion: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(true)
        
        //Common.navigationController = self.navigationController
        
        
        // Do any additional setup after loading the view.
        
        
        //NOTE: Travis added this:  This allows us to dismiss the keyboard when a user clicks on the background, outside of the textbox.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StartupViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        setBackgroundGradient()
        var version = "Version: \(Constants.version.toString())"
        
        version += Constants.flavor
       
  
        lblVersion.text = version
        let sec:Int64 = Constants.Variables.startupWaitTimeSec
        let triggerTime = (Int64(NSEC_PER_SEC) * sec)
       
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(triggerTime) / Double(NSEC_PER_SEC), execute: { () -> Void in
            self.check();
        })
       
     }
    func check(){
        checkForUpdate { (updateAvailable, version) in
            if (updateAvailable){
                self.update(version!,fail: {
                    //self.navigate()
                   exit(0)
                })
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
        tracker?.send(builder?.build() as? [AnyHashable: Any])
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
        let isFirstTime = AppStorage.isEmpty()
        if !(isFirstTime){
            let server = ServerAPI(syncGroup: syncGroup)
            server.authenticateAsync { (authenticationModel, error) in
                if (authenticationModel != nil){
                    _ = Common.canAddRestroom(value: authenticationModel?.canAddRestroom)
                    _ = Common.canEditRestroom(value: authenticationModel?.canEditRestroom)
                }
                self.handleNavigation(firstTime: !(authenticationModel?.sessionApproved ?? false) ,error: error)
            }
        }
        else{
            handleNavigation(firstTime: true, error: nil)
        }

    }
    
    func handleNavigation(firstTime:Bool, error:NSError?){
        Threading.runInMainThread{
            if ( error != nil || firstTime ){
                let _=super.NavigateTo("Login", asModal: false, captureBackgroundImage: false, modalCompletion: {(controller) in
                    let _=self.NavigateTo("MapView", asModal: false, captureBackgroundImage: false, modalCompletion: nil)
                })
            }
            else{
                let disclaimerShown = AppStorage.disclaimerShown
                let nextView = (disclaimerShown ? "MapView" : "Disclaimer")
                let _=self.NavigateTo(nextView, asModal: false, captureBackgroundImage: false, modalCompletion: nil)
            }
            
        }
    }
    
//  // ----------------------------Apple Stor Version
//    func checkForUpdate(_ callBack: @escaping (_ updateAvailable: Bool, _ version: VersionModel?) -> Void){
//        AppStore.getVersion(id: String(Constants.appleId), {(infos:[AppStoreAppInfo], error) in
//            var updateAvailable = false
//             var version :VersionModel?
//            if (infos.count>0){
//                let v=VersionHelper(version: infos[0].version)
//                updateAvailable = v.isBigger(Constants.version)
//                version=VersionModel(obj: [
//                    "version":v.toString() as AnyObject,
//                    //"url":"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=" + String(infos[0].trackId) + "&mt=8"  as AnyObject
//                    "url":"https://itunes.apple.com/us/app/restroom-locator/id" + String(Constants.appleId) + "?mt=8&uo=4" as AnyObject
//                    ])
//            }
//            callBack(updateAvailable, version);
//        })
//
//    }
//

//  // --------------------------Enterprise/Sideload version
//    func checkForUpdate(_ callBack: @escaping (_ updateAvailable: Bool, _ version: VersionModel?) -> Void){
//        server.getVersion{ (versions, error) in
//            Threading.runInMainThread {
//                if (error != nil){
//                    print (error!);
//                    callBack(false, nil);
//                    return;
//                }
//                print ("version: \(Constants.version)")
//                let updateAvailable = (versions.count == 1 && versions[0].appVersion.isBigger(Constants.version))
//                var version :VersionModel?
//                if  (versions.count == 1) {
//                    version = versions[0];
//                }
//                callBack(updateAvailable, version);
//            }
//        }
//
//    }
    
    
//    func update(_ version: VersionModel){
//        var message = Constants.Messages.newVersionAvaiable;
//        //message += "\r\n" + "Current Version: \(Constants.version.toString()), Available: \(version.toString())"
//        message += "\r\n Current Version: \(Constants.version.toString())\r\n Available: \(version.appVersion.toString())"
//        _=self.messageBox("Update", message: message, prefferedStyle: UIAlertControllerStyle.alert, cancelButton: true, oKButton: true, openSettingButton: false, done: { (action) in
//            if (action.title==Constants.Variables.actionAlert_OK){
//                if let url=URL(string: version.url) {
//                    UIApplication.shared.open(url, options: [:], completionHandler:{ (success) in
//                        exit(0)
//                    })
//                }
//                else {
//                    self.navigate()
//                }
//            }
//            else{
//                self.navigate()
//            }
//        })
//
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
