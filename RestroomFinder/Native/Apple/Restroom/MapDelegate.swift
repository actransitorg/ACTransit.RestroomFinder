//
//  MapDelegate.swift
//  Restroom
//
//  Created by DevTeam on 12/18/15.
//  Copyright © 2015 DevTeam. All rights reserved.
//

import UIKit
import MapKit
import SharedFramework.Swift

class MapDelegate: NSObject, MKMapViewDelegate {

    var detailClicked: Event<MKAnnotationView>?
    var infoClicked: Event<MKAnnotationView>?
    
    let dID = "DriverPinID"
    let rID = "RestroomPinID"
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var res: MKPinAnnotationView!
        if (annotation is MKUserLocation){
            return nil
        }
        if annotation is LocationAnnotation
        {
           var pin=mapView.dequeueReusableAnnotationViewWithIdentifier(dID) as? MKPinAnnotationView
            if pin == nil
            {
                pin=MKPinAnnotationView(annotation: annotation, reuseIdentifier: dID)
            }
            pin?.pinColor=MKPinAnnotationColor.Red
            res=pin
        }
        else
        {
            let ann = annotation as? RestroomAnnotation
            var pin=mapView.dequeueReusableAnnotationViewWithIdentifier(rID) as? MKPinAnnotationView
            if pin == nil
            {
                pin=MKPinAnnotationView(annotation: annotation, reuseIdentifier: rID)
                let btnRight = UIButton(type: .System)
                btnRight.frame = CGRectMake(29,29, 29, 29)
                btnRight.tintColor = mapView.tintColor
                btnRight.setImage(UIImage(named: "Edit"), forState: .Normal)
                
                pin?.rightCalloutAccessoryView = btnRight
                
            }
            if (ann?.hours != nil && ann?.hours != ""){
                let btnLeft = UIButton(type: UIButtonType.DetailDisclosure)
                pin?.leftCalloutAccessoryView = btnLeft
            }
            else {
                pin?.leftCalloutAccessoryView = nil
            }
            
            
            if ann != nil && ann!.drinkingWater{
                pin?.pinColor = MKPinAnnotationColor.Green
                //pin?.pinTintColor=UIColor.blueColor()
            }else{
                pin?.pinColor = MKPinAnnotationColor.Purple
                //pin?.pinTintColor=UIColor.greenColor()
            }
            
            res=pin

        }
        res.canShowCallout=true
        
        
        return res
    }

//    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
//        var v : RankView = RankView(frame: CGRect(x: 1,y: 1,width: 50,height: 50))
//        v.rate = 4
//        v.center = CGPointMake(view.bounds.size.width*0.5, -view.bounds.size.height*0.5)
//        view.addSubview(v)
//    }
    
//    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        print ("region did change")
//    }
    
    
   /* func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var result:MKPinAnnotationView!
        var pinColor=MKPinAnnotationColor.Green
        if annotation.isKindOfClass(LocationAnnotation)
        {
            result=mapView.dequeueReusableAnnotationViewWithIdentifier("LocationAnnotation") as? MKPinAnnotationView
            pinColor=MKPinAnnotationColor.Red
        }
        else{
            result=mapView.dequeueReusableAnnotationViewWithIdentifier("RestroolAnnotation") as? MKPinAnnotationView
        }
        result.pinColor=pinColor
        return result
    }*/
    
    //NOTE: New method added to drawing the route on the map.
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.purpleColor()
            polylineRenderer.lineWidth = 1
            return polylineRenderer
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control.isKindOfClass(UIButton){
            if (control as! UIButton).buttonType == .DetailDisclosure {
                infoClicked?.raise(view)
            }
            else{
                detailClicked?.raise(view)
            }
        }

    }
}
