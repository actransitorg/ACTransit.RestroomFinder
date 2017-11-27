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
    

    var timer:NSTimer!
    var timerDemo:NSTimer!
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
        txtMapInfoHelperDummy = UITextField(frame: CGRectMake(0,0,0,0))
        mapInfoHelperViewDummy = MapInfoHelperView(frame: CGRectMake(0,0,0,200))
        lblSpeed = UILabel(frame: CGRectMake(0,0,30,30))
        viewDummyForlblSpeed = UIView(frame: CGRectMake(10,0,30,30))
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ("viewDidLoad")
        super.setNavigationBar(false, backgroundColor: UIColor.clearColor())
        super.setNavigationButtons(true, hideOK: true, hideCancel: true, hideFilter: false)
        self.navigationItem.title="Restrooms"
                        
        initialLocationManager(map)
        if #available(iOS 9.0, *) {
            map.showsTraffic = false
        }
        
        table.dataSource=self
        table.delegate=self
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        table.registerNib(nib, forCellReuseIdentifier: "customCell")
        
        
        btnShow.layer.borderWidth=0.5
        btnShow.layer.borderColor = UIColor.grayColor().CGColor
        // Do any additional setup after loading the view, typically from a nib.
        
        let layer = GradientColor(colorLocations: GradientColor.style2).gl
        layer.frame = btnSignal.layer.bounds
        layer.cornerRadius = 25
        btnSignal.layer.addSublayer(layer)
        btnSignal.hidden = true

        
        
        lblSpeed.textColor = UIColor.whiteColor()
        lblSpeed.textAlignment = .Center
        lblSpeed.text = "0"
        let layer1 = GradientColor(colorLocations: GradientColor.style2).gl
        layer1.frame = lblSpeed.layer.bounds
        layer1.cornerRadius = 15
        viewDummyForlblSpeed.hidden = Constants.Variables.hideSpeedIndicator || true
        viewDummyForlblSpeed.layer.addSublayer(layer1)
        viewDummyForlblSpeed.addSubview(lblSpeed)
        self.view.addSubview(viewDummyForlblSpeed)
        self.setControlLocations(self.table.hidden)
        
//
////        lblSpeed.hidden = false



        self.mapInfoHelperViewDummy.delegate = self
        self.view.addSubview(self.txtMapInfoHelperDummy)
        self.txtMapInfoHelperDummy.inputView=self.mapInfoHelperViewDummy
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapViewController.resignResponder))
        self.view.addGestureRecognizer(tap)
        
        
        //Trying to get the data 1 second later if it already hasn't
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(MapViewController.timerUpdate), userInfo: nil, repeats: false)
        
        //In case the application had connection issues, this timer try to get the list of restrooms every 30 seconds if it hasn't had them.
        NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: #selector(MapViewController.timerUpdate), userInfo: nil, repeats: true)
        
        //Run it for the first time. then check it every ten minutes.
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(MapViewController.checkDisclaimer), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(600, target: self, selector: #selector(MapViewController.checkDisclaimer), userInfo: nil, repeats: true)
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(MapViewController.showSpeed), userInfo: nil, repeats: true)
        
        //NOTE: Commented this line out for demo as per Manjit -- Demo should only show single spot -- spoofed to be General Office
        //timer=NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "timerUpdate", userInfo: nil, repeats: true)
