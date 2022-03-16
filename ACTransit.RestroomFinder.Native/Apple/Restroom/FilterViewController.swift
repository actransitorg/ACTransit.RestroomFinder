//
//  FilterViewController.swift
//  Restroom
//
//  Created by DevTeam on 2/1/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SharedFramework

class FilterViewController: BaseViewController, ComboViewDelegate {
    
    
    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet var cboRoute: ComboView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var portableWater: UISwitch!
    var onClose: Event<ActionEnum>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showWait(activityIndicator){
            self.cboRoute.layer.cornerRadius = 5

            super.setNavigationBar(true, backgroundColor: UIColor.clear)
            if (super.backgroundImage != nil){
                self.imgBackground.image = super.backgroundImage!
            }
            self.cboRoute.delegate = self
            
            self.loadRoutes()
            
        }
        
//        showWait(activityIndicator){
//
//            
//        }
    }
    
    
    @IBAction func oKClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if (self.onClose != nil){
            self.onClose?.raise(.ok)
        }
        
    }
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if (self.onClose != nil){
            self.onClose?.raise(.cancel)
        }
        
    }
    
    func loadRoutes(){
        let cacheKey = "routes"
        let items = Cache.item(cacheKey) as? [ComboViewItem]
        if (items != nil){
            self.cboRoute.dataSource = items!
            return;
        }
        
        self.syncGroup.enter()
        server.getRoutes({(routes:[RouteModel], error:NSError!) -> Void in
            //print(error?.description)
            defer{
                self.syncGroup.leave()
            }
            Threading.runInMainThread{
                print("Received Timepoints...")
                var dataSource : [ComboViewItem] = [ComboViewItem]()
                dataSource.append(ComboViewItem(title: "All", value: "-1" as NSObject))
                for route in routes {
                    dataSource.append(ComboViewItem(title: route.Name, value: route.RouteId as NSObject))
                }
                if (routes.count > 0){
                    Cache.add(cacheKey,value: dataSource as NSObject)
                }
                
                
                self.cboRoute?.dataSource = dataSource
                self.cboRoute?.selectedIndex = 0
            }
        })

    }
    func getSelectedRoute() -> ComboViewItem!{
        if (_selectedItem != nil){
            return _selectedItem!
        }
        return nil
    }
    var _selectedItem: ComboViewItem?
    func comboViewChanged(_ selectedIndex: Int,item: ComboViewItem!) {
        _selectedItem=item
    }
    
    @objc dynamic var selectedIndex : Int{
        get{
            return cboRoute.selectedIndex
        }
        set(value){
            cboRoute.selectedIndex=value
        }
    }
    
    @objc dynamic var portableWaterOnly : Bool {
        get{
            return portableWater.isOn
        }
        set(value){
            portableWater.isOn = value
        }
    }
    
    
}
