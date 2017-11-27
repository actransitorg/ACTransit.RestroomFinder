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

            super.setNavigationBar(true, backgroundColor: UIColor.clearColor())
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
    
    
    @IBAction func oKClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if (self.onClose != nil){
            self.onClose?.raise(.OK)
        }
        
    }
    
    @IBAction func cancelClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if (self.onClose != nil){
            self.onClose?.raise(.Cancel)
        }
        
    }
    
    func loadRoutes(){
        let cacheKey = "routes"
        var items = Cache.item(cacheKey) as? [ComboViewItem]
        if (items != nil){
            self.cboRoute.dataSource = items!
            return;
        }
        
        dispatch_group_enter(self.syncGroup)
        server.getRoutes({(routes:[RouteModel], error:NSError!) -> Void in
            print(error?.description)
            defer{
                dispatch_group_leave(self.syncGroup)
            }
            Threading.runInMainThread{
                print("Received Timepoints...")
                var dataSource : [ComboViewItem] = [ComboViewItem]()
                dataSource.append(ComboViewItem(title: "All", value: "-1"))
                for route in routes {
                    dataSource.append(ComboViewItem(title: route.Name, value: route.RouteId))
                }
                Cache.add(cacheKey,value: dataSource)
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
    func comboViewChanged(selectedIndex: Int,item: ComboViewItem!) {
        _selectedItem=item
    }
    
    dynamic var selectedIndex : Int{
        get{
            return cboRoute.selectedIndex
        }
        set(value){
            cboRoute.selectedIndex=value
        }
    }
    
    dynamic var portableWaterOnly : Bool {
        get{
            return portableWater.on
        }
        set(value){
            portableWater.on = value
        }
    }
    
    
}