//
//  CustomTableViewCell.swift
//  Restroom
//
//  Created by DevTeam on 2/11/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import UIKit

protocol CustomTableViewCellDelegate: class {
    func CustomTableViewCellEditClicked(cell: CustomTableViewCell)
}
class CustomTableViewCell: UITableViewCell, RankViewDelegate {

    @IBOutlet var btnRank: RankView!
    @IBOutlet var lblTitle: UILabel!

    @IBOutlet weak var imgWater: UIImageView!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var lblRate: UILabel!
    var customDelegate: CustomTableViewCellDelegate?
    
    @IBOutlet var lblExtraInfo: UILabel!
    
    var customTag: AnyObject!
    
    var onTapped : (() -> Void)? = nil
    
    override func didAddSubview(subview: UIView) {
        super.didAddSubview(subview)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CustomTableViewCell.clicked(_:)))
        self.addGestureRecognizer(tap)
        
        //btnRank.delegate = self
    }
    
    func load (title: String, rate :Double, extraInfo: String? = "", potableWater: Bool=false){
        self.lblTitle.text = title
        btnRank.readOnly = true
        self.rate = rate
        self.lblExtraInfo.text = extraInfo ?? ""
        self.imgWater.hidden = !potableWater
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func clicked(sender: UITableViewCell){
        if let onCellTapped = self.onTapped {
            onCellTapped()
        }
    }
    
    @IBAction func editClicked(sender: UIButton) {
        self.customDelegate?.CustomTableViewCellEditClicked(self)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    var editEnabled: Bool{
        get{
            return !btnEdit.hidden
        }
        set(value){
            btnEdit.hidden = !value
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
    
    
    func RankViewChanged(rate: Double) {
        
    }
    
}
