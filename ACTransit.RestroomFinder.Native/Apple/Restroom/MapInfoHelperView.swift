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
    func mapInfoHelperView(_ configuration: MapInfoData)
}

class MapInfoHelperView: UIView {
    
    @IBOutlet var myView: UIView!
    @IBOutlet var btnTraffic: UIButton!
    @IBOutlet var btnMapType: UIButton!
    @IBOutlet var btnSegment: UISegmentedControl!
    @IBOutlet weak var btnPoi: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
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
    
    override func didAddSubview(_ subview: UIView) {
        self.myView.frame = self.frame
        if #available(iOS 9.0, *) {
            btnTraffic.isEnabled = true
        }
        else{
            showTraffic = false
            btnTraffic.isEnabled = false
        }
        
    }
    
    func _init(){
        Bundle.main.loadNibNamed("MapInfoHelperView", owner: self, options: nil)
        self.addSubview(myView)
        
        let bottomBorder1 : UIView = UIView(frame: CGRect(x: btnTraffic.frame.origin.x, y: btnTraffic.frame.origin.y + btnTraffic.frame.size.height - 1.0, width: btnTraffic.frame.size.width, height: 0.4))
        bottomBorder1.backgroundColor = UIColor.gray
        self.myView.addSubview(bottomBorder1)
        
        let bottomBorder2 : UIView = UIView(frame: CGRect(x: btnMapType.frame.origin.x, y: btnMapType.frame.origin.y + btnMapType.frame.size.height - 1.0, width: btnMapType.frame.size.width, height: 0.4))
        bottomBorder2.backgroundColor = UIColor.gray
        self.myView.addSubview(bottomBorder2)
        
        if (Common.canAddRestroom()){
            let bottomBorder3 : UIView = UIView(frame: CGRect(x: btnPoi.frame.origin.x, y: btnPoi.frame.origin.y + btnPoi.frame.size.height - 1.0, width: btnPoi.frame.size.width, height: 0.4))
            bottomBorder3.backgroundColor = UIColor.gray
            self.myView.addSubview(bottomBorder3)
            btnAdd.isHidden=false
        }
        else {
            btnAdd.isHidden=true
        }
//        if #available(iOS 11.0, *) {
//            myView.bottomAnchor.constraint(
//                equalTo: self.safeAreaLayoutGuide.bottomAnchor,
//                constant: -80
//            ).isActive = true
//        } else {
//            // Fallback on earlier versions
//        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if let window = self.window {
                self.bottomAnchor.constraintLessThanOrEqualToSystemSpacingBelow(window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
            }
        }
    }
    
    @IBAction func btnTrafficClicked(_ sender: UIButton) {
        showTraffic = !showTraffic
        let data = getMapInfoData()
        self.delegate?.mapInfoHelperView(data)
    }
    
    @IBAction func btnMapTypeClicked(_ sender: UIButton) {
        is2d = !is2d
        let data = getMapInfoData()
        self.delegate?.mapInfoHelperView(data)
    }
    @IBAction func btnSegmentValueChanged(_ sender: UISegmentedControl) {
        let data = getMapInfoData()
        self.delegate?.mapInfoHelperView(data)
    }
    
    @IBAction func btnPoiClicked(_ sender: Any) {
        poi = !poi
        let data = getMapInfoData()
        self.delegate?.mapInfoHelperView(data)
    }
    
    @IBAction func btnAddClicked(_ sender: UIButton) {
        let data = getMapInfoData()
        data.AddRestroomClicked = true
        self.delegate?.mapInfoHelperView(data)
    }
    
    
    var _poi: Bool = true
    var poi : Bool {
        get{
            return _poi;
        }
        set(value){
            _poi = value
            let title = _poi ? "Hide Point of Interests": "Show Point of Interests"
            btnPoi.setTitle(title, for: UIControlState())
        }
    }
    
    var _is2d: Bool=true
    var is2d : Bool {
        get{
            return _is2d;
        }
        set(value){
            _is2d = value
            let title = _is2d ? "3D Map": "2D Map"
            btnMapType.setTitle(title, for: UIControlState())
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
            btnTraffic.setTitle(title, for: UIControlState())
        }
    }
    
    func getMapInfoData()-> MapInfoData{
        let res = MapInfoData()
        switch btnSegment.selectedSegmentIndex{
        case 1:
            res.MapType = .hybrid
        case 2:
            res.MapType = .satellite
        default:
            res.MapType = .standard
        }
        
        res.showTraffic = showTraffic
        res.Is2D = is2d
        res.Poi = poi;
        res.AddRestroomClicked = false;
        return res
    }
    
    
}

class MapInfoData{
    var MapType: MKMapType = .standard
    var Is2D: Bool = true
    var showTraffic: Bool = true
    var Poi: Bool = false
    var AddRestroomClicked:Bool = false
}
