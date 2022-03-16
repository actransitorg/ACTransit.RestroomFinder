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


class MapViewController: MapBaseViewController, UITableViewDataSource, UITableViewDelegate, CustomTableViewCellDelegate, MapInfoHelperViewDelegate, ActionSheetClickDelegate, AddRestroomViewControllerDelegate, FeedbackViewControllerDelegate {

    
    @IBOutlet var currentView: UIView!
    @IBOutlet var map: MKMapView!
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var btnShow: UIButton!
    
    @IBOutlet var btnSignal: UIButton!
    @IBOutlet var btnCompass: UIButton!
    @IBOutlet var btnMapInfo: UIButton!
    
    @IBOutlet var txtMapInfoHelperDummy: UITextField!
    @IBOutlet var mapInfoHelperViewDummy: MapInfoHelperView!
    
    @IBOutlet var txtActionSheetHelperDummy: UITextField!
    @IBOutlet var actionSheetViewDummy: ActionSheet!
    
    @IBOutlet var lblSpeed: UILabel!
    @IBOutlet var viewDummyForlblSpeed: UIView!

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblBadge: UILabel!
    @IBOutlet var darkLayer: UIVisualEffectView!
    @IBOutlet weak var darkLayerView: UIView!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuTrailing: NSLayoutConstraint!
    @IBOutlet weak var menuLeading: NSLayoutConstraint!
    @IBAction func FilterClicked(_ sender: UIButton) {
        filterClicked();
    }
    @IBAction func LogoutClicked(_ sender: Any) {
        self.showHideMenu(show: false)
        darkLayer.isHidden = true
        _=messageBox("Sign out", message: "Are you sure?", prefferedStyle: UIAlertControllerStyle.alert, cancelButton: true, oKButton: true, openSettingButton: false) {(action: UIAlertAction) in
            if (action.title == Constants.Variables.actionAlert_OK){
                do {
                    try AppStorage.logOut()
                }
                catch{
                    print(error)
                }
            }
        }
    }
    
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
    var menuVisible : Bool = false;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        txtMapInfoHelperDummy = UITextField(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
        mapInfoHelperViewDummy = MapInfoHelperView(frame: CGRect(x: 0,y: 0,width: 0,height: 200))
        txtActionSheetHelperDummy = UITextField(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
        let asHeight = Common.canEditRestroom() ? 80 : 50;
        actionSheetViewDummy = ActionSheet(frame: CGRect(x: 0,y: 0,width: 0,height: asHeight))

        lblSpeed = UILabel(frame: CGRect(x: 0,y: 0,width: 30,height: 30))
        viewDummyForlblSpeed = UIView(frame: CGRect(x: 10,y: 0,width: 30,height: 30))
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ("viewDidLoad")
        //super.setNavigationBar(true, backgroundColor: UIColor.clear)
        super.setNavigationBar(false, backgroundColor: UIColor.clear)
        super.setNavigationButtons(true, hideOK: true, hideCancel: true, hideFilter: true, showMenu: true)
        
        showHideMenu (show: false)
        
 
        //self.setBackgroundGradient();
        self.navigationItem.title="Restrooms"

                        
        initialLocationManager(map)
        if #available(iOS 9.0, *) {
            map.showsTraffic = false
        }
        let longpress=UILongPressGestureRecognizer(target: self, action: #selector(mapLongPress(longGesture:)))
        longpress.minimumPressDuration = 2.0
        //IOS 9
        map.addGestureRecognizer(longpress)
        
        
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
        
         self.actionSheetViewDummy.delegate = self
         self.view.addSubview(self.txtActionSheetHelperDummy)
         self.txtActionSheetHelperDummy.inputView=self.actionSheetViewDummy
    
        
        
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
        
        Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { (Timer) in
            self.refreshData()
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive(notification:)),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)

        //NOTE: Commented this line out for demo as per Manjit -- Demo should only show single spot -- spoofed to be General Office
        //timer=NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "timerUpdate", userInfo: nil, repeats: true)
//        if isDemo {
//            timerDemo=NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "timerDemoUpdate", userInfo: nil, repeats: true)
//        }
        
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
         checkForUpdate { (updateAvailable, version) in
                   if (updateAvailable){
                       self.update(version!, fail: {
                            exit(0)
                       })
                   }
               }
    }
    
   
    @objc func mapLongPress(longGesture:UIGestureRecognizer){
        if longGesture.state == UIGestureRecognizerState.began {
            let touchPoint = longGesture.location(in: map)
            let wayCoords = map.convert(touchPoint, toCoordinateFrom: map)
            let location = CLLocation(latitude: wayCoords.latitude, longitude: wayCoords.longitude)
            self.addRestroom(location: location)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.setControlLocations(self.table.isHidden)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.setNavigationBar(false, backgroundColor: UIColor.clear)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "MapView")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as? [AnyHashable: Any])
        
       
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
    
