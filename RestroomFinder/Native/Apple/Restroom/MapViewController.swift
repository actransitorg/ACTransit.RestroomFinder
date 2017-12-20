//
//  ViewController.swift
//  Restroom
//
//  Created by DevTeam on 12/17/15.
//  Copyright © 2015 DevTeam. All rights reserved.
//

import UIKit
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
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class MapViewController: MapBaseViewController, UITableViewDataSource, UITableViewDelegate, CustomTableViewCellDelegate, MapInfoHelperViewDelegate {

    @IBOutlet var currentView: UIView!
    @IBOutlet var map: MKMapView!
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var btnShow: UIButton!
    
    @IBOutlet var btnSignal: UIButton!
    @IBOutlet var btnCompass: UIButton!
    @IBOutlet var btnMapInfo: UIButton!
    
    @IBOutlet var txtMapInfoHelperDummy: UITextField!
    @IBOutlet var mapInfoHelperViewDummy: MapInfoHelperView!
    @IBOutlet var lblSpeed: UILabel!
    @IBOutlet var viewDummyForlblSpeed: UIView!

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var darkLayer: UIVisualEffectView!
    
    var dataSource=[RestStopModel]()
    var restrooms = [RestroomAnnotation]()
    
    var badge:String!
    

    var timer:Timer!
    var timerDemo:Timer!
    var currentLocationAnnotation:LocationAnnotation!

    
    var lastFeedback : FeedbackModel!
//    var isDemo=false
    
    //NOTE: New properties to handle the changes.  "currentRoute" and "currentTripId" should probably be removed and only check the Operator.CurrentRoute property.  PrevRoute important for checking changes.
    var routePath : MKPolyline = MKPolyline()
    var currentRoute:ComboViewItem!
    var currentRouteIndex:Int = 0
    var portableWaterOnly : Bool = false
    var listOpen: Bool = true
    
    var lastSelectedCell : CustomTableViewCell!
    
    var restroomsLoaded: Bool = false
    //var prevRoute = "0"
    //var currentTripId = 4370969 //Route 1 Northbound trip: 9:05 AM
    
    var checkingDisclaimer: Bool = false
    //var signalStrength: SignalStrengthEnum = SignalStrengthEnum.NoSignal
    
    var movingController : UIAlertController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        txtMapInfoHelperDummy = UITextField(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
        mapInfoHelperViewDummy = MapInfoHelperView(frame: CGRect(x: 0,y: 0,width: 0,height: 200))
        lblSpeed = UILabel(frame: CGRect(x: 0,y: 0,width: 30,height: 30))
        viewDummyForlblSpeed = UIView(frame: CGRect(x: 10,y: 0,width: 30,height: 30))
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ("viewDidLoad")
        //super.setNavigationBar(true, backgroundColor: UIColor.clear)
        super.setNavigationBar(false, backgroundColor: UIColor.clear)
        super.setNavigationButtons(true, hideOK: true, hideCancel: true, hideFilter: false)
        //self.setBackgroundGradient();
        self.navigationItem.title="Restrooms"

                        
        initialLocationManager(map)
        if #available(iOS 9.0, *) {
            map.showsTraffic = false
        }
        
        table.dataSource=self
        table.delegate=self
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "customCell")
        
        
        btnShow.layer.borderWidth=0.5
        btnShow.layer.borderColor = UIColor.gray.cgColor
        // Do any additional setup after loading the view, typically from a nib.
        
        let layer = GradientColor(colorLocations: GradientColor.style2).gl
        layer.frame = btnSignal.layer.bounds
        layer.cornerRadius = 25
        btnSignal.layer.addSublayer(layer)
        btnSignal.isHidden = true

        
        
        lblSpeed.textColor = UIColor.white
        lblSpeed.textAlignment = .center
        lblSpeed.text = "0"
        let layer1 = GradientColor(colorLocations: GradientColor.style2).gl
        layer1.frame = lblSpeed.layer.bounds
        layer1.cornerRadius = 15
        viewDummyForlblSpeed.isHidden = Constants.Variables.hideSpeedIndicator || true
        viewDummyForlblSpeed.layer.addSublayer(layer1)
        viewDummyForlblSpeed.addSubview(lblSpeed)
        self.view.addSubview(viewDummyForlblSpeed)
        self.setControlLocations(self.table.isHidden)
        
