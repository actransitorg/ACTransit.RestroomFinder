//
//  FeedBackViewController.swift
//  Restroom
//
//  Created by DevTeam on 2/11/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import UIKit
import SharedFramework

protocol FeedbackViewControllerDelegate: class{
    func onFeedbackViewControllerDone(_ action: ActionEnum, data: Any?)
}


class FeedbackViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, CustomTableViewCellDelegate  {
    var onClose: Event<ActionEnum>?
    
    var delegate: FeedbackViewControllerDelegate?
    
    
    @IBOutlet var activityIndicator : UIActivityIndicatorView!
    @IBOutlet var imgBackground     : UIImageView!
    
    @IBOutlet var txtFeedback       : UITextView!
    var txtFeedbackDelegate         : TextViewCustomDelegate!
    
    @IBOutlet var btnRank       : RankView!
    @IBOutlet var swNeedCleaning: UISwitch!
    @IBOutlet var swNeedSupplies: UISwitch!
    @IBOutlet var swNeedRepair  : UISwitch!
    @IBOutlet weak var swRestroomClosed: UISwitch!
    @IBOutlet var btnFeedback   : UIButton!
    @IBOutlet var tblFeedbacks  : UITableView!
    @IBOutlet weak var lblInspectionPassed: UILabel!
    @IBOutlet weak var swInspectionPassed: UISwitch!
    
    @IBOutlet weak var lblLabelId: PaddingLabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblTitle : UILabel!
    
    @IBOutlet weak var restroomTopConstraint: NSLayoutConstraint!
    var listOpen: Bool = false
    
    var dataSource=[FeedbackModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnFeedback.layer.borderWidth = 0.5
        txtFeedbackDelegate     = TextViewCustomDelegate(limitLen: 254)
        txtFeedback.delegate    = txtFeedbackDelegate
        
        tblFeedbacks.dataSource = self
        tblFeedbacks.delegate   = self
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tblFeedbacks.register(nib, forCellReuseIdentifier: "customCell")
        
        lblTitle.text = _currentRestroom.name
        lblLabelId.text = _currentRestroom.labelId
        
        lblLabelId.isHidden = (_currentRestroom.labelId == nil || _currentRestroom.labelId == "")
        
        lblInspectionPassed.isHidden = !(Common._canAddRestroom || Common._canEditRestroom)
        swInspectionPassed.isHidden = !(Common._canAddRestroom || Common._canEditRestroom)
        restroomTopConstraint.constant = (Common._canAddRestroom || Common._canEditRestroom) ? 15 : -15
    
        showWait(activityIndicator){
//            if(super.backgroundImage != nil){
//                self.imgBackground.image = super.backgroundImage!
//            }
            //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FeedbackViewController.dismissKeyboard))
            self.view.addGestureRecognizer(tap)
            self.loadFeedbacks()
            
            if (!listOpen){
                Threading.runInMainThread {
                   self.tblFeedbacks.frame.origin.y = self.btnFeedback.frame.origin.y + 30
                   self.tblFeedbacks.isHidden   = true
                   self.btnFeedback.isSelected  = false
                }
               
            }
            
            if #available(iOS 12.0, *) {
               if traitCollection.userInterfaceStyle == .light { //Light mode
                   setBorderColorsDefault()
               } else {  //Dark Mode
                   setBackgroundGradient(colorLocations: GradientColor.style5)
               }
            } else {
               setBorderColorsDefault()
            }
            super.setNavigationBar(true, backgroundColor: UIColor.clear)
        }
    }



    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    @IBAction func oKClicked(_ sender: UIButton) {
        let feedback = self.feedback
        if (feedback.needAttention == false && feedback.feedbackText == "" && feedback.rating <= 0 ){
            Toast(Constants.Messages.feedbackEmptySumbit)
            return;
        }
        if (feedback.feedbackText == "" && feedback.rating < 3 ){
            _=messageBox("stop", message: Constants.Messages.feedbackTextRequired, prefferedStyle: UIAlertControllerStyle.alert, cancelButton: false, oKButton: true, openSettingButton: false) {(action: UIAlertAction) in
                return
            }
            return
        }
        showWait(activityIndicator){
            self.btnSubmit.isEnabled = false
            self.syncGroup.enter()
            self.server.saveFeedback(feedback, callBack: { (feedback, error) in
                Threading.runInMainThread {
                    defer{
                        self.syncGroup.leave()
                        self.btnSubmit.isEnabled = true
                        if (error == nil) {
                            self.delegate?.onFeedbackViewControllerDone(ActionEnum.ok, data: nil)
                            self.navigationController?.popViewController(animated: true)
                            //self.dismiss(animated: true, completion: nil)
                        }
                    }
                    if (error != nil){
                        self.Toast(Constants.Messages.feedbackSumbitError)
                        return;
                    }
                    print ("Feedback: \(String(describing: feedback))")
    //                if (self.onClose != nil){
    //                    self.onClose?.raise(.ok)
    //                }
                }
            })
        }
    }
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        delegate?.onFeedbackViewControllerDone(ActionEnum.cancel, data: nil)
        self.navigationController?.popViewController(animated: true)
        
