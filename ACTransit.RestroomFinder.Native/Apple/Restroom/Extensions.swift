//
//  Extensions.swift
//  Restroom
//
//  Created by DevTeam on 12/21/15.
//  Copyright © 2015 DevTeam. All rights reserved.
//

import Foundation

extension Array where Iterator.Element == KeyValue {
    func containsKey(_ key: String) -> Bool{
        return self.filter({KeyValue in return KeyValue.key==key }).first != nil
    }
    func tryGetValue(_ key: String) -> KeyValue?{
        return self.filter({KeyValue in return KeyValue.key==key }).first
    }
}

extension UIImage{
    static func getImageFrom(str: String?, font: UIFont)->UIImage?{
        let frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .lightGray
        nameLabel.textColor = .systemOrange
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.font = font //UIFont.boldSystemFont(ofSize: 40)
        nameLabel.text = str
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
           nameLabel.layer.render(in: currentContext)
           let nameImage = UIGraphicsGetImageFromCurrentImageContext()
           return nameImage
        }
        return nil
    }
}
