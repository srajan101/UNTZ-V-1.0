//
//  UpcomingEventsViewController.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 21/06/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class UpcomingEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var upcomingEventsTableView: UITableView!
    
    var offset : Int = 0
    var pageIndex : Int = 1
    var isMoreEventAvailable : Bool = false
    var bolDecelerate : Bool = false
    open var isPushVC : Bool?
    open var accountId : String?
    open var fanName : String?
    var upcomingEventsResponse : UNUpcomingEventsResponse?

    @IBOutlet weak var noresultLabel: UNLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upcomingEventsTableView.register(UINib(nibName: "UpcomingEventTableViewCell", bundle: nil), forCellReuseIdentifier: "UpcomingEventTableViewCell")
        
        upcomingEventsTableView.estimatedRowHeight = upcomingEventsTableView.rowHeight
        upcomingEventsTableView.rowHeight = UITableViewAutomaticDimension

        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.refreshHomeScreenInBackground(withNotification:)), name: NSNotification.Name(rawValue: "UpdateHomeScreen"), object: nil)
        
        refreshList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        //self.navigationController?.isNavigationBarHidden = true
        
        var isMenuRequired = true
        if(isPushVC)!{
            isMenuRequired = false
        }
        var title = ""
        if let fanName = fanName {
            title = String.init(format: "%@'s Upcoming Events", fanName)
        } else {
            title = "My Upcoming Events"
        }
        
        addCustomNavBar(self, isMenuRequired: isMenuRequired, title: title, backhandler: {
            if(isMenuRequired) {
                self.showLeftView()
            } else {
              self.navigationController?.popViewController(animated: true)
            }
        })
        
    }
    
    // MARK: -
    
    override func viewDidAppear(_ animated: Bool) {
        //refreshList()
        self.upcomingEventsTableView.reloadData()
    }
    
    func showLeftView() {
        if(isPushVC)!{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            sideMenuController?.showLeftView(animated: true, completionHandler: nil)
        }
    }
    
    @objc func refreshHomeScreenInBackground(withNotification notification: NSNotification) {
        self.upcomingEventsTableView.tableFooterView = nil
        offset = 0
        pageIndex = 1
        bolDecelerate = false
        isMoreEventAvailable = false
        self.getListOfUserEvents()
    }

    //MARK :- Get List Of Events
    
    func getListOfUserEvents() {
        
        if self.upcomingEventsResponse == nil || self.upcomingEventsResponse?.eventsInfoArray?.count==0{
            GLOBAL().showLoadingIndicatorWithMessage("")
        }
        
        UNTZReqeustManager.sharedInstance.apiGetListOfUserEvents(offset, accountId: accountId! ,searchText: "") {
            (feedResponse) -> Void in
            GLOBAL().hideLoadingIndicator()
            self.upcomingEventsTableView.tableFooterView?.isHidden = false
            
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                GLOBAL().hideLoadingIndicator()
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    if(self.offset == 0) {
                        self.upcomingEventsResponse = UNUpcomingEventsResponse.init(jsonDict:dictionary["data"] as! Dictionary<String, AnyObject>)
                       // print("\(String(describing: self.upcomingEventsResponse?.numberOfItemsPerPage))")
                        if self.upcomingEventsResponse?.eventsInfoArray?.count==0{
                            self.noresultLabel.isHidden = false
                        }else{
                            self.noresultLabel.isHidden = true
                        }
                        GLOBAL.sharedInstance.checkFacebookUserEventsUpdated()
                    } else {
                        self.upcomingEventsResponse?.appendData(jsonDict:dictionary["data"] as! Dictionary<String, AnyObject>)
                    }
                    
            if(((self.upcomingEventsResponse?.numberOfItemsPerPage)! * self.pageIndex) == (self.upcomingEventsResponse?.eventsInfoArray?.count)) {
                        self.isMoreEventAvailable = true
                    } else {
                        self.isMoreEventAvailable = false
                
            self.upcomingEventsTableView.tableFooterView?.isHidden = true
            }
                self.upcomingEventsTableView.reloadData()
                }
            }
        }
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if upcomingEventsResponse == nil {
            return 0
        } else
        {
            return (upcomingEventsResponse?.eventsInfoArray?.count)!;
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 530;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (self.isMoreEventAvailable) {
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
                //  print("this is the last cell")
                
                let imageData = NSData(contentsOf: Bundle.main.url(forResource: "animationImg",withExtension: "gif")!)
                let  hudImgView = UIImageView(image: UIImage.sd_animatedGIF(with: imageData as Data!))
                let myNewView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(100)))
                hudImgView.frame = CGRect(x: CGFloat((myNewView.frame.width-100)/2), y: CGFloat(0), width: CGFloat(100), height: CGFloat(100))
                myNewView.addSubview(hudImgView)
                tableView.tableFooterView = myNewView
                self.upcomingEventsTableView.tableFooterView?.isHidden = false
            }
        } else {
            tableView.tableFooterView = nil
        }
        
    }
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UpcomingEventTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UpcomingEventTableViewCell") as! UpcomingEventTableViewCell
        //cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let eventInfo = upcomingEventsResponse?.eventsInfoArray?[indexPath.row] as EventInfo!
        cell.eventNameLabel.text = eventInfo?.eventName
        cell.eventTypeLabel.text = eventInfo?.category?.replacingOccurrences(of: "_", with: " ")
        cell.timeLabel.text = eventInfo?.dateTimeStart
        //cell.placeLable.text = String.init(format: "%@ (%0.01f miles)", (eventInfo?.eventLocation?.locationName)!,(eventInfo?.eventLocation?.distanceFromDeviceLocation)!)
        cell.placeLable.text = eventInfo?.eventLocation?.locationName
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
            eventAdminName.append(eventAdmin.adminName! + ", ")
        }
        let truncatedEventAdminName = String(eventAdminName.dropLast())
        
        let newAdminName = String(truncatedEventAdminName.dropLast())
        
        cell.hostedByLabel.text = String.init(format: "Hosted By %@", newAdminName)
        cell.peopleCountLabel.text = String.init(format: "%ld Attending | %ld Interested", (eventInfo?.facebookAttendingCount)!,(eventInfo?.facebookInterestedCount)!)
        
        cell.eventImageView.setShowActivityIndicator(true)
        cell.eventImageView.setIndicatorStyle(.gray)
        
        cell.RSVPStatusLabel.layer.cornerRadius = 13
        cell.RSVPStatusLabel.layer.masksToBounds = true
        
        if let fanName = fanName {
            cell.RSVPStatusLabel.text = GLOBAL.sharedInstance.RSVPStatusText(eventStatus: (eventInfo?.eventStatus)!, userName: fanName)
        } else {
            cell.RSVPStatusLabel.text = GLOBAL.sharedInstance.RSVPStatusText(eventStatus: (eventInfo?.eventStatus)!, userName: nil)
        }
        
        let width = cell.RSVPStatusLabel.intrinsicContentSize.width
        cell.RSVPStatusLabel.frame.size = CGSize.init(width: width, height: 26)
        
        if ((eventInfo?.imageurl) != nil) {
            cell.eventImageView.sd_setImage(with: URL(string: (eventInfo?.imageurl)!), placeholderImage: UIImage(named: "default_image"))
            //cell.updateUI(urlstr: (eventInfo?.imageurl)!)
        }else{
            cell.eventImageView.image = UIImage(named: "default_image")
        }
        
        cell.interestedBtn.tag = indexPath.row
        self.changeEventButton(interestedButton: cell.interestedBtn,eventInfo: eventInfo!)
        
        return cell
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventInfo = upcomingEventsResponse?.eventsInfoArray?[indexPath.row] as EventInfo!
        
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDEventDetailsVC") as! EventDetailsViewController
        detailObj.eventId = eventInfo?.eventId
        detailObj.eventImageURL = eventInfo?.imageurl
        
        pushStoryObj(obj: detailObj, on: self)
        
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
                pageIndex = pageIndex + 1
                offset = (upcomingEventsResponse?.nextIndex)!
                self.isMoreEventAvailable = false;
                self.getListOfUserEvents()
                
            }
        }
    }

    func changeEventButton(interestedButton : UIButton, eventInfo: EventInfo) {
        if (eventInfo.eventStatus?.isUserArtist)! || (eventInfo.eventStatus?.isUserInterested)! || (eventInfo.eventStatus?.isUserAdmin)! {
            
            if (eventInfo.eventStatus?.isUserAdmin)! {
                // do nothing
                if (eventInfo.islive)! {
                    if (eventInfo.isCancelled)! {
                        interestedButton.setTitle("UNDO CANCEL", for: UIControlState.normal)
                        interestedButton .setImage(UIImage.init(named: "undo_cancel"), for: UIControlState.normal)
                        
                    } else {
                        interestedButton.setTitle("CANCEL", for: UIControlState.normal)
                        interestedButton .setImage(UIImage.init(named: "cancel_event"), for: UIControlState.normal)
                    }
                    
                } else {
                    interestedButton .setTitle("GO LIVE", for: UIControlState.normal)
                    interestedButton .setImage(UIImage.init(named: "go_live"), for: UIControlState.normal)
                }
                
                interestedButton.removeTarget(self, action: #selector(joinOrLeaveButtonEvent(_:)), for: .touchUpInside)
                
                interestedButton.removeTarget(self, action: #selector(interestedButtonEvent(_:)), for: .touchUpInside)
                
                interestedButton.addTarget(self, action: #selector(interestedButtonEvent(_:)), for: .touchUpInside)
            } else {
                if (eventInfo.eventStatus?.isUserInterested)! {
                    if (eventInfo.islive)! {
                        if (eventInfo.eventStatus?.isUserJoined)! {
                            interestedButton.setTitle("LEAVE", for: UIControlState.normal)
                            interestedButton .setImage(UIImage.init(named: "leave_event"), for: UIControlState.normal)
                            
                        } else {
                            interestedButton .setTitle("JOIN", for: UIControlState.normal)
                            interestedButton .setImage(UIImage.init(named: "join_event"), for: UIControlState.normal)
                            
                        }
                        
                    interestedButton.removeTarget(self, action: #selector(interestedButtonEvent(_:)), for: .touchUpInside)

                    interestedButton.addTarget(self, action: #selector(joinOrLeaveButtonEvent(_:)), for: .touchUpInside)

                    } else {
                    interestedButton.setTitle("REMOVE", for: UIControlState.normal)
                interestedButton .setImage(UIImage.init(named: "delete"), for: UIControlState.normal)
                        
                    interestedButton.removeTarget(self, action: #selector(joinOrLeaveButtonEvent(_:)), for: .touchUpInside)

                    interestedButton.addTarget(self, action: #selector(interestedButtonEvent(_:)), for: .touchUpInside)
                        

                    }
                    
                    
                } else {
                interestedButton .setTitle("INTERESTED", for: UIControlState.normal)
            interestedButton .setImage(UIImage.init(named: "interested_event"), for: UIControlState.normal)
                    
                interestedButton.removeTarget(self, action: #selector(joinOrLeaveButtonEvent(_:)), for: .touchUpInside)

                interestedButton.addTarget(self, action: #selector(interestedButtonEvent(_:)), for: .touchUpInside)
                    
                    
                }
            }
        }
    }
    
    @IBAction func interestedButtonEvent(_ sender: UIButton) {
        let eventIndex = sender.tag as Int!
        
        let eventInfo = upcomingEventsResponse?.eventsInfoArray?[eventIndex!] as EventInfo!

        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            if (eventInfo?.eventStatus?.isUserInterested)! {
                markEventAsInterested(false,(eventInfo?.eventStatus?.eventId)!)
            } else {
                markEventAsInterested(true,(eventInfo?.eventStatus?.eventId)!)
            }
        } else {
            GLOBAL().showAlert(APPLICATION.applicationName, message: "Login to mark as Interested!", actions: nil)
        }
    }

    @IBAction func joinOrLeaveButtonEvent(_ sender: UIButton) {
        let eventIndex = sender.tag as Int!
        
        let eventInfo = upcomingEventsResponse?.eventsInfoArray?[eventIndex!] as EventInfo!
        

        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            if (eventInfo?.eventStatus?.isUserJoined)! {
                joinOrLeaveEvent(true,(eventInfo?.eventId)!)
            } else {
                joinOrLeaveEvent(false,(eventInfo?.eventId)!)
            }
        } else {
            GLOBAL().showAlert(APPLICATION.applicationName, message: "Login to Join Event!", actions: nil)
        }

    }
    
    @IBAction func goLiveOrCancelButtonEvent(_ sender: UIButton) {
        let eventIndex = sender.tag as Int!
        
        let eventInfo = upcomingEventsResponse?.eventsInfoArray?[eventIndex!] as EventInfo!
        
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            if (eventInfo?.islive)! {
                if (eventInfo?.isCancelled)! {
                    markEventAsCanceledOrNot(false,eventId: (eventInfo?.eventId)!)
                } else {
                    markEventAsCanceledOrNot(true,eventId: (eventInfo?.eventId)!)
                }
            } else {
                goLiveEvent((eventInfo?.eventId)!)
            }
        } else {
            GLOBAL().showAlert(APPLICATION.applicationName, message: "You are not admin!", actions: nil)
            
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
    
    //MARK :- Join Event or Leave Event
    
    func joinOrLeaveEvent(_ isLeaving : Bool, _ eventId : Int) {
        
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiJoinOrLeaveEvent(eventId, isLeaving: isLeaving) {
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

    //MARK :- Mark Event as Canceled Or Not
    
    func markEventAsCanceledOrNot(_ isCancelled : Bool,eventId : Int) {
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiMarkEventAsCanceledOrNot(eventId, isCancelled: isCancelled) {
            (feedResponse) -> Void in
            GLOBAL().hideLoadingIndicator()
            
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                GLOBAL().hideLoadingIndicator()
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    //self.eventDetailsResponse = EventDetailsResponse.init(jsonDict:dictionary)
                    print("\(dictionary)")
                    
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
    
    // MARK: Mark Event as Go Live
    
    func goLiveEvent(_ eventId : Int) {
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiGoLiveEvent(eventId) {
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
    
    
    func refreshList()  {
        self.upcomingEventsTableView.tableFooterView = nil
        
        pageIndex = 1
        offset = 0
        bolDecelerate = false
        isMoreEventAvailable = false
        
        upcomingEventsResponse = nil
        upcomingEventsTableView.reloadData()
        self.getListOfUserEvents()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
