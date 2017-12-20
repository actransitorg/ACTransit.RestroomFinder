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
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var res: MKPinAnnotationView!
        if (annotation is MKUserLocation){
            return nil
        }
        if annotation is LocationAnnotation
        {
           var pin=mapView.dequeueReusableAnnotationView(withIdentifier: dID) as? MKPinAnnotationView
            if pin == nil
            {
                pin=MKPinAnnotationView(annotation: annotation, reuseIdentifier: dID)
            }
            pin?.pinColor=MKPinAnnotationColor.red
            res=pin
        }
        else
        {
            let ann = annotation as? RestroomAnnotation
            var pin=mapView.dequeueReusableAnnotationView(withIdentifier: rID) as? MKPinAnnotationView
            if pin == nil
            {
                pin=MKPinAnnotationView(annotation: annotation, reuseIdentifier: rID)
                let btnRight = UIButton(type: .system)
                btnRight.frame = CGRect(x: 29,y: 29, width: 29, height: 29)
                btnRight.tintColor = mapView.tintColor
                btnRight.setImage(UIImage(named: "Edit"), for: UIControlState())
                
                pin?.rightCalloutAccessoryView = btnRight
                
            }
            if (ann?.hours != nil && ann?.hours != ""){
                let btnLeft = UIButton(type: UIButtonType.detailDisclosure)
                pin?.leftCalloutAccessoryView = btnLeft
            }
            else {
                pin?.leftCalloutAccessoryView = nil
            }
            
            
            if ann != nil && ann!.drinkingWater{
                pin?.pinColor = MKPinAnnotationColor.green
                //pin?.pinTintColor=UIColor.blueColor()
            }else{
                pin?.pinColor = MKPinAnnotationColor.purple
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
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.purple
            polylineRenderer.lineWidth = 1
            return polylineRenderer
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control.isKind(of: UIButton.self){
            if (control as! UIButton).buttonType == .detailDisclosure {
                infoClicked?.raise(view)
            }
            else{
                detailClicked?.raise(view)
            }
        }

    }
}