//        if isDemo {
//            timerDemo=NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "timerDemoUpdate", userInfo: nil, repeats: true)
//        }
        
    }
    
    override func viewDidLayoutSubviews() {
        self.setControlLocations(self.table.hidden)
    }
    
    override func viewWillAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "MapView")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        compassState = 0
    }
    
    var insideTimer=false
    func timerUpdate(){
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

   
    @IBAction func btnSignalClicked(sender: AnyObject) {
        var message: String = Constants.Messages.noGPSReception
        if (currentLocation?.signalStrength == .Poor){
            message = Constants.Messages.poorGPSReception
        }
        messageBox("Warning", message: message, prefferedStyle: .Alert, cancelButton: false, oKButton: true, openSettingButton: false, done: nil)
        
    }

    @IBAction func btnCompassClicked(sender: UIButton) {
        switch self.compassState {
        case 1:
            compassState = 2
        case 2:
            compassState = 0
        default:
            compassState = 1
        }
    }
    
    @IBAction func showListClicked(sender: UIButton) {
        toggleList()
    }
    
    override func filterClicked() {
        super.NavigateTo("FilterView", asModal: true, captureBackgroundImage: true, modalCompletion: { (controller: UIViewController) -> Void in
            let c = controller as! FilterViewController
            c.selectedIndex=self.currentRouteIndex
            c.portableWaterOnly = self.portableWaterOnly
            c.onClose = Event<ActionEnum>()
            c.onClose?.addHandler({action in
                if (action == .OK){
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
    
    func resignResponder(){
        lastSelectedCell?.selected = false
        txtMapInfoHelperDummy.resignFirstResponder()
        darkLayer.hidden = true
    }
    
    @IBAction func btnMapInfoClicked(sender: UIButton) {
        darkLayer.hidden = false
        self.mapInfoHelperViewDummy.frame.size.height = 120
        if #available(iOS 9.0, *) {
            self.mapInfoHelperViewDummy.showTraffic = map.showsTraffic
        }
        btnMapInfo.resignFirstResponder()
        txtMapInfoHelperDummy.becomeFirstResponder()

    }
    
    func mapInfoHelperView(configuration: MapInfoData) {
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
            let camera=MKMapCamera(lookingAtCenterCoordinate: map.camera.centerCoordinate, fromEyeCoordinate: map.camera.centerCoordinate, eyeAltitude: map.camera.altitude)
            camera.pitch = CGFloat(pitch)
            map.setCamera(camera, animated: true)
        }
    }

    private func setLocation(){
        setLocation(false)
    }
    private func setLocation(forceZoom: Bool){
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
                btnCompass.setImage(UIImage(imageLiteral: "MapArrowHeadSelected"), forState: .Normal)
                btnCompass.highlighted = true
                btnCompass.selected = false
                map.setUserTrackingMode(.Follow, animated: true)
            case 2:
                _compassState = 2
                startUpdatingLocation()
                if (CLLocationManager.headingAvailable()){
                    locationManager.headingFilter = 2
                    locationManager.startUpdatingHeading()
                }
                btnCompass.highlighted = false
                btnCompass.selected = true
                map.setUserTrackingMode(.FollowWithHeading, animated: true)
            default:
                let centerMap = (_compassState != 0)
                _compassState = 0
                if (CLLocationManager.headingAvailable()){
                    locationManager.stopUpdatingHeading()
                }
                if (centerMap){
                    map.setUserTrackingMode(.None, animated: true)
                    //setLocation(false)
                }
                btnCompass.setImage(UIImage(imageLiteral: "MapArrowHeadNormal"), forState: .Normal)
                btnCompass.highlighted = false
                btnCompass.selected = false
            }
            
        }
    }         
    func setListSize(){
        let timeout = 0.5
        let frame=self.currentView.frame
        // Due to an issue with buton.setTitle which causes UI to redraw and thus, the table will be setback to the original state that is defined in the designer
        // I use the hidden property after animation to hide it and set the frame locations to hidden before show it again.
        if (listOpen){
            UIView.animateWithDuration(timeout, animations: {()-> Void in
                self.setControlLocations(false)
                self.btnSignal.frame.origin.y = self.btnShow.frame.origin.y - 60
                self.viewDummyForlblSpeed.frame.origin.y = self.btnShow.frame.origin.y - 60
                self.table.frame.origin.y = self.btnShow.frame.origin.y + 30
                }, completion: {(complete: Bool) -> Void in
                    self.table.hidden = true
                    self.btnShow.setTitle("Show List", forState: .Normal)
            })

        }else{
            var h = frame.height * 0.4;
            if (h < 100){
                h = 100
            }
            self.table.frame.size.height = 0
            self.table.frame.origin.y = self.btnShow.frame.origin.y + 30
            self.table.hidden = false
            UIView.animateWithDuration(timeout, animations: {()-> Void in
                    self.setControlLocations(true)
                    self.btnSignal.frame.origin.y = self.btnShow.frame.origin.y - h - 60
                    self.viewDummyForlblSpeed.frame.origin.y = self.btnShow.frame.origin.y - h - 60
                    self.table.frame.size.height = h
                    self.table.frame.origin.y = self.btnShow.frame.origin.y  - h
                
                }, completion: {(complete: Bool) -> Void in
                    self.btnShow.setTitle("Hide List", forState: .Normal)
            })
            
        }
    }
    
    func setControlLocations(tableHidden: Bool){
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
                dispatch_async(dispatch_get_main_queue(), {
                    defer{
                        if (error != nil){
                            self.restroomsLoaded = false
                        }
                        self.insideTimer = false
                    }
                    Cache.add("Restrooms", value: jsonResult)
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
    func loadData(data: [RestStopModel]){
        lastLocationDataLoaded = currentLocation
        self.map.removeAnnotations(self.restrooms)
        Threading.sync(self.restrooms){
            self.restrooms.removeAll()
        }
        Threading.sync(self.dataSource){
            self.dataSource.removeAll()
        }
        var dataFiltered = data.filter({(restStop) -> Bool in
            restStop.distanceFromLocation = -1
            let waterCondition = (self.portableWaterOnly == false || restStop.drinkingWater == true)
            return waterCondition
        })
        if (currentLocation != nil){
            dataFiltered.sortInPlace({(restStop1, restStop2) in
                let distance1 = (restStop1.distanceFromLocation == -1 ? currentLocation?.location.distanceFromLocation(CLLocation(latitude: restStop1.latitude, longitude: restStop1.longtitude)):restStop1.distanceFromLocation )
                let distance2 = (restStop2.distanceFromLocation == -1 ? currentLocation?.location.distanceFromLocation(CLLocation(latitude: restStop2.latitude, longitude: restStop2.longtitude)):restStop2.distanceFromLocation )
                restStop1.distanceFromLocation = distance1!
                restStop2.distanceFromLocation = distance2!
                return distance1 < distance2
            })
        }
        
        for rest in dataFiltered
        {
            Threading.sync(self.dataSource){
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
            
            Threading.sync(self.dataSource){
                self.restrooms.append(ann)
            }
        }
        self.table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func locationChanged(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (currentLocation != nil && lastLocationDataLoaded != nil){
            let changed = currentLocation?.location.distanceFromLocation((lastLocationDataLoaded?.location)!)
            if (changed >= 160){
                self.reloadData()
            }
        }
        Threading.sync(self.dataSource){
            if (!self.restroomsLoaded){
                self.setLocation()
                self.refreshData()
            }
        }
    }
    
    override func annotationDetailsClicked(annotation: MKAnnotationView) {
        let ann: RestroomAnnotation = annotation.annotation as! RestroomAnnotation

        for i in 0 ..< dataSource.count {
            if (dataSource[i].id == ann.id){
                navigateToFeedback(dataSource[i])
                break;
            }
        }
    }
    override func annotationInfoClicked(annotation: MKAnnotationView) {
        let ann: RestroomAnnotation! = annotation.annotation as! RestroomAnnotation
        if (ann != nil && ann.hours != ""){
            messageBox("Info", message: ann.hours, prefferedStyle: .ActionSheet, cancelButton: false, oKButton: true, openSettingButton: false, done: nil)
        }
        //turnonNavigation(ann.locationName, coordinate: ann.coordinate)
    }
    
    func checkDisclaimer(){
        if (!checkingDisclaimer){
            checkingDisclaimer = true
            if (AppStorage.shouldPopupDisclaimer()){
                messageBox("Warning", message: Constants.Messages.dailyDisclaimerText, prefferedStyle: .Alert, cancelButton: false, oKButton: true, openSettingButton: false, done:{(action) in
                    defer{
                        self.checkingDisclaimer = false
                    }
                    AppStorage.setPopupDisclaimer()
                })
            }
        }
    }
    
    func showSpeed(){
        var speed = 0
        let hide :Bool =  lastGoodLocation == nil || lastGoodLocation?.recievedTime.subtract(DateTime.now(), calendarUnit: .Second).second > 3
        if (!hide){
            speed = Speed.meterPesSecondToMPH(speedBuffer.average)
//            speed = Speed.meterPesSecondToMPH((lastGoodLocation?.location.speed)!)
        }

        if speed > Constants.Variables.applicationDisableSpeed {
            darkLayer.hidden = false
            movingController = messageBox("Stop", message: Constants.Messages.drivingDisclaimerText, prefferedStyle: .ActionSheet, cancelButton: false, oKButton: false, openSettingButton: false, done: nil)
        }
        else if (speed <= Constants.Variables.applicationDisableSpeed && movingController != nil){
            Threading.runInMainThread{
                self.dismissViewControllerAnimated(true, completion: { () in
                    self.darkLayer.hidden = true
                    })
                //self.dismissWithClickedButtonIndex(-1, animated: true)
                self.movingController = nil
            }
        }
        if (hide || speed <= 0 ) {
            speedBuffer.clear()
            viewDummyForlblSpeed.hidden = Constants.Variables.hideSpeedIndicator || true
            return
        }
        
        lblSpeed.text = String(speed)
        viewDummyForlblSpeed.hidden = Constants.Variables.hideSpeedIndicator || false

    }
    
         
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CustomTableViewCell = self.table.dequeueReusableCellWithIdentifier("customCell") as! CustomTableViewCell
        cell.customDelegate = self
        let rest=dataSource[indexPath.row] as RestStopModel
        cell.tag = indexPath.row
        cell.customTag = rest
        cell.onTapped = {
            self.lastSelectedCell?.selected = false
            self.lastSelectedCell = cell
            cell.selected = true
            let ann=self.restrooms[indexPath.row] as RestroomAnnotation
            self.centerMapOnLocation(CLLocation(latitude: ann.coordinate.latitude, longitude: ann.coordinate.longitude))
            self.map.selectAnnotation(ann, animated: true)

        }

        cell.load("\(rest.name)", rate: rest.averageRating, extraInfo: "\(Speed.distanceToMile(rest.distanceFromLocation)) mi",potableWater: rest.drinkingWater)

        return cell
    }
    
    func CustomTableViewCellEditClicked(cell: CustomTableViewCell) {
        //messageBox("test", message: "this is a test", prefferedStyle: .Alert, cancelButton: true, oKButton: true, openSettingButton: false)
        lastSelectedCell?.selected = false
        if (lastSelectedCell != nil){
            
            let index = cell.tag
            print (index)
            let ann=self.restrooms[index] as RestroomAnnotation
            self.map.deselectAnnotation(ann, animated: true)
            centerMapOnLocation(CLLocation(latitude: ann.coordinate.latitude, longitude: ann.coordinate.longitude))
            
        }

        cell.selected = false
        navigateToFeedback(cell.customTag as! RestStopModel)
    }
    
    //NOTE: Updated title to display route info.
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Restrooms for Route \(self.getSelectedRouteTitle())"
    }
    
    func getSelectedRouteTitle() -> String{
        var route="All"
        if (self.currentRoute != nil){
            route=self.currentRoute.Title
        }
        return route
        
    }
    
    func navigateToFeedback(restStopModel: RestStopModel){
        super.NavigateTo("Feedback", asModal: true, captureBackgroundImage: true,
            beforeShow: { (controller: UIViewController) -> Void in
                let c = controller as! FeedbackViewController
                c.currentRestroom = restStopModel
            }
            ,modalCompletion: { (controller: UIViewController) -> Void in
                let c = controller as! FeedbackViewController
                //c.currentRestroom = cell.customTag as! RestStopModel
                c.onClose = Event<ActionEnum>()
                c.onClose?.addHandler({action in
                    if (action == .OK){
                        self.refreshData()
                    }
                })
            }
        )        
    }
    
}