//
////        lblSpeed.hidden = false



        self.mapInfoHelperViewDummy.delegate = self
        self.view.addSubview(self.txtMapInfoHelperDummy)
        self.txtMapInfoHelperDummy.inputView=self.mapInfoHelperViewDummy
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapViewController.resignResponder))
        self.view.addGestureRecognizer(tap)
        
        
        //Trying to get the data 1 second later if it already hasn't
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MapViewController.timerUpdate), userInfo: nil, repeats: false)
        
        //In case the application had connection issues, this timer try to get the list of restrooms every 30 seconds if it hasn't had them.
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(MapViewController.timerUpdate), userInfo: nil, repeats: true)
        
        //Run it for the first time. then check it every ten minutes.
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(MapViewController.checkDisclaimer), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: 600, target: self, selector: #selector(MapViewController.checkDisclaimer), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(MapViewController.showSpeed), userInfo: nil, repeats: true)
        
        //NOTE: Commented this line out for demo as per Manjit -- Demo should only show single spot -- spoofed to be General Office
        //timer=NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "timerUpdate", userInfo: nil, repeats: true)
//        if isDemo {
//            timerDemo=NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "timerDemoUpdate", userInfo: nil, repeats: true)
//        }
        
    }
    
   
    override func viewDidLayoutSubviews() {
        self.setControlLocations(self.table.isHidden)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "MapView")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as! [AnyHashable: Any])
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        compassState = 0
    }
    
    var insideTimer=false
    @objc func timerUpdate(){
        if insideTimer {return}
        insideTimer=true;
        
        if !self.restroomsLoaded {
            let currentLocationNull=currentLocation==nil
            let prevLocationNull=prevLocation==nil
            let latsEqual=currentLocation?.location.coordinate.latitude==prevLocation?.location.coordinate.latitude
            let longEqual=currentLocation?.location.coordinate.longitude==prevLocation?.location.coordinate.longitude
            
            if !self.restroomsLoaded && !currentLocationNull && (prevLocationNull || !latsEqual || !longEqual){
                setLocation()
                refreshData()
            }
        }
        self.insideTimer=false
    }

   
    @IBAction func btnSignalClicked(_ sender: AnyObject) {
        var message: String = Constants.Messages.noGPSReception
        if (currentLocation?.signalStrength == .poor){
            message = Constants.Messages.poorGPSReception
        }
        _=messageBox("Warning", message: message, prefferedStyle: .alert, cancelButton: false, oKButton: true, openSettingButton: false, done: nil)
        
    }

    @IBAction func btnCompassClicked(_ sender: UIButton) {
        switch self.compassState {
        case 1:
            compassState = 2
        case 2:
            compassState = 0
        default:
            compassState = 1
        }
    }
    
    @IBAction func showListClicked(_ sender: UIButton) {
        toggleList()
    }
    
    override func filterClicked() {
        _=super.NavigateTo("FilterView", asModal: true, captureBackgroundImage: true, modalCompletion: { (controller: UIViewController) -> Void in
            let c = controller as! FilterViewController
            c.selectedIndex=self.currentRouteIndex
            c.portableWaterOnly = self.portableWaterOnly
            c.onClose = Event<ActionEnum>()
            c.onClose?.addHandler({action in
                if (action == .ok){
                    let item = c.getSelectedRoute()
                    let refresh = (self.portableWaterOnly != c.portableWaterOnly) || (self.currentRouteIndex != c.selectedIndex)
                    self.currentRouteIndex=c.selectedIndex
                    self.portableWaterOnly = c.portableWaterOnly
                    if (item != nil){
                        self.currentRoute = item
                    }
                    if (refresh){
                        self.refreshData()
                    }
                }
            })            
        })
    }
    
    @objc func resignResponder(){
        lastSelectedCell?.isSelected = false
        txtMapInfoHelperDummy.resignFirstResponder()
        darkLayer.isHidden = true
    }
    
    @IBAction func btnMapInfoClicked(_ sender: UIButton) {
        darkLayer.isHidden = false
        self.mapInfoHelperViewDummy.frame.size.height = 120
        if #available(iOS 9.0, *) {
            self.mapInfoHelperViewDummy.showTraffic = map.showsTraffic
        }
        btnMapInfo.resignFirstResponder()
        txtMapInfoHelperDummy.becomeFirstResponder()

    }
    
    func mapInfoHelperView(_ configuration: MapInfoData) {
        if #available(iOS 9.0, *) {
            map.showsTraffic = configuration.showTraffic
        } else {
            // Fallback on earlier versions
        }
        if (configuration.Is2D != is2D){
            is2D = configuration.Is2D
        }
        map.mapType = configuration.MapType
        resignResponder()
    }
    
    var is2D: Bool {
        get{
            return map.camera.pitch == 0
        }
        set(value){
            let pitch = value ? 0 : 45
            let camera=MKMapCamera(lookingAtCenter: map.camera.centerCoordinate, fromEyeCoordinate: map.camera.centerCoordinate, eyeAltitude: map.camera.altitude)
            camera.pitch = CGFloat(pitch)
            map.setCamera(camera, animated: true)
        }
    }

    fileprivate func setLocation(){
        setLocation(false)
    }
    fileprivate func setLocation(_ forceZoom: Bool){
        centerMapOnLocation((currentLocation?.location)!, zoom: !self.restroomsLoaded || forceZoom)
    }
    
    func toggleList(){
        setListSize()
        if (listOpen){
            listOpen = false
        }else{
            listOpen = true
        }
        
    }

    var compassState: Int {
        get{
            return _compassState
        }
        set(value){
            switch value {
            case 1:
                _compassState = 1
                startUpdatingLocation()
                let img:UIImage=UIImage(imageLiteralResourceName: "MapArrowHeadSelected")
                btnCompass.setImage(img, for: UIControlState())
                btnCompass.isHighlighted = true
                btnCompass.isSelected = false
                map.setUserTrackingMode(.follow, animated: true)
            case 2:
                _compassState = 2
                startUpdatingLocation()
                if (CLLocationManager.headingAvailable()){
                    locationManager.headingFilter = 2
                    locationManager.startUpdatingHeading()
                }
                btnCompass.isHighlighted = false
                btnCompass.isSelected = true
                map.setUserTrackingMode(.followWithHeading, animated: true)
            default:
                let centerMap = (_compassState != 0)
                _compassState = 0
                if (CLLocationManager.headingAvailable()){
                    locationManager.stopUpdatingHeading()
                }
                if (centerMap){
                    map.setUserTrackingMode(.none, animated: true)
                    //setLocation(false)
                }
                btnCompass.setImage(UIImage(imageLiteralResourceName: "MapArrowHeadNormal"), for: UIControlState())
                btnCompass.isHighlighted = false
                btnCompass.isSelected = false
            }
            
        }
    }         
    func setListSize(){
        let timeout = 0.5
        let frame=self.currentView.frame
        // Due to an issue with buton.setTitle which causes UI to redraw and thus, the table will be setback to the original state that is defined in the designer
        // I use the hidden property after animation to hide it and set the frame locations to hidden before show it again.
        if (listOpen){
            UIView.animate(withDuration: timeout, animations: {()-> Void in
                self.setControlLocations(false)
                self.btnSignal.frame.origin.y = self.btnShow.frame.origin.y - 60
                self.viewDummyForlblSpeed.frame.origin.y = self.btnShow.frame.origin.y - 60
                self.table.frame.origin.y = self.btnShow.frame.origin.y + 30
                }, completion: {(complete: Bool) -> Void in
                    self.table.isHidden = true
                    self.btnShow.setTitle("Show List", for: UIControlState())
            })

        }else{
            var h = frame.height * 0.4;
            if (h < 100){
                h = 100
            }
            self.table.frame.size.height = 0
            self.table.frame.origin.y = self.btnShow.frame.origin.y + 30
            self.table.isHidden = false
            UIView.animate(withDuration: timeout, animations: {()-> Void in
                    self.setControlLocations(true)
                    self.btnSignal.frame.origin.y = self.btnShow.frame.origin.y - h - 60
                    self.viewDummyForlblSpeed.frame.origin.y = self.btnShow.frame.origin.y - h - 60
                    self.table.frame.size.height = h
                    self.table.frame.origin.y = self.btnShow.frame.origin.y  - h
                
                }, completion: {(complete: Bool) -> Void in
                    self.btnShow.setTitle("Hide List", for: UIControlState())
            })
            
        }
    }
    
    func setControlLocations(_ tableHidden: Bool){
        var y = self.btnShow.frame.origin.y
        if (tableHidden){
            y -= 60
        }
        else{
            let frame=self.currentView.frame
            var h = frame.height * 0.4;
            if (h < 100){
                h = 100
            }
            y = y - h - 60
        }
        self.btnSignal.frame.origin.y = y
        self.viewDummyForlblSpeed.frame.origin.y = y
    }
    
    func refreshData(){
        self.restroomsLoaded = true
        showWait(activityIndicator){
            super.server.getRestStops(self.getSelectedRouteTitle(), location: (self.currentLocation?.location)!, callBack: {(jsonResult:[RestStopModel], error:NSError!) -> Void in
                DispatchQueue.main.async(execute: {
                    defer{
                        if (error != nil){
                            self.restroomsLoaded = false
                        }
                        self.insideTimer = false
                    }
                    Cache.add("Restrooms", value: jsonResult as NSObject)
                    self.loadData(jsonResult)
                })
                print(jsonResult.count)
            })
        }
        //NOTE: Manjit wants this to default to the General Office for the demo and picking a route close by (1), I've commented this out and added a new block below
        
        /*
        NOTE: This code is currently retrieving hardcoded info:  Position General Office, Route 1, Trip 4370969
        
        Part of this code should be brought into the real code at some point:
        1) Does not re-render restrooms if the route hasn't changed.
        2) Displays the trip pattern when the route changes.
        */
        //            server.getRestroomsAroundGeneralOffice({(jsonResult:[RestStopModel], error:NSError!) -> Void in
        //                dispatch_async(dispatch_get_main_queue(), {
        //                    defer{
        //                        self.insideTimer=false
        //                    }
        //
        //                    if(self.prevRoute != self.currentRoute) {
        //                        self.DisplayRouteOnMap(self.currentRoute, tripId: self.currentTripId) //Hardcoded trip id (Route 1) since demo is currently hardcoded per Manjit.
        //                        //Only remove/add restrooms if the route has changed.
        //                        self.map.removeAnnotations(self.restrooms)
        //                        self.restrooms.removeAll()
        //                        self.dataSource.removeAll()
        //                        for rest in jsonResult
        //                        {
        //                            self.dataSource.append(rest)
        //                            let ann = RestroomAnnotation(title: rest.Name,
        //                                //locationName: "\(rest.Address), water:\(rest.DrinkingWater), \r\n hours:\(rest.PaddleHours)",
        //                                locationName: "\(rest.Address)",
        //                                discipline: "Sculpture",
        //                                coordinate: CLLocationCoordinate2D(latitude: rest.Latitude, longitude: rest.Longtitude),
        //                                drinkingWater: rest.DrinkingWater)
        //
        //                            //((MKPinAnnotationView)ann).
        //                            self.map.addAnnotation(ann)
        //                            self.restrooms.append(ann)
        //                        }
        //                        self.table.reloadData()
        //                    }
        //
        //                    //NOTE: This code is likely better off when we retrieve operator info, the check should still take place here.
        //                    self.prevRoute = self.currentRoute
        //                })
        //                print(jsonResult.count)
        //            })
    }

    func reloadData(){
        let data = Cache.item("Restrooms") as! [RestStopModel]?
        if (data != nil) {
            loadData(data!)
        }
    }
    func loadData(_ data: [RestStopModel]){
        lastLocationDataLoaded = currentLocation
        self.map.removeAnnotations(self.restrooms)
        Threading.sync(self.restrooms as AnyObject){
            self.restrooms.removeAll()
        }
        Threading.sync(self.dataSource as AnyObject){
            self.dataSource.removeAll()
        }
        var dataFiltered = data.filter({(restStop) -> Bool in
            restStop.distanceFromLocation = -1
            let waterCondition = (self.portableWaterOnly == false || restStop.drinkingWater == true)
            return waterCondition
        })
        if (currentLocation != nil){
            dataFiltered.sort(by: {(restStop1, restStop2) in
                let distance1 = (restStop1.distanceFromLocation == -1 ? currentLocation?.location.distance(from: CLLocation(latitude: restStop1.latitude, longitude: restStop1.longtitude)):restStop1.distanceFromLocation )
                let distance2 = (restStop2.distanceFromLocation == -1 ? currentLocation?.location.distance(from: CLLocation(latitude: restStop2.latitude, longitude: restStop2.longtitude)):restStop2.distanceFromLocation )
                restStop1.distanceFromLocation = distance1!
                restStop2.distanceFromLocation = distance2!
                return distance1 < distance2
            })
        }
        
        for rest in dataFiltered
        {
            Threading.sync(self.dataSource as AnyObject){
                self.dataSource.append(rest)
            }
            
            let ann = RestroomAnnotation(title: rest.name,
                locationName: "\(rest.address)",
                discipline: "",
                coordinate: CLLocationCoordinate2D(latitude: rest.latitude, longitude: rest.longtitude),
                drinkingWater: rest.drinkingWater,
                hours: rest.hours)
            ann.id = rest.id
            
            self.map.addAnnotation(ann)
            
            Threading.sync(self.dataSource as AnyObject){
                self.restrooms.append(ann)
            }
        }
        self.table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func locationChanged(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (currentLocation != nil && lastLocationDataLoaded != nil){
            let changed = currentLocation?.location.distance(from: (lastLocationDataLoaded?.location)!)
            if (changed >= 160){
                self.reloadData()
            }
        }
        Threading.sync(self.dataSource as AnyObject){
            if (!self.restroomsLoaded){
                self.setLocation()
                self.refreshData()
            }
        }
    }
    
    override func annotationDetailsClicked(_ annotation: MKAnnotationView) {
        let ann: RestroomAnnotation = annotation.annotation as! RestroomAnnotation

        for i in 0 ..< dataSource.count {
            if (dataSource[i].id == ann.id){
                navigateToFeedback(dataSource[i])
                break;
            }
        }
    }
    override func annotationInfoClicked(_ annotation: MKAnnotationView) {
        let ann: RestroomAnnotation! = annotation.annotation as! RestroomAnnotation
        if (ann != nil && ann.hours != ""){
            _=messageBox("Info", message: ann.hours, prefferedStyle: .actionSheet, cancelButton: false, oKButton: true, openSettingButton: false, done: nil)
        }
        //turnonNavigation(ann.locationName, coordinate: ann.coordinate)
    }
    
    @objc func checkDisclaimer(){
        if (!checkingDisclaimer){
            checkingDisclaimer = true
            if (AppStorage.shouldPopupDisclaimer()){
                _=messageBox("Warning", message: Constants.Messages.dailyDisclaimerText, prefferedStyle: .alert, cancelButton: false, oKButton: true, openSettingButton: false, done:{(action) in
                    defer{
                        self.checkingDisclaimer = false
                    }
                    AppStorage.setPopupDisclaimer()
                })
            }
        }
    }
    
    @objc func showSpeed(){
        var speed = 0
        let hide :Bool =  lastGoodLocation == nil || (lastGoodLocation?.recievedTime.subtract(DateTime.now(), calendarUnit: .second).second)! > 3
        if (!hide){
            speed = Speed.meterPesSecondToMPH(speedBuffer.average)
//            speed = Speed.meterPesSecondToMPH((lastGoodLocation?.location.speed)!)
        }

        if speed > Constants.Variables.applicationDisableSpeed {
            darkLayer.isHidden = false
            movingController = messageBox("Stop", message: Constants.Messages.drivingDisclaimerText, prefferedStyle: .actionSheet, cancelButton: false, oKButton: false, openSettingButton: false, done: nil)
        }
        else if (speed <= Constants.Variables.applicationDisableSpeed && movingController != nil){
            Threading.runInMainThread{
                self.dismiss(animated: true, completion: { () in
                    self.darkLayer.isHidden = true
                    })
                //self.dismissWithClickedButtonIndex(-1, animated: true)
                self.movingController = nil
            }
        }
        if (hide || speed <= 0 ) {
            speedBuffer.clear()
            viewDummyForlblSpeed.isHidden = Constants.Variables.hideSpeedIndicator || true
            return
        }
        
        lblSpeed.text = String(speed)
        viewDummyForlblSpeed.isHidden = Constants.Variables.hideSpeedIndicator || false

    }
    
         
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomTableViewCell = self.table.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        cell.customDelegate = self
        let rest=dataSource[indexPath.row] as RestStopModel
        cell.tag = indexPath.row
        cell.customTag = rest
        cell.onTapped = {
            self.lastSelectedCell?.isSelected = false
            self.lastSelectedCell = cell
            cell.isSelected = true
            let ann=self.restrooms[indexPath.row] as RestroomAnnotation
            self.centerMapOnLocation(CLLocation(latitude: ann.coordinate.latitude, longitude: ann.coordinate.longitude))
            self.map.selectAnnotation(ann, animated: true)

        }

        cell.load("\(rest.name)", rate: rest.averageRating, extraInfo: "\(Speed.distanceToMile(rest.distanceFromLocation)) mi",potableWater: rest.drinkingWater)

        return cell
    }
    
    func CustomTableViewCellEditClicked(_ cell: CustomTableViewCell) {
        //messageBox("test", message: "this is a test", prefferedStyle: .Alert, cancelButton: true, oKButton: true, openSettingButton: false)
        lastSelectedCell?.isSelected = false
        if (lastSelectedCell != nil){
            
            let index = cell.tag
            print (index)
            let ann=self.restrooms[index] as RestroomAnnotation
            self.map.deselectAnnotation(ann, animated: true)
            centerMapOnLocation(CLLocation(latitude: ann.coordinate.latitude, longitude: ann.coordinate.longitude))
            
        }

        cell.isSelected = false
        navigateToFeedback(cell.customTag as! RestStopModel)
    }
    
    //NOTE: Updated title to display route info.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Restrooms for Route \(self.getSelectedRouteTitle())"
    }
    
    func getSelectedRouteTitle() -> String{
        var route="All"
        if (self.currentRoute != nil){
            route=self.currentRoute.Title
        }
        return route
        
    }
    
    func navigateToFeedback(_ restStopModel: RestStopModel){
        _=super.NavigateTo("Feedback", asModal: true, captureBackgroundImage: true,
            beforeShow: { (controller: UIViewController) -> Void in
                let c = controller as! FeedbackViewController
                c.currentRestroom = restStopModel
            }
            ,modalCompletion: { (controller: UIViewController) -> Void in
                let c = controller as! FeedbackViewController
                //c.currentRestroom = cell.customTag as! RestStopModel
                c.onClose = Event<ActionEnum>()
                c.onClose?.addHandler({action in
                    if (action == .ok){
                        self.refreshData()
                    }
                })
            }
        )        
    }
    
}
