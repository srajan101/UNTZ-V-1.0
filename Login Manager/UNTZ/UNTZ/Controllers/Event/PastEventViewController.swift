//
//  PastEventViewController.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 27/12/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class PastEventViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var pastEventsTableView: UITableView!
    
    var offset : Int = 0
    var pageIndex : Int = 1
    var isMoreEventAvailable : Bool = false
    var bolDecelerate : Bool = false
    open var isPushVC : Bool?
    open var accountId : Int?
    open var userFullname : String?
    open var profileimageURL : String?
    open var isFanProfile : Bool?
    var pastEventsResponse : UNUpcomingEventsResponse?
    open var fanName : String?
    
    @IBOutlet weak var noresultLabel: UNLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pastEventsTableView.register(UINib(nibName: "PastEventTableViewCell", bundle: nil), forCellReuseIdentifier: "PastEventTableViewCell")
        
        pastEventsTableView.estimatedRowHeight = pastEventsTableView.rowHeight
        pastEventsTableView.rowHeight = UITableViewAutomaticDimension
        
        refreshList()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var title = ""
        if let fanName = fanName {
            title = String.init(format: "%@'s Past Events", fanName)
        } else {
            title = "Past Events"
        }
        
        addCustomNavBar(self, isMenuRequired: false, title: title) {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    // MARK: -
    
    override func viewDidAppear(_ animated: Bool) {
        //refreshList()
        self.pastEventsTableView.reloadData()
    }
    
    func showLeftView() {
        if(isPushVC)!{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            sideMenuController?.showLeftView(animated: true, completionHandler: nil)
        }
    }
    
    //MARK :- Get List Of Events
    
    func getListOfPastEvents() {
        if self.pastEventsResponse == nil || self.pastEventsResponse?.eventsInfoArray?.count == 0{
            GLOBAL().showLoadingIndicatorWithMessage("")
        }
        UNTZReqeustManager.sharedInstance.apiGetListOfPastEvents(offset, accountId: accountId! ,searchText: "") {
            (feedResponse) -> Void in
            GLOBAL().hideLoadingIndicator()
            self.pastEventsTableView.tableFooterView?.isHidden = false
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                GLOBAL().hideLoadingIndicator()
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    if(self.offset == 0) {
                        self.pastEventsResponse = UNUpcomingEventsResponse.init(jsonDict:dictionary["data"] as! Dictionary<String, AnyObject>)
                        
                        if self.pastEventsResponse?.eventsInfoArray?.count==0{
                            self.noresultLabel.isHidden = false
                        }else{
                            self.noresultLabel.isHidden = true
                        }
                    } else {
                       self.pastEventsResponse?.appendData(jsonDict:dictionary["data"] as! Dictionary<String, AnyObject>)
                    }
                    
                    if(((self.pastEventsResponse?.numberOfItemsPerPage)! * self.pageIndex) == (self.pastEventsResponse?.eventsInfoArray?.count)) {
                        self.isMoreEventAvailable = true
                    } else {
                        self.isMoreEventAvailable = false
                       
                    self.pastEventsTableView.tableFooterView?.isHidden = true
 
                    }
                    
                    
                    self.pastEventsTableView.reloadData()
                }
            }
        }
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pastEventsResponse == nil {
            return 0
        } else
        {
            return (pastEventsResponse?.eventsInfoArray?.count)!;
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 490//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (self.isMoreEventAvailable) {
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
                
                let imageData = NSData(contentsOf: Bundle.main.url(forResource: "animationImg",withExtension: "gif")!)
                let  hudImgView = UIImageView(image: UIImage.sd_animatedGIF(with: imageData as Data!))
                let myNewView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(100)))
                hudImgView.frame = CGRect(x: CGFloat((myNewView.frame.width-100)/2), y: CGFloat(0), width: CGFloat(100), height: CGFloat(100))
                myNewView.addSubview(hudImgView)
                tableView.tableFooterView = myNewView
                self.pastEventsTableView.tableFooterView?.isHidden = false
            }
        } else {
            tableView.tableFooterView = nil
        }
        
    }
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PastEventTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PastEventTableViewCell") as! PastEventTableViewCell
        //cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let eventInfo = pastEventsResponse?.eventsInfoArray?[indexPath.row] as EventInfo!
        cell.eventNameLabel.text = eventInfo?.eventName
        cell.eventTypeLabel.text = eventInfo?.category?.replacingOccurrences(of: "_", with: " ")
        cell.timeLabel.text = eventInfo?.dateTimeStart
        cell.placeLable.text = String.init(format: "%@ (%0.01f miles)", (eventInfo?.eventLocation?.locationName)!,(eventInfo?.eventLocation?.distanceFromDeviceLocation)!)
        cell.placeLable.text =  eventInfo?.eventLocation?.locationName
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
        
        //var nameStr = userFullname
        /*
         cell.profileImageview.sd_setImage(with: URL.init(string: (profileimageURL)!), completed: { (image, error, cacheType, imageURL) in
         })
         
        if (isFanProfile)! {
            if((eventInfo?.eventStatus?.rsvpStatus) != nil){
                nameStr  = userFullname! + " is " + (eventInfo?.eventStatus?.rsvpStatus)!
            }
        } else {
            if((eventInfo?.eventStatus?.rsvpStatus) != nil){
                nameStr  = "You are " + (eventInfo?.eventStatus?.rsvpStatus)!
            }
        }
        */
        
        cell.userNamestatusLable.layer.cornerRadius = 13
        cell.userNamestatusLable.layer.masksToBounds = true
        
        if (isFanProfile)! {
            cell.userNamestatusLable.text = GLOBAL.sharedInstance.RSVPStatusText(eventStatus: (eventInfo?.eventStatus)!, userName: userFullname)
            //cell.userNamestatusLable.sizeToFit()
        } else {
            cell.userNamestatusLable.text = GLOBAL.sharedInstance.RSVPStatusText(eventStatus: (eventInfo?.eventStatus)!, userName: nil)
            //cell.userNamestatusLable.sizeToFit()
            
        }
        
        let width = cell.userNamestatusLable.intrinsicContentSize.width
        cell.userNamestatusLable.frame.size = CGSize.init(width: width, height: 26)
        
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
        
        let truncatedAdminName = String(truncatedEventAdminName.dropLast())

        cell.hostedByLabel.text = String.init(format: "Hosted By %@", truncatedAdminName)
        cell.peopleCountLabel.text = String.init(format: "%ld Attending | %ld Interested", (eventInfo?.facebookAttendingCount)!,(eventInfo?.facebookInterestedCount)!)
        
        cell.eventImageView.setShowActivityIndicator(true)
        cell.eventImageView.setIndicatorStyle(.gray)
        
        if ((eventInfo?.imageurl) != nil) {
            cell.eventImageView.sd_setImage(with: URL(string: (eventInfo?.imageurl)!), placeholderImage: UIImage(named: "default_image"))
        }else{
            cell.eventImageView.image = UIImage(named: "default_image")
        }
        
        return cell
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventInfo = pastEventsResponse?.eventsInfoArray?[indexPath.row] as EventInfo!
        
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
                offset = (pastEventsResponse?.nextIndex)!
                self.isMoreEventAvailable = false;
                self.getListOfPastEvents()
                
            }
        }
    }
    
