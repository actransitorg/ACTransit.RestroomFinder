//
//  AddRestroomController.swift
//  Restroom
//
//  Created by DevTeam on 8/27/19.
//  Copyright © 2019 DevTeam. All rights reserved.
//

import UIKit
import MapKit
import SharedFramework

protocol AddRestroomViewControllerDelegate: class{
    func onRestroomViewControllerDone(_ action: ActionEnum, data: Any?)
}

class AddRestroomViewController: BaseViewController, ComboViewDelegate, UITextFieldDelegate, UITextViewDelegate
{
    
    var delegate: AddRestroomViewControllerDelegate?
    
    @IBOutlet weak var cboType: ComboView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var txtLatitude: UITextField!
//    @IBOutlet weak var txtLongitude: UITextField!
    @IBOutlet weak var txtProviderName: UITextField!
    @IBOutlet weak var txtLabelId: UITextField!
    @IBOutlet weak var txtAddress: UITextView!
    @IBOutlet weak var txtContactName: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var swcRestroom: UISwitch!
    @IBOutlet weak var viewRestroomContainer: UIView!
    @IBOutlet weak var swcMen: UISwitch!
    @IBOutlet weak var swcWomen: UISwitch!
    @IBOutlet weak var swcGenderNeutral: UISwitch!
    @IBOutlet weak var swcWater: UISwitch!
    @IBOutlet weak var txtWeekdayHours: UITextField!
    @IBOutlet weak var txtSaturdayHours: UITextField!
    @IBOutlet weak var txtSundayHours: UITextField!
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var txtLocationName: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCreate: UIButton!
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var warningView: UIView!
    
    public var location : CLLocation?
    public var isEdit : Bool?
    var address : String?
    var state : String?
    var city : String?
    var country: String?
    var zip: String?
    
    var originalAddressTextValue : String?
    
    var onClose: Event<ActionEnum>?
    
    
    enum RestroomTypeEnum: Int {
        case Paid = 0, UnPaid, Bart, ACT
    }
    
