//
//  ViewController.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 13/04/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD
import CoreLocation
import SDWebImage


class HomeViewController: UIViewController ,CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    var bolDecelerate : Bool = false
    var isMoreEventAvailable : Bool = false

    let locationManager = CLLocationManager()
    var filterArray : [String] = ["ART_EVENT","ART_FILM","BOOK_EVENT","BOOKS_LITERATURE","CAUSES","COMEDY_EVENT","COMMUNITY","CONFERENCE_EVENT","DANCE_EVENT","DINING_EVENT","FAMILY_EVENT","FESTIVAL_EVENT","FITNESS","FOOD_DRINK","FOOD_TASTING","FUNDRAISER","HEALTH_WELLNESS","LECTURE","MUSIC","MUSIC_EVENT","NIGHTLIFE","OTHER","PARTIES_NIGHTLIFE","SHOPPING","SPORTS_EVENT","SPORTS_RECREATION","THEATER_DANCE","WORKSHOP"]
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var actionbtnView: UIView!
    @IBOutlet weak var filterCategoriesTableViewHome: UITableView!
    @IBOutlet weak var MainTableViewHome: UITableView!
    var filterCategoriesArray = NSMutableArray()
    var offset : Int = 0
    var suggestedEventsResponse : UNSuggestedEventsResponse?
    
    var HUD: MBProgressHUD = MBProgressHUD()
    var searchActive : Bool = false
    var sidehidden : Bool = true
    var latitude : String = ""
    var longitude : String = ""
    var hitOnce : Bool = false
    
    @IBOutlet weak var noresultLabel: UNLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        self.title = "Home"
        
        var image = UIImage(named: "filter")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showRightView(sender:)))
        
        var image1 = UIImage(named: "menu")
        
        image1 = image1?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image1, style: .plain, target: self, action: #selector(showLeftView(sender:)))
       */
        MainTableViewHome.register(UINib(nibName: "HomeMainTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        MainTableViewHome.estimatedRowHeight = MainTableViewHome.rowHeight
        MainTableViewHome.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.imageDidLoadNotification(withNotification:)), name: NSNotification.Name(rawValue: "CellDidLoadImageDidLoadNotification"), object: nil)

        //NotificationCenter.default.addObserver(self, selector: Selector(("imageDidLoadNotification:")), name:NSNotification.Name(rawValue: "CellDidLoadImageDidLoadNotification"), object: nil)
        // Do any additional setup after loading the view.
        searchBar.delegate = self
                
        // https://untz.azurewebsites.net/api/Event/SuggestedEvents?offset=0&lat=19.0213&lon=72.8424
        
        
        self.getListOfEventCategories()
        
        sideView.layer.shadowColor = UIColor.black.cgColor
        sideView.layer.shadowOffset = CGSize.zero
        sideView.layer.shadowOpacity = 0.2
        sideView.layer.shadowRadius = 5



    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //sideView.isHidden = true
        
        addPersonalizeNavBar(self, leftButtonTitle: "", rightButtonTitle: nil, rightButtonImage: "filter", title: "Home", isMenuRequired: true , backhandler: {
            self.showLeftView()
        }) {
            self.showRightView()
        }
        let right = UIScreen.main.bounds.size.width+self.sideView.frame.size.width
        self.sideView.frame = CGRect(x: right, y: self.sideView.frame.origin.y, width: self.sideView.frame.size.width, height: self.sideView.frame.size.height)
        sidehidden = true
        
        actionbtnView.layer.shadowColor = UIColor.black.cgColor
        actionbtnView.layer.shadowOffset = CGSize.zero
        actionbtnView.layer.shadowOpacity = 0.2
        
        // delegate and data source
        self.initializeFilterArray()
        filterCategoriesTableViewHome.delegate = self
        filterCategoriesTableViewHome.dataSource = self
        filterCategoriesTableViewHome.reloadData()
        
        hitOnce = false
        startLocation(self)
        
        /*
         Client Location
         latitude = "47.7390021"
        longitude = "-122.1904466"
        self.getListOfEvents("47.7390021", longitude: "-122.1904466", searchText: "", categories: "")
         */
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    
     func startLocation(_ sender: Any) {
        // Ask for Authorisation from the User.
        //self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        //GLOBAL.sharedInstance.showLoadingIndicatorWithMessage("")
      }
        
    }
    // MARK: -
    
    func showLeftView() {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    func showRightView() {
    
        let right = UIScreen.main.bounds.size.width+self.sideView.frame.size.width
        let left = UIScreen.main.bounds.size.width-self.sideView.frame.size.width
        
        if (sidehidden)
        {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
                
                self.sideView.frame = CGRect(x: left, y: self.sideView.frame.origin.y, width: self.sideView.frame.size.width, height: self.sideView.frame.size.height)
                
                self.sidehidden = false;
            }, completion: nil)
        }else{
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
                self.sideView.frame =  CGRect(x: right, y: self.sideView.frame.origin.y, width: self.sideView.frame.size.width, height: self.sideView.frame.size.height)
                self.sidehidden = true;
            }, completion: nil)
        }
    }
    
    //CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            
            
            if (placemarks?.count)! > 0 {
                var placemark : CLPlacemark!
                placemark = placemarks?[0]
                self.displayLocationInfo(placemark: placemark)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
        GLOBAL.sharedInstance.hideLoadingIndicator()
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            if let location = containsPlacemark.location {
                let lat : Double = (placemark?.location?.coordinate.latitude)!
                latitude = String.init(format: "%.4f", lat)

                print(latitude)
                let lon = location.coordinate.longitude;
                longitude = String.init(format: "%f", lon)
                
            }
            
            if hitOnce == false
            {
                self.getListOfEvents(latitude, longitude: longitude,searchText: "",categories: "")
            }
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        GLOBAL.sharedInstance.hideLoadingIndicator()
        //txtLatitude.text = "Can't get your location!"
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.denied) {
            let alert=UIAlertController(title: "App Permission Denied", message: "To re-enable, please go to Settings and turn on Location Service for this app.", preferredStyle: UIAlertControllerStyle.alert);
            //show it
            show(alert, sender: self);
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        var shouldIAllow = false
        var locationStatus = ""
        switch status {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.notDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
        }
    }

    //MARK :- Get List Of Event Categories
    
    func getListOfEventCategories() {
        
        //GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiGetListOfEventCategories({ (feedResponse) -> Void in
            //GLOBAL().hideLoadingIndicator()
            
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                //GLOBAL().hideLoadingIndicator()
                print("\(feedResponse)")
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    self.filterArray = dictionary["data"] as! Array
                    print("\(feedResponse)")
                    
                    for index in 0...self.filterArray.count-1
                    {
                        var string = self.filterArray[index] as String
                        string = string.replacingOccurrences(of: "_", with: " ")
                        self.filterArray[index] = string
                    }
                    self.filterCategoriesTableViewHome.reloadData()
                }
                
            }
        })
        
    }
    
    //MARK :- Get List Of Events

    func getListOfEvents(_ latitude: String,longitude: String,searchText: String,categories: String) {
        hitOnce = true;
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiGetListOfEvents(offset,latitude: latitude,longitude: longitude,searchText: searchText,categories:categories ) {
            (feedResponse) -> Void in
            GLOBAL().hideLoadingIndicator()
            
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                GLOBAL().hideLoadingIndicator()
                self.searchBar.resignFirstResponder()

                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    if(self.offset == 0) {
                        self.suggestedEventsResponse = UNSuggestedEventsResponse.init(jsonDict:dictionary["data"] as! Dictionary<String, AnyObject>)
                        print("\(String(describing: self.suggestedEventsResponse?.numberOfItemsPerPage))")
                        if self.suggestedEventsResponse?.eventsInfoArray?.count==0{
                            self.noresultLabel.isHidden = false;
                        }else{
                            self.noresultLabel.isHidden = true;
                        }
                        
                        
                    } else {
                        self.suggestedEventsResponse?.appendData(jsonDict:dictionary["data"] as! Dictionary<String, AnyObject>)
                        
                    }
                    
                    if(self.suggestedEventsResponse?.numberOfItemsPerPage == 10) {
                        self.isMoreEventAvailable = true
                    } else {
                        self.isMoreEventAvailable = false
                    }
                    self.MainTableViewHome.reloadData()
                }
            }
        }
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 2{
            return filterCategoriesArray.count
        }else{
            if suggestedEventsResponse == nil {
                return 0
            } else
            {
                return (suggestedEventsResponse?.eventsInfoArray?.count)!;
            }
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView.tag == 2{
            return 50;
        } else{

            return 500;//Choose your custom row height
        }
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 2{
            let cell:FilterTableViewCell = filterCategoriesTableViewHome.dequeueReusableCell(withIdentifier: "cell") as! FilterTableViewCell
            cell.filterLabel.text = filterArray[indexPath.row]
            let xVal: Int = filterCategoriesArray[indexPath.row] as! Int
            if xVal == 1 {
                cell.chkboxImageView.image = UIImage(named: "checkBox")
            }else{
                cell.chkboxImageView.image = UIImage(named: "box")
            }
            return cell
        }
        else
        {
            let cell:HomeMainTableViewCell = MainTableViewHome.dequeueReusableCell(withIdentifier: "cell") as! HomeMainTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            let eventInfo = suggestedEventsResponse?.eventsInfoArray?[indexPath.row] as EventInfo!;
            cell.eventNameLabel.text = eventInfo?.eventName
            cell.eventTypeLabel.text = eventInfo?.category?.replacingOccurrences(of: "_", with: " ")
            cell.timeLabel.text = eventInfo?.dateTimeStart
            cell.placeLable.text = String.init(format: "%@ (%0.01f miles)", (eventInfo?.eventLocation?.locationName)!,(eventInfo?.eventLocation?.distanceFromDeviceLocation)!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" //Your date format //yyyy-MM-dd'T'HH:mm:ss-mm:ss
            //dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale!
            dateFormatter.timeZone = NSTimeZone(name: "PT") as TimeZone!
                //dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00") as TimeZone!
            let date = dateFormatter.date(from: (eventInfo?.dateTimeStart)!) //according to date format your date string
            if eventInfo?.dateTimeEnd != nil {
                let endDate = dateFormatter.date(from: (eventInfo?.dateTimeEnd)!) //according to date
                if (endDate != nil && date != nil){
                    dateFormatter.dateFormat = "EEE h:mm a"
                    let dateName = dateFormatter.string(from: date!)
                    
                    dateFormatter.dateFormat = "h:mm a"
                    let endDateName = dateFormatter.string(from: endDate!)
                    cell.timeLabel.text = String.init(format: "%@ - %@", dateName,endDateName)
                    
                }
                else{
                    cell.timeLabel.text = ""
                }
            }
            else if (date != nil){
                //631 Attending | 3129 Interested
                // MON 8 AM - 11 PM
                dateFormatter.dateFormat = "EEE h:mm a"
                let dateName = dateFormatter.string(from: date!)
                cell.timeLabel.text = dateName
                
            }
            
            
            if (date != nil){
                //631 Attending | 3129 Interested
                // MON 8 AM - 11 PM
                dateFormatter.dateFormat = "MMM"
                let monthName = dateFormatter.string(from: date!)
                cell.dateMonthLabel.text = monthName
                
                dateFormatter.dateFormat = "dd"
                let datefmt = dateFormatter.string(from: date!)
                cell.dateDayLabel.text = datefmt

            }  else{
                cell.dateMonthLabel.text = ""
                cell.dateDayLabel.text = ""
            }
            
            var eventAdminName : String = ""
            
            for eventAdmin in (eventInfo?.eventAdminsArray)! {
                eventAdminName.append(eventAdmin.adminName! + ",")
            }
            let truncatedEventAdminName = String(eventAdminName.characters.dropLast())

            cell.hostedByLabel.text = String.init(format: "Hosted By %@", truncatedEventAdminName)
            cell.peopleCountLabel.text = String.init(format: "%ld Attending | %ld Interested", (eventInfo?.facebookAttendingCount)!,(eventInfo?.facebookInterestedCount)!)
            
            cell.eventImageView.setShowActivityIndicator(true)
            cell.eventImageView.setIndicatorStyle(.gray)

            if ((eventInfo?.imageurl) != nil) {
                cell.eventImageView.sd_setImage(with: URL(string: (eventInfo?.imageurl)!), placeholderImage: UIImage(named: "default_image"))
                //cell.updateUI(urlstr: (eventInfo?.imageurl)!)
            }else{
                cell.eventImageView.image = UIImage(named: "default_image")
            }
            cell.interestedBtn.tag = indexPath.row;
            cell.interestedBtn.addTarget(self, action: #selector(interestedButtonEvent(_:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 2{
            let xVal: Int = filterCategoriesArray[indexPath.row] as! Int
            var nextxVal: Int = 0
            if xVal == 0{
                nextxVal = 1;
            }
            filterCategoriesArray.replaceObject(at: indexPath.row, with: nextxVal)
            filterCategoriesTableViewHome.reloadData()
        }
        else{
            let eventInfo = suggestedEventsResponse?.eventsInfoArray?[indexPath.row] as EventInfo!
            
            let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDEventDetailsVC") as! EventDetailsViewController
            detailObj.eventId = eventInfo?.eventId
            detailObj.eventImageURL = eventInfo?.imageurl
            
            pushStoryObj(obj: detailObj, on: self)
        }
    }
    
   @objc func imageDidLoadNotification(withNotification notification: NSNotification) {
        
        if  let cell = notification.object as? HomeMainTableViewCell{
        let indexPath = MainTableViewHome.indexPath(for: cell)
        if (indexPath != nil){
            MainTableViewHome.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.none)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            hideKeyboardWithSearchBar(bar: searchBar)
        }
    }
    
    func hideKeyboardWithSearchBar(bar:UISearchBar) {
        self.searchBar.resignFirstResponder()
        
        let applyCategoriesArray = NSMutableArray()
        for i in (0..<filterCategoriesArray.count) {
            let xVal: Int = filterCategoriesArray[i] as! Int
            if xVal==1 {
                applyCategoriesArray.add(filterArray[i])
            }
        }
        
        let stringRepresentationOfCategories = applyCategoriesArray.componentsJoined(by: ",")
        
        offset = 0
        self.getListOfEvents(latitude, longitude: longitude,searchText: "",categories: stringRepresentationOfCategories)

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        print(searchBar.text!)
        searchBar.resignFirstResponder()
        
        let applyCategoriesArray = NSMutableArray()
        for i in (0..<filterCategoriesArray.count) {
            let xVal: Int = filterCategoriesArray[i] as! Int
            if xVal==1 {
                applyCategoriesArray.add(filterArray[i])
            }
        }
        
        let stringRepresentationOfCategories = applyCategoriesArray.componentsJoined(by: ",")
        
        offset = 0
        self.getListOfEvents(latitude, longitude: longitude,searchText: searchBar.text!,categories: stringRepresentationOfCategories)
    }
    
    func initializeFilterArray(){
        for _ in (0..<filterArray.count)
        {filterCategoriesArray.add(0)}
    }
    
    @IBAction func applyBtnClicked(_ sender: Any) {
        self.showRightView()
        let applyCategoriesArray = NSMutableArray()
        for i in (0..<filterCategoriesArray.count) {
            let xVal: Int = filterCategoriesArray[i] as! Int
            if xVal==1 {
                applyCategoriesArray.add(filterArray[i])
            }
        }
        if applyCategoriesArray.count > 0{
            noresultLabel.isHidden = true
        for index in 0...applyCategoriesArray.count-1
        {
            var string = applyCategoriesArray[index] as! String
            string = string.replacingOccurrences(of: " ", with: "_")
            applyCategoriesArray[index] = string
        }
        
        let stringRepresentationOfCategories = applyCategoriesArray.componentsJoined(by: ",")
        
        offset = 0
        self.getListOfEvents(latitude, longitude: longitude,searchText: "",categories: stringRepresentationOfCategories)
        }
    }
   
    @IBAction func clearBtnClicked(_ sender: Any){
        self.showRightView()
        filterCategoriesArray.removeAllObjects()
        self.initializeFilterArray()
        filterCategoriesTableViewHome.reloadData()
        
        offset = 0
        self.getListOfEvents(latitude, longitude: longitude,searchText: searchBar.text!,categories: "")
    }
    
    @IBAction func interestedButtonEvent(_ sender: UIButton) {
        let eventIndex = sender.tag as Int!
        
        let eventInfo = suggestedEventsResponse?.eventsInfoArray?[eventIndex!]
        
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            markEventAsInterested(true,(eventInfo?.eventId)!)
        } else {
            GLOBAL().showAlert(APPLICATION.applicationName, message: "Login to mark as Interested!", actions: nil)
        }
    }
    
    //MARK :- Mark Event as Interested Or Not
    
    func markEventAsInterested(_ interested : Bool, _ eventId : Int) {
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiMarkEventAsInterestedOrNot(eventId, isInterested: interested) {
            (feedResponse) -> Void in
            GLOBAL().hideLoadingIndicator()
            
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                GLOBAL().hideLoadingIndicator()
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    let dataValue = dictionary["data"] as! Bool!
                    
                    if dataValue == true {
                        self.refreshList()
                    } else {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                    }
                }
            }
        }
    }

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (bolDecelerate) {
            scrollViewReload(scrollView)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        bolDecelerate = decelerate;

        if (!bolDecelerate) {
            scrollViewReload(scrollView)
        }
    }
    
    private func scrollViewReload(_ scrollView : UIScrollView) {
        let endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        
        if (endScrolling >= scrollView.contentSize.height - 100){
            if (self.isMoreEventAvailable) {
                offset = (suggestedEventsResponse?.nextIndex)!
                self.isMoreEventAvailable = false;
                self.getListOfEvents(latitude, longitude: longitude,searchText: searchBar.text!,categories: "")
   
            }
        }
    }
    
    func refreshList()  {
        offset = 0
        bolDecelerate = false
        isMoreEventAvailable = false
        
        suggestedEventsResponse = nil
        
        self.getListOfEvents(latitude, longitude: longitude,searchText: "",categories: "")
        
    }

}