//        func changeEventButton(interestedButton : UIButton, eventInfo: EventInfo) {
//            if (eventInfo.eventStatus?.isUserArtist)! || (eventInfo.eventStatus?.isUserInterested)! || (eventInfo.eventStatus?.isUserAdmin)! {
//
//                if (eventInfo.eventStatus?.isUserAdmin)! {
//                    if (eventInfo.islive)! {
//                        if (eventInfo.isCancelled)! {
//                            interestedButton .setTitle("UNDO CANCEL", for: UIControlState.normal)
//                            interestedButton .setImage(UIImage.init(named: "undo_cancel"), for: UIControlState.normal)
//                        } else {
//                            interestedButton.setTitle("CANCEL", for: UIControlState.normal)
//                            interestedButton .setImage(UIImage.init(named: "cancel_event"), for: UIControlState.normal)
//                        }
//                    } else {
//                        interestedButton .setTitle("GO LIVE", for: UIControlState.normal)
//                        interestedButton .setImage(UIImage.init(named: "go_live"), for: UIControlState.normal)
//                    }
//
//                    interestedButton.removeTarget(self, action: #selector(interestedButtonEvent(_:)), for: .touchUpInside)
//                    interestedButton.removeTarget(self, action: #selector(joinOrLeaveButtonEvent(_:)), for: .touchUpInside)
//                    interestedButton.addTarget(self, action: #selector(goLiveOrCancelButtonEvent(_:)), for: .touchUpInside)
//
//                } else {
//                    if (eventInfo.eventStatus?.isUserInterested)! {
//                        if (eventInfo.islive)! {
//                            if (eventInfo.eventStatus?.isUserJoined)! {
//                                interestedButton.setTitle("LEAVE", for: UIControlState.normal)
//                                interestedButton .setImage(UIImage.init(named: "leave_event"), for: UIControlState.normal)
//
//                            } else {
//                                interestedButton .setTitle("JOIN", for: UIControlState.normal)
//                                interestedButton .setImage(UIImage.init(named: "join_event"), for: UIControlState.normal)
//
//                            }
//
//                            interestedButton.removeTarget(self, action: #selector(interestedButtonEvent(_:)), for: .touchUpInside)
//                            interestedButton.removeTarget(self, action: #selector(goLiveOrCancelButtonEvent(_:)), for: .touchUpInside)
//                            interestedButton.addTarget(self, action: #selector(joinOrLeaveButtonEvent(_:)), for: .touchUpInside)
//
//                        } else {
//                            interestedButton.setTitle("DELETE", for: UIControlState.normal)
//                            interestedButton .setImage(UIImage.init(named: "delete"), for: UIControlState.normal)
//
//                            interestedButton.removeTarget(self, action: #selector(joinOrLeaveButtonEvent(_:)), for: .touchUpInside)
//                            interestedButton.removeTarget(self, action: #selector(goLiveOrCancelButtonEvent(_:)), for: .touchUpInside)
//                            interestedButton.addTarget(self, action: #selector(interestedButtonEvent(_:)), for: .touchUpInside)
//
//
//                        }
//
//
//                    } else {
//                        interestedButton .setTitle("INTERESTED", for: UIControlState.normal)
//                        interestedButton .setImage(UIImage.init(named: "interested_event"), for: UIControlState.normal)
//
//                        interestedButton.removeTarget(self, action: #selector(joinOrLeaveButtonEvent(_:)), for: .touchUpInside)
//                        interestedButton.removeTarget(self, action: #selector(goLiveOrCancelButtonEvent(_:)), for: .touchUpInside)
//                        interestedButton.addTarget(self, action: #selector(interestedButtonEvent(_:)), for: .touchUpInside)
//
//
//                    }
//                }
//            }
//        }
//
//        @IBAction func interestedButtonEvent(_ sender: UIButton) {
//            let eventIndex = sender.tag as Int!
//
//            let eventInfo = pastEventsResponse?.eventsInfoArray?[eventIndex!] as EventInfo!
//
//            if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
//                if (eventInfo?.eventStatus?.isUserInterested)! {
//                    markEventAsInterested(false,(eventInfo?.eventStatus?.eventId)!)
//                } else {
//                    markEventAsInterested(true,(eventInfo?.eventStatus?.eventId)!)
//                }
//            } else {
//                GLOBAL().showAlert(APPLICATION.applicationName, message: "Login to mark as Interested!", actions: nil)
//            }
//        }
//

   
    
    func refreshList()  {
        offset = 0
        pageIndex = 1
        bolDecelerate = false
        isMoreEventAvailable = false
        
        pastEventsResponse = nil
        self.getListOfPastEvents()
    }
}