    var restroom: RestStopModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        initForm()
        
    }
    
    func initForm()->Void{
        
        if (restroom != nil){
            showWait(activityIndicator){
                server.getRestStop(restroom!.id, isPublic: false){ (model, error) in
                    Threading.runInMainThread {
                        defer{
                            
                        }
                        if (error != nil){
                            self.Toast("Error getting the restroom.")
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            self.setVariables(restroom: model)
                        }
                    }
                }
            }
           
        }
        else{
            self.setVariables(restroom: nil)
        }
        
    }
    func setVariables(restroom:RestStopModel?){
        let edit = isEdit ?? false
        lblTitle.text = edit ? "Edit Restroom" : "Add Restroom"
        let items=[
            ComboViewItem(title: "Paid",    value: RestroomTypeEnum.Paid.rawValue as NSObject),
            ComboViewItem(title: "UnPaid",  value: RestroomTypeEnum.UnPaid.rawValue as NSObject),
            ComboViewItem(title: "Bart",    value: RestroomTypeEnum.Bart.rawValue as NSObject),
            ComboViewItem(title: "ACT",    value: RestroomTypeEnum.ACT.rawValue as NSObject)
        ]
        
        let isBart = (restroom?.isBart ?? false)
        let isPaid = (restroom?.isPaid ?? false)
        let isAct = (restroom?.isAct ?? false)
        let typeSelectedIndex = edit ?
                (isBart ?
                    RestroomTypeEnum.Bart.rawValue  :
                    (isPaid ?
                        RestroomTypeEnum.Paid.rawValue :
                        (isAct ?
                            RestroomTypeEnum.ACT.rawValue :
                            RestroomTypeEnum.UnPaid.rawValue )
                    )
                )
                : RestroomTypeEnum.UnPaid.rawValue
        
        showWait(activityIndicator)
        {
            self.cboType.layer.cornerRadius = 5
            cboType.delegate = self
            cboType.dataSource = items
            cboType.selectedIndex = typeSelectedIndex
            
//            txtLatitude.text = location?.coordinate.latitude.description
//            txtLatitude.isUserInteractionEnabled = false
//            txtLongitude.text = location?.coordinate.longitude.description
//            txtLongitude.isUserInteractionEnabled = false
            
            txtAddress.delegate = self
            txtLabelId.delegate = self
            txtLocationName.delegate = self
            txtProviderName.delegate = self
            txtContactName.delegate = self
            txtTitle.delegate = self
            txtEmail.delegate = self
            txtPhone.delegate = self
            txtAddress.delegate = self
            txtWeekdayHours.delegate = self
            txtSaturdayHours.delegate = self
            txtSundayHours.delegate = self
            txtNote.delegate = self
            
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddRestroomViewController.dismissKeyboard))
            self.view.addGestureRecognizer(tap)
                
            if (edit){
                self.address = restroom?.address ?? ""
                self.city = restroom?.city ?? ""
                self.state = restroom?.state ?? ""
                self.country =  restroom?.country ?? ""
                self.zip =  restroom?.zip ?? ""
                self.txtProviderName.text = restroom?.serviceProvider ?? ""
                self.txtLabelId.text = restroom?.labelId ?? ""
                self.txtLocationName.text = restroom?.name ?? ""
                self.txtContactName.text = restroom?.contactName ?? ""
                self.txtTitle.text = restroom?.contactTitle ?? ""
                self.txtEmail.text = restroom?.contactEmail ?? ""
                self.txtPhone.text = restroom?.contactPhone ?? ""
                
                self.txtSundayHours.text = restroom?.sundayHours ?? ""
                self.txtSaturdayHours.text = restroom?.saturdayHours ?? ""
                self.txtWeekdayHours.text = restroom?.weekdayHours ?? ""
                self.txtNote.text = restroom?.note ?? ""
                self.swcWater.isOn = restroom?.drinkingWater ?? false
                self.warningView.isHidden = !(restroom?.isHistory ?? false)
                self.warningLabel.isHidden = !(restroom?.isHistory ?? false)
                self.txtLabelId.text = restroom?.labelId ?? ""
                self.swcRestroom.isOn = restroom?.isToiletAvailable ?? false
                let toiletGenderId = restroom?.toiletGenderId ?? 0
                self.swcMen.isOn = (toiletGenderId & 1) == 1
                self.swcWomen.isOn = (toiletGenderId & 2) == 2
                self.swcGenderNeutral.isOn = (toiletGenderId & 4) == 4
                
                if ((restroom?.isHistory ?? false)){
                    let warning = self.warningLabel.text ?? ""
                    let font = UIFont(name: "FontAwesome", size: 18)
                    if (font != nil){
                        let img = UIImage.getImageFrom(str: "", font: font!)
                        //let img = UIImage.getImageFrom(str: "test", Font: font!)
                        if (img != nil) {
                            let imageAttachment = NSTextAttachment()
                            imageAttachment.image = img //(named:"Edit")
                            // Set bound to reposition
                            let imageOffsetY: CGFloat = -5.0
                            imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
                            // Create string with attachment
                            let attachmentString = NSAttributedString(attachment: imageAttachment)
                            // Initialize mutable string
                            let completeText = NSMutableAttributedString(string: "")
                            // Add image to mutable string
                            completeText.append(attachmentString)
                            // Add your text to mutable string
                            let textAfterIcon = NSAttributedString(string: warning)
                            completeText.append(textAfterIcon)
                            self.warningLabel.textAlignment = .center
                            self.warningLabel.attributedText = completeText
                        }
                    }
                }
                
                self.setAddress();
                
            }
            else{
                self.warningView.isHidden = true
                self.warningLabel.isHidden = true
                lookUpCurrentLocation(completionHandler: { (place) in
                       if (place != nil){
                           self.address = place?.name ?? ""
                           self.city = place?.locality ?? ""
                           self.state = place?.administrativeArea ?? ""
                           self.country = place?.country ?? ""
                           self.zip = place?.postalCode ?? ""
                           self.txtLocationName.text = self.address ?? ""
                        
                            self.setAddress();
                       }
                   })
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
    
    func setAddress()->Void{
        var str = self.address!
        if (self.city! != "" ){
            str += ", "
            str += self.city!
        }
        if (self.state! != ""){
            str += ", "
            str += self.state!
        }
        if (self.country! != ""){
            str += ", "
            str += self.country!
        }
               
        self.txtAddress.text = str
        self.originalAddressTextValue = str
    }
    
    @IBAction func swcRestroomChanged(_ sender: Any) {
        swcMen.isEnabled = swcRestroom.isOn
        swcWomen.isEnabled = swcRestroom.isOn
        swcGenderNeutral.isEnabled = swcRestroom.isOn
    }
    @IBAction func btnCreateClicked(_ sender: UIButton) {
        
        let edit = isEdit ?? false
        let water = swcWater.isOn
        var canContinue=true
        setBorderColorsDefault()
        if (txtContactName.text==""){
            txtContactName.layer.borderColor = UIColor.red.cgColor
            txtContactName.becomeFirstResponder()
            canContinue=false
        }
        if (txtLocationName.text==""){
            txtLocationName.layer.borderColor = UIColor.red.cgColor
            txtLocationName.becomeFirstResponder()
            canContinue=false
        }
        if (txtProviderName.text==""){
            txtProviderName.layer.borderColor = UIColor.red.cgColor
            txtProviderName.becomeFirstResponder()
            canContinue=false
        }

        
        if (!canContinue){
            return
        }
//        else {
//            setBorderColorsDefault()
//        }
        let restroomId = edit ? (restroom?.id ?? 0) : 0
        let toiletGenderId = (swcMen.isOn ? 1 : 0) + (swcWomen.isOn ? 2 : 0) + (swcGenderNeutral.isOn ? 4 : 0)
        restroom=RestStopModel.create(id: restroomId, latitude: Double(location?.coordinate.latitude ?? 0),
                                      longitude: Double(location?.coordinate.longitude ?? 0),
                                      name: txtLocationName.text ?? "",address: txtAddress.text ?? "", state: state ?? "",
                                      zip: zip ?? "", city: city ?? "", country: country ?? "", note: txtNote.text ?? "",
                                      weekdayHours: txtWeekdayHours.text ?? "",
                                      saturdayHours: txtSaturdayHours.text ?? "",
                                      sundayHours: txtSundayHours.text ?? "",
                                      serviceProvider: txtProviderName.text ?? "",
                                      contactName: txtContactName.text ?? "",
                                      contactTitle: txtTitle.text ?? "",
                                      contactPhone: txtPhone.text ?? "",
                                      contactEmail: txtEmail.text ?? "",
                                      labelId: txtLabelId.text ?? "",
                                      addressChanged: txtAddress.text != originalAddressTextValue,
                                      toiletGenderId: toiletGenderId,
                                    
                                      hasWater: water,
                                      isPaid: (cboType.selectedIndex==RestroomTypeEnum.Paid.rawValue),
                                      isUnPaid: (cboType.selectedIndex==RestroomTypeEnum.UnPaid.rawValue),
                                      isBart: (cboType.selectedIndex==RestroomTypeEnum.Bart.rawValue),
                                      isAct: (cboType.selectedIndex==RestroomTypeEnum.ACT.rawValue),
            approved: false, isToiletAvailable: true)

        server.saveRestroom(restroom!, isPublic: false) { (model, error) in
            Threading.runInMainThread {
                defer{
                    self.navigationController?.popViewController(animated: true)
                }
                if (error == nil){
                    self.delegate?.onRestroomViewControllerDone(.done, data: self.restroom)
    //                if (self.onClose != nil){
    //                    self.onClose?.raise(.ok)
    //                }
                }
                else {
                    self.Toast("Error saving.")
                }
            }

        }
       
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        delegate?.onRestroomViewControllerDone(.cancel, data: nil)
        self.navigationController?.popViewController(animated: true)
//        if (self.onClose != nil){
//            self.onClose?.raise(.cancel)
//        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func setBorderColorsDefault(){
        txtNote.layer.borderWidth = 0.5
        txtNote.layer.cornerRadius = 5
        txtNote.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        txtLocationName.layer.borderWidth = 0.5
        txtLocationName.layer.cornerRadius = 5
        txtLocationName.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        
        txtProviderName.layer.borderWidth = 0.5
        txtProviderName.layer.cornerRadius = 5
        txtProviderName.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        
        txtContactName.layer.borderWidth = 0.5
        txtContactName.layer.cornerRadius = 5
        txtContactName.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        
        txtAddress.layer.borderWidth = 0.5
        txtAddress.layer.cornerRadius = 5
        txtAddress.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        
        
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        // Use the last reported location.
        if self.location != nil {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(self.location!,
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    completionHandler(nil)
                                                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
    func comboViewChanged(_ selectedIndex: Int, item: ComboViewItem!) {
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return false
    }
    
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
    
}
