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

class MapBaseViewController: BaseViewController, CLLocationManagerDelegate{
    
    private var map: MKMapView!
    var locationManager: CLLocationManager!
    var lastGoodLocation: Location?
    var currentLocation: Location?
    var prevLocation: Location?
    var lastLocationDataLoaded: Location?
    var updatingLocation: Bool = false
    var speedBuffer = RingBuffer(count: 3,repeatedValue: 0)
    internal var _compassState = 0 // 0: Normal, 1: Tracking, 2: TrackingShowHeaded
    let mapDelegate = MapDelegate()
    
    func initialLocationManager(map: MKMapView)
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
        locationManager=CLLocationManager()
        //locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate=self
        startUpdatingLocation()
    }
    func startUpdatingLocation(){
        if CLLocationManager.locationServicesEnabled() && updatingLocation == false {
            locationManager.distanceFilter = 1
            locationManager.activityType = .Fitness
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    
    func stopUpdatingLocation(){
        locationManager.stopUpdatingLocation()
        updatingLocation = false
    }

    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            startUpdatingLocation()
        }
        else if (status == .Denied || status == .Restricted){
            messageBox(Constants.Messages.locationDisabled,
                message: Constants.Messages.setLocationAccess,
                prefferedStyle: .Alert,
                cancelButton: true, oKButton: false, openSettingButton: true, done:nil)
        }
        else if (status == .NotDetermined){
            manager.requestWhenInUseAuthorization()          
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var bestLoc: Location?
        var ss : SignalStrengthEnum = SignalStrengthEnum.NoSignal
        
        for location in locations{
            let accuracy = location.horizontalAccuracy
            if (accuracy < 0)
            {
                ss = .NoSignal
            }
            else if (accuracy > Constants.Variables.poorBestHorizontalAccuracy) //163
            {
                ss = .Poor
            }
            else if (accuracy > Constants.Variables.averageBestHorizontalAccuracy)  //40
            {
                ss = .Average
            }
            else if (accuracy > Constants.Variables.goodBestHorizontalAccuracy)  //15
            {
                ss = .Good
            }
            else
            {
                ss = .Full
            }
            if (ss != .NoSignal){
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
            if (bestLoc?.signalStrength != .Poor && bestLoc?.signalStrength != .NoSignal && bestLoc?.signalStrength != .Average){
                speedBuffer.add((currentLocation?.location.speed)!)
                lastGoodLocation = bestLoc
            }            
            locationChanged(manager, didUpdateLocations: locations)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print ("didFailWithError: \(CLError(rawValue: error.code))")
        if error.code == CLError.Denied.rawValue {
            stopUpdatingLocation()
        }
        
    }
    func locationChanged(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){    }

    func annotationDetailsClicked(annotation: MKAnnotationView){}
    func annotationInfoClicked(annotation: MKAnnotationView){}
    
    private let regionRadius: CLLocationDistance = 800
    private var centerMapOnLocationWorking: Bool = false
    func centerMapOnLocation(location: CLLocation, zoom: Bool = false) {
        if !centerMapOnLocationWorking {
            centerMapOnLocationWorking = true
            defer{
                centerMapOnLocationWorking = false
            }
            let coordinateRegion = (zoom == true ? MKCoordinateRegionMakeWithDistance(location.coordinate, self.regionRadius * 2.0, self.regionRadius * 2.0): MKCoordinateRegionMake(location.coordinate, self.map.region.span))
            self.map.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func turnonNavigation(locationName: String, coordinate: CLLocationCoordinate2D){
        
        let place = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem (placemark: place)
        
        mapItem.name = locationName
        
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: true]
        MKMapItem.openMapsWithItems([mapItem], launchOptions: options as? [String : AnyObject])
        
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