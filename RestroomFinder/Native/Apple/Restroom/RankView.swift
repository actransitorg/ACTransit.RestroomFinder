//
//  ComboView.swift
//  Restroom
//
//  Created by DevTeam on 2/1/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import UIKit

protocol RankViewDelegate: class{
    func RankViewChanged(rate: Double)
}
//@IBDesignable
class RankView: UIView{
    
  
    @IBOutlet var myView: UIView!
    
    @IBOutlet var btnStars: [UIButton]!=[UIButton]()
    @IBOutlet var lblWidth: UILabel!
    
    var delegate : RankViewDelegate?
    //@IBInspectable
    var readOnly : Bool = false
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    }
    
    func _init(){
        NSBundle.mainBundle().loadNibNamed("RankView", owner: self, options: nil)
        self.addSubview(myView)
        for _ in 0 ..< 5{
            
            let button = UIButton(type: .Custom)
            button.setImage(UIImage(imageLiteral: "StarEmpty"), forState: .Normal)
            button.addTarget(self, action: #selector(RankView.starClicked(_:)), forControlEvents: .TouchUpInside)
            self.addSubview(button)
            //self.myView.addSubview(button)
            self.btnStars.append(button)
            //self.btnStars[i].setAttributedTitle(NSAttributedString(string: "⭐"), forState: .Normal)
        }
        resize()
    }
    
    override func layoutSubviews() {
        self.resize()
    }


    func starClicked(sender: UIButton){
        if (readOnly){
            return
        }
        
        let rank = btnStars.indexOf(sender) ?? -1
        self.rate = Double(rank + 1)
    }
    
    func resize() {
        let width = (self.frame.width) / 5
        for i in 0 ..< 5 {
            let button = self.btnStars[i]
            let left = (width * CGFloat(i)) //+ CGFloat(i * 1)
            button.frame = CGRectMake(left, 0, width,width)
            button.frame.standardizeInPlace()
        }
        
    }
    
    var _rate: Double = -1
    var rate : Double {
        get{
            return _rate
        }
        set(value){
            _rate = value
            for i in 0 ..< 5 {
                let button=btnStars[Int(i)]
                if (Double(i) < _rate){
                    button.setImage(UIImage(imageLiteral: "StarFilled"), forState: .Normal)
                }
                else{
                    button.setImage(UIImage(imageLiteral: "StarEmpty"), forState: .Normal)
                }
            }
            self.delegate?.RankViewChanged(_rate)
        }
    }
    
    
}
