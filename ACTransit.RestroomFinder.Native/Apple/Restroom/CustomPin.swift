//
//  CustomPin.swift
//  Restroom
//
//  Created by Aidin on 5/1/20.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class CustomPin:MKPinAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.setLongPress()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setLongPress()
    }
    
    // set the long press on the pin text (bubble) not pin itself.
    func setLongPress() {
//        if (Common.canEditRestroom()){
//            let longpress=UILongPressGestureRecognizer(target: self, action: #selector(pinLongPress(longGesture:)))
//            longpress.minimumPressDuration = 2.0
//            //IOS 9
//            self.addGestureRecognizer(longpress)
//        }
    }

    
  
//    -(void)mapView:(MKMapView *)_mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
//
//        if (newState == MKAnnotationViewDragStateEnding) {
//            // custom code when drag ends...
//
//            // tell the annotation view that the drag is done
//        }
//        else if (newState == MKAnnotationViewDragStateCanceling)
//        {
//            // custom code when drag canceled...
//
//            // tell the annotation view that the drag is done
//        }
//    }
  
}
