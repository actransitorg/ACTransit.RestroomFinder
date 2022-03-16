//
//  TableViewDelegate.swift
//  Restroom
//
//  Created by DevTeam on 1/28/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
import UIKit

class TableViewDelegate:NSObject, UITableViewDelegate,UITableViewDataSource {
    
    var dataSource=[RestStopModel]()
    var restrooms = [RestroomAnnotation]()
    var currentRoute = ""
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell=UITableViewCell()
        let rest=dataSource[indexPath.row] as RestStopModel
        cell.textLabel?.text="\(rest.Name)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let ann=self.restrooms[indexPath.row] as RestroomAnnotation
        map.selectAnnotation(ann, animated: true)
    }
    
    //NOTE: Updated title to display route info.
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Restrooms for Route \(self.currentRoute)"
    }

}