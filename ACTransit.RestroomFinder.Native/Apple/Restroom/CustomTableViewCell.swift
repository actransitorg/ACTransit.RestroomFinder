//
//  CustomTableViewCell.swift
//  Restroom
//
//  Created by DevTeam on 2/11/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import UIKit

protocol CustomTableViewCellDelegate: class {
    func CustomTableViewCellEditClicked(_ cell: CustomTableViewCell)
}
class CustomTableViewCell: UITableViewCell, RankViewDelegate {

    @IBOutlet var btnRank: RankView!
    @IBOutlet var lblTitle: UILabel!

    @IBOutlet weak var lblLabelId: UILabel!
    @IBOutlet weak var lblHistory: UILabel!
    @IBOutlet weak var imgWater: UIImageView!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var lblRate: UILabel!
    var customDelegate: CustomTableViewCellDelegate?
    
    @IBOutlet weak var lblPending: UILabel!
    @IBOutlet weak var lblInspectionPassed: UILabel!
    @IBOutlet weak var view2Row: UIView!
    @IBOutlet weak var view2RowHeight: NSLayoutConstraint!
    @IBOutlet weak var lblToiletAvailable: UILabel!
    @IBOutlet var lblExtraInfo: UILabel!
    
    var customTag: AnyObject!
    
    var onTapped : (() -> Void)? = nil
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CustomTableViewCell.clicked(_:)))
        self.addGestureRecognizer(tap)
        
        //btnRank.delegate = self
    }
    

    override func layoutSubviews() {
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light { //Light mode
                self.imgWater.image = self.imgWater.image?.withRenderingMode(.alwaysTemplate)
                if #available(iOS 13.0, *) {
                    self.imgWater.tintColor = UIColor.label
                    self.btnEdit.tintColor = UIColor.label
                    //self.lblLabelId.textRect(forBounds: <#T##CGRect#>, limitedToNumberOfLines: <#T##Int#>)
                }
                else {
                    self.imgWater.tintColor = UIColor.black
                    self.btnEdit.tintColor = UIColor.black
                }
            } else if traitCollection.userInterfaceStyle == .dark{  //Dark Mode
                self.imgWater.image = self.imgWater.image?.withRenderingMode(.alwaysTemplate)
                self.imgWater.tintColor = UIColor.white
                self.btnEdit.tintColor = UIColor.white
            }
        }
    }
    
    func load (_ title: String,labelId: String?, inspectionPassed:Bool?,  rate :Double, extraInfo: String? = "", potableWater: Bool=false, isHistory: Bool=false, isToiletAvailable:Bool=true, isFeedback:Bool=false, pendingApproval:Bool=false){
        self.lblTitle.text = title
        btnRank.readOnly = true
        self.lblLabelId.text = "" //labelId
        self.lblLabelId.isHidden = true //(labelId==nil || labelId=="")
       
        self.rate = rate
        self.lblExtraInfo.text = extraInfo ?? ""
        self.imgWater.isHidden = !potableWater
        self.lblHistory.isHidden = !isHistory
        self.lblPending.isHidden = !pendingApproval
        self.lblToiletAvailable.isHidden = !isToiletAvailable
        
        
        self.view2RowHeight.constant = (isFeedback ? 0 : 24)
        if (inspectionPassed != nil){
            self.lblInspectionPassed.text = "Inspection " + (inspectionPassed==true ? "Passed" : "Failed")
        }
        else{
            self.lblInspectionPassed.text = ""
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @objc func clicked(_ sender: UITableViewCell){
        if let onCellTapped = self.onTapped {
            onCellTapped()
        }
    }
    
    @IBAction func editClicked(_ sender: UIButton) {
        self.customDelegate?.CustomTableViewCellEditClicked(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    var editEnabled: Bool{
        get{
            return !btnEdit.isHidden
        }
        set(value){
            btnEdit.isHidden = !value
        }
    }
    
    var rate: Double {
        get{
            return btnRank.rate
        }
        set(value){
            btnRank.rate = value
            if (value>0){
                let rateStr = NSString(format: "%.1f",value) as String
                lblRate.text = rateStr
            }
            else{
                lblRate.text = ""
            }

        }
    }
    
    
    func RankViewChanged(_ rate: Double) {
        
    }
    
}
