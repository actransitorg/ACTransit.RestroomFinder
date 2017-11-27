//
//  MapInfoHelperView.swift
//  Restroom
//
//  Created by DevTeam on 2/16/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import UIKit
import MapKit

protocol MapInfoHelperViewDelegate: class{
    func mapInfoHelperView(configuration: MapInfoData)
}

class MapInfoHelperView: UIView {
    
    @IBOutlet var myView: UIView!
    @IBOutlet var btnTraffic: UIButton!
    @IBOutlet var btnMapType: UIButton!
    @IBOutlet var btnSegment: UISegmentedControl!
    
    var delegate: MapInfoHelperViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        _init()
    }
    
    override func didAddSubview(subview: UIView) {
        self.myView.frame = self.frame
        if #available(iOS 9.0, *) {
            btnTraffic.enabled = true
        }
        else{
            showTraffic = false
            btnTraffic.enabled = false
        }
        
    }
    
    func _init(){
        NSBundle.mainBundle().loadNibNamed("MapInfoHelperView", owner: self, options: nil)
        self.addSubview(myView)
        
        let bottomBorder : UIView = UIView(frame: CGRectMake(btnTraffic.frame.origin.x, btnTraffic.frame.origin.y + btnTraffic.frame.size.height - 1.0, btnTraffic.frame.size.width, 0.4))
        bottomBorder.backgroundColor = UIColor.grayColor()
        self.myView.addSubview(bottomBorder)
    }
    
    @IBAction func btnTrafficClicked(sender: UIButton) {
        showTraffic = !showTraffic
        let data = getMapInfoData()
        self.delegate?.mapInfoHelperView(data)
    }
    
    @IBAction func btnMapTypeClicked(sender: UIButton) {
        is2d = !is2d
        let data = getMapInfoData()
        self.delegate?.mapInfoHelperView(data)
    }
    @IBAction func btnSegmentValueChanged(sender: UISegmentedControl) {
        let data = getMapInfoData()
        self.delegate?.mapInfoHelperView(data)
    }
    
    var _is2d: Bool=true
    var is2d : Bool {
        get{
            return _is2d;
        }
        set(value){
            _is2d = value
            let title = _is2d ? "3D Map": "2D Map"
            btnMapType.setTitle(title, forState: .Normal)
        }
    }
    
    var _showTraffic: Bool = true
    var showTraffic: Bool {
        get{
            return _showTraffic
        }
        set(value){
            _showTraffic = value
            let title = _showTraffic ? "Hide Traffic": "Show Traffic"
            btnTraffic.setTitle(title, forState: .Normal)
        }
    }
    
    func getMapInfoData()-> MapInfoData{
        let res = MapInfoData()
        switch btnSegment.selectedSegmentIndex{
        case 1:
            res.MapType = .Hybrid
        case 2:
            res.MapType = .Satellite
        default:
            res.MapType = .Standard
        }
        
        res.showTraffic = showTraffic
        res.Is2D = is2d
        return res
    }
    
    
}

class MapInfoData{
    var MapType: MKMapType = .Standard
    var Is2D: Bool = true
    var showTraffic: Bool = true
}