//        self.dismiss(animated: true, completion: nil)
//        if (self.onClose != nil){
//            self.onClose?.raise(.cancel)
//        }
        
    }
    
    @IBAction func btnFeedbackClicked(_ sender: AnyObject) {
        let frame=self.view.frame
        
        if (listOpen){
            listOpen = false
            self.tblFeedbacks.frame.origin.y = self.btnFeedback.frame.origin.y + 30
            self.tblFeedbacks.isHidden      = true
            self.btnFeedback.isSelected     = false
            
        }else{
            listOpen = true
            var h = frame.height * 0.4;
            if (h < 100){
                h = 100
            }
            self.tblFeedbacks.isHidden          = false
            
            self.tblFeedbacks.frame.size.height = h
            self.tblFeedbacks.frame.origin.y    = self.btnFeedback.frame.origin.y  - h
            self.btnFeedback.isSelected         = true
            
        }
    }
    
    var feedback: FeedbackModel {
        get{
            return FeedbackModel(restroomId     : currentRestroom.id ,
                                 inspectionPassed: ((Common._canAddRestroom || Common._canEditRestroom) ? swInspectionPassed.isOn : nil),
                                 needCleaning   : swNeedCleaning.isOn,
                                 needSupplies   : swNeedSupplies.isOn,
                                 needRepair     : swNeedRepair.isOn,
                                 closed         : swRestroomClosed.isOn,
                                 feedback       : txtFeedback.text, rating: Double(btnRank.rate), badge: AppStorage.badge)
        }
        set(value){
            swNeedCleaning.isOn = value.needCleaning
            swNeedSupplies.isOn = value.needSupplies
            swNeedRepair.isOn   = value.needRepair
            swRestroomClosed.isOn = value.closed
            txtFeedback.text    = value.feedbackText
            btnRank.rate        = value.rating
            
            showWait(activityIndicator){
                self.loadFeedbacks()
            }
            
        }
    }
    
    fileprivate var _currentRestroom: RestStopModel!
    var currentRestroom: RestStopModel! {
        get{
            return _currentRestroom
        }
        set(value){
            _currentRestroom = value
        }
    }
    
    func loadFeedbacks(){
        server.getFeedbacks(currentRestroom.id, callBack:{ (feedbacks: [FeedbackModel], error: NSError!) in
            Threading.sync(self.dataSource as AnyObject){
                self.dataSource.removeAll()
            }
            self.dataSource.append(contentsOf: feedbacks)
            DispatchQueue.main.async(execute: {
                self.tblFeedbacks.reloadData()
            })
        } )
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomTableViewCell = self.tblFeedbacks.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        cell.customDelegate = self
        let feedback        = dataSource[indexPath.row] as FeedbackModel
        cell.customTag      = feedback
        cell.editEnabled    = false
        cell.onTapped       = {
            _ = super.messageBox("Feedback", message: feedback.feedbackText, prefferedStyle: .alert, cancelButton: false, oKButton: true, openSettingButton: false, done: nil)
        }
        let needAttention   = feedback.needAttention ? "Yes" : "No"
        let feedbackText    = feedback.feedbackText == "" ? "" : ", \(feedback.feedbackText!)"
        let text            = "Need attention: \(needAttention)\(feedbackText)"
        cell.load(text, labelId: "",inspectionPassed: feedback.inspectionPassed, rate: feedback.rating,isFeedback: true)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let ann=self.restrooms[indexPath.row] as RestroomAnnotation
//        map.selectAnnotation(ann, animated: true)
    }
    
    //NOTE: Updated title to display route info.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Last Feedback"
    }
    
    func CustomTableViewCellEditClicked(_ cell: CustomTableViewCell) {
        
    }
    
    func setBorderColorsDefault(){
       txtFeedback.layer.borderWidth = 0.5
       txtFeedback.layer.cornerRadius = 5
       txtFeedback.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
   }
}