    @IBAction func refreshClicked(_ sender: Any) {
        showHideMenu(show: false)
        darkLayer.isHidden = true
        refreshData()
    }
    override func filterClicked() {
        showHideMenu(show: false)
        darkLayer.isHidden = true
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
    
  
    override func menuClicked() {
        showHideMenu(show: !menuVisible)
        
        darkLayer.isHidden = !menuVisible
       
    }
    
    func showHideMenu(show: Bool){
        print("ShowHideMenu called.")
        if (show){
            print ("Show!!")
            lblBadge.text = AppStorage.firstName + " " + AppStorage.lastName
            menuTrailing.constant = 0;
            menuLeading.constant = 150;
            menuVisible = true;
            self.menuView.isHidden = false
           
        }else{
            print ("Hide!")
            menuTrailing.constant = -150;
            menuLeading.constant =  self.view.frame.size.width + 1
            menuVisible = false;
        }
        
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationCompleted) in
            self.menuView.isHidden = !show
        }
    }
    
    @objc func resignResponder(){
        lastSelectedCell?.isSelected = false
        txtMapInfoHelperDummy.resignFirstResponder()
        txtActionSheetHelperDummy.resignFirstResponder()
        actionSheetViewDummy.representingObject = nil;
        darkLayer.isHidden = true
        showHideMenu(show: false)
    }
    
    @IBAction func btnMapInfoClicked(_ sender: UIButton) {
        var height=160;
        if (Common.canAddRestroom()){
            height = 200
        }
        darkLayer.isHidden = false
        self.mapInfoHelperViewDummy.frame.size.height = CGFloat(height)
        
        
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
        map.showsPointsOfInterest = configuration.Poi
        resignResponder()
        if (configuration.AddRestroomClicked){
            if (currentLocation != nil && currentLocation?.location != nil){
                self.addRestroom(location: self.currentLocation!.location)
            }
        }
    }
    func actionSheetClick(_ sender: UIButton, action: ActionSheetButton) {
        txtActionSheetHelperDummy.resignFirstResponder()
        darkLayer.isHidden = true
        switch action {
        case .Edit:
            let restroom = actionSheetViewDummy.representingObject as! RestStopModel
            addRestroom(location: restroom.location, restroom: restroom, isEdit: true)
        case .Feedback:
            navigateToFeedback(actionSheetViewDummy.representingObject as! RestStopModel)
        //default:
          //  navigateToFeedback(actionSheetViewDummy.representingObject as! RestStopModel)
        }

        
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
                //btnCompass.titleLabel?.font=UIFont(name: "FontAwesome", size: 21)
                //btnCompass.setTitle("", for: .normal)
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
            var h = frame.height * 0.4;
            if (h < 100){
                h = 100
            }
            
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
        self.showWait(self.activityIndicator){
             super.server.getRestrooms(self.getSelectedRouteTitle(), location: (self.currentLocation?.location)!, isPublic: false, callBack: {(jsonResult:[RestStopModel], error:NSError!) -> Void in
                 DispatchQueue.main.async(execute: {
                     defer{
                         if (error != nil){
                            self.restroomsLoaded = false
                            _ = self.messageBox("Error", message: error.localizedDescription, prefferedStyle: UIAlertControllerStyle.alert, cancelButton: false,    oKButton: true, openSettingButton: false) { (UIAlertAction) in
                            }
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
        //                                coordinate: CLLocationCoordinate2D(latitude: rest.Latitude, longitude: rest.Longitude),
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
                let distance1 = (restStop1.distanceFromLocation == -1 ? currentLocation?.location.distance(from: CLLocation(latitude: restStop1.latitude, longitude: restStop1.longitude)):restStop1.distanceFromLocation )
                let distance2 = (restStop2.distanceFromLocation == -1 ? currentLocation?.location.distance(from: CLLocation(latitude: restStop2.latitude, longitude: restStop2.longitude)):restStop2.distanceFromLocation )
                restStop1.distanceFromLocation = distance1!
                restStop2.distanceFromLocation = distance2!
                return distance1 < distance2
            })
        }
        
        for rest in dataFiltered
        {
            Threading.sync(self.dataSource as AnyObject){
                if (Common.canAddRestroom() || rest.approved){
                    self.dataSource.append(rest)
                }
            }
            var address=""
            if (rest.address != nil) { address = rest.address }
            let ann = RestroomAnnotation(title: rest.name,
                locationName: "\(address)",
                discipline: "",
                coordinate: CLLocationCoordinate2D(latitude: rest.latitude, longitude: rest.longitude),
                drinkingWater: rest.drinkingWater,
                weekdayHours: rest.weekdayHours,
                saturdayHours: rest.saturdayHours,
                sundayHours: rest.sundayHours,
                note: rest.note,
                approved: rest.approved)
            ann.id = rest.id
            
            if (Common.canAddRestroom() || rest.approved){
                self.map.addAnnotation(ann)
            }            
            
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
                showActionSheet(representingObject: dataSource[i])
                break;
            }
        }
    }
    override func annotationInfoClicked(_ annotation: MKAnnotationView) {
        let ann: RestroomAnnotation! = annotation.annotation as? RestroomAnnotation
        if (ann != nil && (ann.weekdayHours != "" || ann.saturdayHours != "" || ann.sundayHours != "" || ann.note != "")){
            
            var text = DateTime.isWeekday ?  ann.weekdayHours : (DateTime.isSaturday ? ann.saturdayHours : ann.sundayHours)
            if (ann.note != ""){
                if (text != "") {text = text + "\r\n"}
                text = text + ann.note
            }
            
            _=messageBox("Info", message: text, prefferedStyle: .actionSheet, cancelButton: false, oKButton: true, openSettingButton: false, done: nil)
        }
        //turnonNavigation(ann.locationName, coordinate: ann.coordinate)
    }
    override func pinClicked(_ annotation: MKAnnotationView) {
        if (annotation.annotation != nil && annotation.annotation!.isKind(of: RestroomAnnotation.self)){
            let ann = annotation.annotation as! RestroomAnnotation
            let restroomId = ann.id
            var index = -1
            
            
            for i in 0..<dataSource.count {
                if ((dataSource[i] as RestStopModel).id == restroomId){
                    index = i
                    break
                }
            }
            if (index != -1){
                let indexPath = IndexPath(row: index, section: 0)
                table.scrollToRow(at: indexPath, at: .middle, animated: false)
                let cellRaw = table.cellForRow(at: indexPath)
                if (cellRaw != nil && cellRaw!.isKind(of: CustomTableViewCell.self)){
                    let cell = cellRaw as! CustomTableViewCell
                    self.lastSelectedCell?.isSelected = false
                    self.lastSelectedCell = cell
                    
                    
                    cell.isSelected = true
                    
                }
               
                
                
             
                
                //table.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .middle)
                
            }
         
        }
        
    }
    
    @objc func checkDisclaimer() {
        if (!checkingDisclaimer){
            checkingDisclaimer = true
            if (AppStorage.shouldPopupDisclaimer()){
                _=messageBox("Warning", message: Constants.Messages.dailyDisclaimerText, prefferedStyle: .alert, cancelButton: false, oKButton: true, openSettingButton: false, done:{(action) in
                    defer{
                        self.checkingDisclaimer = false
                    }
                    try? AppStorage.setPopupDisclaimer()
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
            let ann=self.restrooms.filter { (restroomAnnotation) -> Bool in
                return restroomAnnotation.id == rest.id
            }[0] as RestroomAnnotation
            //let ann=self.restrooms[indexPath.row] as RestroomAnnotation
            self.centerMapOnLocation(CLLocation(latitude: ann.coordinate.latitude, longitude: ann.coordinate.longitude))
            ann.sourceAction = AnnotationSourceActionEnum.ListClicked
            self.map.selectAnnotation(ann, animated: true)

        }
        
        let name = "\(rest.name)\(rest.approved ? "" : " (under review)")"
        cell.load(name,labelId: rest.labelId, inspectionPassed: nil, rate: rest.averageRating, extraInfo: "\(Speed.distanceToMile(rest.distanceFromLocation)) mi",potableWater: rest.drinkingWater, isHistory: rest.isHistory, isToiletAvailable: rest.isToiletAvailable, pendingApproval: !rest.approved)

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
        
        showActionSheet(representingObject: cell.customTag)
//        navigateToFeedback(cell.customTag as! RestStopModel)
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
    
    func showActionSheet(representingObject: Any){
        actionSheetViewDummy.representingObject = representingObject;
        darkLayer.isHidden = false
        txtActionSheetHelperDummy.becomeFirstResponder()
    }
    
    func onFeedbackViewControllerDone(_ action: ActionEnum, data: Any?) {
        if (action != .cancel){
            refreshData()
        }
    }
    
    func onRestroomViewControllerDone(_ action: ActionEnum, data: Any?) {
        if (action != .cancel){
            refreshData()
        }
    }
    
    func navigateToFeedback(_ restStopModel: RestStopModel){
        _=super.NavigateTo("Feedback", asModal: false, captureBackgroundImage: false,
            beforeShow: { (controller: UIViewController) -> Void in
                let c = controller as! FeedbackViewController
                c.currentRestroom = restStopModel
                c.delegate = self
            }
            ,modalCompletion: nil
//            ,modalCompletion: { (controller: UIViewController) -> Void in
//                let c = controller as! FeedbackViewController
//                //c.currentRestroom = cell.customTag as! RestStopModel
//                c.onClose = Event<ActionEnum>()
//                c.onClose?.addHandler({action in
//                    if (action == .ok){
//                        self.refreshData()
//                    }
//                })
//            }
        )        
    }
    
    
    func addRestroom(location: CLLocation, restroom: RestStopModel? = nil, isEdit: Bool = false){
        if (!Common.canAddRestroom()) {
            return
        }
        _ = NavigateTo("AddRestroom", asModal: false, captureBackgroundImage: false, beforeShow: { (UIViewController) in
            let controller:AddRestroomViewController = UIViewController as! AddRestroomViewController
            controller.location = location
            controller.isEdit = isEdit
            controller.restroom = restroom
            controller.delegate = self
        }, modalCompletion: nil)
//        }) { (controller) in
//            let c = controller as! AddRestroomViewController
//            c.onClose = Event<ActionEnum>()
//            c.onClose?.addHandler({action in
//                if (action == .ok){
//                    self.refreshData()
//                }
//            })
//        }
    }
    
}
