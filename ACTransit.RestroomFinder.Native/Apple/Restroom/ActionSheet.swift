//
//  ActionSheet.swift
//  Restroom
//
//  Created by Aidin on 5/4/20.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import Foundation
protocol ActionSheetClickDelegate: class{
    func actionSheetClick(_ sender: UIButton, action: ActionSheetButton)
}

public enum ActionSheetButton{
    case Edit
    case Feedback
}
class ActionSheet:UIView{
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnFeedback: UIButton!
    @IBOutlet var myView: UIView!
    @IBOutlet weak var feedBackTopConst: NSLayoutConstraint!
    
    public var representingObject: Any?;
    
    var delegate: ActionSheetClickDelegate?
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        _init()
    }
    
    override func didAddSubview(_ subview: UIView) {
        self.myView.frame = self.frame
    }
    
    func _init(){
        Bundle.main.loadNibNamed("ActionSheet", owner: self, options: nil)
        self.addSubview(myView)
        btnEdit.isHidden = !Common.canEditRestroom()
      
        if (Common.canEditRestroom()){
            feedBackTopConst.constant = 3
            let bottomBorder1 : UIView = UIView(frame: CGRect(x: btnEdit.frame.origin.x, y: btnEdit.frame.origin.y + btnEdit.frame.size.height - 1.0, width: btnEdit.frame.size.width, height: 0.4))
            bottomBorder1.backgroundColor = UIColor.gray
            self.myView.addSubview(bottomBorder1)
        }
        else{
            feedBackTopConst.constant = -30
        }
      
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if let window = self.window {
                self.bottomAnchor.constraintLessThanOrEqualToSystemSpacingBelow(window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
            }
        }
    }

    @IBAction func btnEditClicked(_ sender: UIButton) {
        self.delegate?.actionSheetClick(sender,action: .Edit)
    }
    
    @IBAction func btnFeedbackClicked(_ sender: UIButton) {
        self.delegate?.actionSheetClick(sender,action: .Feedback)
    }
    
     
        
    
}
