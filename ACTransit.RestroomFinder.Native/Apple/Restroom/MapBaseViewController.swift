//
//  MapBaseViewController.swift
//  Restroom
//
//  Created by DevTeam on 3/8/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
import MapKit
import SharedFramework
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class MapBaseViewController: BaseViewController, CLLocationManagerDelegate{
    
    fileprivate var map: MKMapView!
    var locationManager: CLLocationManager!
    var lastGoodLocation: Location?
    var currentLocation: Location?
    var prevLocation: Location?
    var lastLocationDataLoaded: Location?
    var updatingLocation: Bool = false
    var speedBuffer = RingBuffer(count: 3,repeatedValue: 0)
    internal var _compassState = 0 // 0: Normal, 1: Tracking, 2: TrackingShowHeaded
    let mapDelegate = MapDelegate()
    

    func initialLocationManager(_ map: MKMapView)
    {
        self.map = map
        self.map.delegate = mapDelegate
        mapDelegate.detailClicked = Event<MKAnnotationView>()
        mapDelegate.detailClicked?.addHandler({(t) in
            self.annotationDetailsClicked(t)
        })
        mapDelegate.infoClicked = Event<MKAnnotationView>()
        mapDelegate.infoClicked?.addHandler({(t) in
            self.annotationInfoClicked(t)
        })
        
        mapDelegate.pinClicked =  Event<MKAnnotationView>()
        mapDelegate.pinClicked?.addHandler({(t) in
            self.pinClicked(t)
        })
              
        locationManager=CLLocationManager()
        //locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate=self
        startUpdatingLocation()
    }
    func startUpdatingLocation(){
        if CLLocationManager.locationServicesEnabled() && updatingLocation == false {
            locationManager.distanceFilter = 1
            locationManager.activityType = .fitness
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    
    func stopUpdatingLocation(){
        locationManager.stopUpdatingLocation()
        updatingLocation = false
    }

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            startUpdatingLocation()
        }
        else if (status == .denied || status == .restricted){
            _=messageBox(Constants.Messages.locationDisabled,
                message: Constants.Messages.setLocationAccess,
                prefferedStyle: .alert,
                cancelButton: true, oKButton: false, openSettingButton: true, done:nil)
        }
        else if (status == .notDetermined){
            manager.requestWhenInUseAuthorization()          
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var bestLoc: Location?
        var ss : SignalStrengthEnum = SignalStrengthEnum.noSignal
        
        for location in locations{
            let accuracy = location.horizontalAccuracy
            if (accuracy < 0)
            {
                ss = .noSignal
            }
            else if (accuracy > Constants.Variables.poorBestHorizontalAccuracy) //163
            {
                ss = .poor
            }
            else if (accuracy > Constants.Variables.averageBestHorizontalAccuracy)  //40
            {
                ss = .average
            }
            else if (accuracy > Constants.Variables.goodBestHorizontalAccuracy)  //15
            {
                ss = .good
            }
            else
            {
                ss = .full
            }
            if (ss != .noSignal){
                if (bestLoc == nil || bestLoc?.accuracy > accuracy){
                    bestLoc = Location(location: location,recievedTime: DateTime.now(), accuracy: accuracy, signalStrength: ss)
                }
            }
        }
        if (bestLoc != nil){
//Because we need to check the speed all the to disable the application, this part of code should be removed.
//            if (_compassState == 0 && bestLoc?.signalStrength != .Poor){
//                let eventDate : NSDate = (bestLoc?.location.timestamp)!
//                let howRecent : NSTimeInterval  = eventDate.timeIntervalSinceNow
//                if( abs(howRecent) < 50.0) {
//                    self.stopUpdatingLocation()
//                    self.performSelector(#selector(MapBaseViewController.startUpdatingLocation), withObject: nil, afterDelay: 60)
//                }
//            }
            
            if (currentLocation == nil) {
                currentLocation = bestLoc!
            }
            prevLocation = currentLocation!
            currentLocation = bestLoc!
            Common.currentLocation = currentLocation?.location
            if (bestLoc?.signalStrength != .poor && bestLoc?.signalStrength != .noSignal && bestLoc?.signalStrength != .average){
                speedBuffer.add((currentLocation?.location.speed)!)
                lastGoodLocation = bestLoc
            }            
            locationChanged(manager, didUpdateLocations: locations)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("didFailWithError: \(String(describing: CLError.Code(rawValue: error._code)))")
        if error._code == CLError.Code.denied.rawValue {
            stopUpdatingLocation()
        }
        
    }
    @nonobjc func locationChanged(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){    }

    func annotationDetailsClicked(_ annotation: MKAnnotationView){}
    func annotationInfoClicked(_ annotation: MKAnnotationView){}
    func pinClicked(_ annotation: MKAnnotationView){}
    
    fileprivate let regionRadius: CLLocationDistance = 800
    fileprivate var centerMapOnLocationWorking: Bool = false
    func centerMapOnLocation(_ location: CLLocation, zoom: Bool = false) {
        if !centerMapOnLocationWorking {
            centerMapOnLocationWorking = true
            defer{
                centerMapOnLocationWorking = false
            }
            let coordinateRegion = (zoom == true ? MKCoordinateRegionMakeWithDistance(location.coordinate, self.regionRadius * 2.0, self.regionRadius * 2.0): MKCoordinateRegionMake(location.coordinate, self.map.region.span))
            self.map.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func turnonNavigation(_ locationName: String, coordinate: CLLocationCoordinate2D){
        
        let place = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem (placemark: place)
        
        mapItem.name = locationName
        
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: true] as [String : Any]
        MKMapItem.openMaps(with: [mapItem], launchOptions: options)
        
    }


    internal class Location{
        var location: CLLocation
        var recievedTime: DateTime
        var signalStrength: SignalStrengthEnum
        var accuracy: CLLocationAccuracy
        init(location: CLLocation, recievedTime: DateTime, accuracy: CLLocationAccuracy, signalStrength: SignalStrengthEnum){
            self.location = location
            self.recievedTime = recievedTime
            self.accuracy = accuracy
            self.signalStrength = signalStrength
        }
    }
    
   
}
