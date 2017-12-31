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
        var isMoreEventAvailable : Bool = false
        var bolDecelerate : Bool = false
        open var isPushVC : Bool?
        open var accountId : Int?
        open var userFullname : String?
        open var profileimageURL : String?
        var upcomingEventsResponse : UNUpcomingEventsResponse?
        
        @IBOutlet weak var noresultLabel: UNLabel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            pastEventsTableView.register(UINib(nibName: "PastEventTableViewCell", bundle: nil), forCellReuseIdentifier: "PastEventTableViewCell")
            
            pastEventsTableView.estimatedRowHeight = pastEventsTableView.rowHeight
            pastEventsTableView.rowHeight = UITableViewAutomaticDimension
            
            
            // Do any additional setup after loading the view.
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated);
            //self.navigationController?.isNavigationBarHidden = true
            
            var isMenuRequired = false
//            if(isPushVC)!{
//                isMenuRequired = false
//            }
//            var title = ""
//            if let fanName = fanName {
//                title = String.init(format: "%@'s Upcoming Events", fanName)
//            } else {
//                title = "My Upcoming Events"
//            }
            
            addCustomNavBar(self, isMenuRequired: isMenuRequired, title: "Past Event", backhandler: {
                if(isMenuRequired) {
                    self.showLeftView()
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            
        }
        
        // MARK: -
        
        override func viewDidAppear(_ animated: Bool) {
            refreshList()
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
        
        func getListOfUserEvents() {
            GLOBAL().showLoadingIndicatorWithMessage("")
            
            UNTZReqeustManager.sharedInstance.apiGetListOfPastEvents(offset, accountId: accountId! ,searchText: "") {
                (feedResponse) -> Void in
                GLOBAL().hideLoadingIndicator()
                
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
                            
                            if(self.upcomingEventsResponse?.numberOfItemsPerPage == self.upcomingEventsResponse?.eventsInfoArray?.count) {
                                self.isMoreEventAvailable = true
                            } else {
                                self.isMoreEventAvailable = false
                            }
                        } else {
                           self.upcomingEventsResponse?.appendData(jsonDict:dictionary)
                        }
                        self.pastEventsTableView.reloadData()
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
            return 500;//Choose your custom row height
        }
        
        // create a cell for each table view row
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell:PastEventTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PastEventTableViewCell") as! PastEventTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            let eventInfo = upcomingEventsResponse?.eventsInfoArray?[indexPath.row] as EventInfo!
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
            cell.profileImageview.sd_setImage(with: URL.init(string: (profileimageURL)!), completed: { (image, error, cacheType, imageURL) in
            })
            var nameStr = userFullname
            if((eventInfo?.eventStatus?.rsvpStatus) != nil){
                nameStr  = userFullname! + " " + (eventInfo?.eventStatus?.rsvpStatus)!
            }
            
            cell.userNamestatusLable.text = nameStr
            
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
            
//            cell.interestedBtn.tag = indexPath.row
//            self.changeEventButton(interestedButton: cell.interestedBtn,eventInfo: eventInfo!)
            
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
                    offset = (upcomingEventsResponse?.nextIndex)!
                    self.isMoreEventAvailable = false;
                    self.getListOfUserEvents()
                    
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
//            let eventInfo = upcomingEventsResponse?.eventsInfoArray?[eventIndex!] as EventInfo!
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
    
        @IBAction func goLiveOrCancelButtonEvent(_ sender: UIButton) {
            let eventIndex = sender.tag as Int!
            
            let eventInfo = upcomingEventsResponse?.eventsInfoArray?[eventIndex!] as EventInfo!
            
            if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
                if (eventInfo?.islive)! {
                    if (eventInfo?.isCancelled)! {
                        markEventAsCanceledOrNot(false,(eventInfo?.eventId)!)
                    } else {
                        markEventAsCanceledOrNot(true,(eventInfo?.eventId)!)
                    }
                    
                } else {
                    goLiveEvent((eventInfo?.eventId)!)
                }
            } else {
                GLOBAL().showAlert(APPLICATION.applicationName, message: "You are not admin!", actions: nil)
                
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
        
        //MARK :- Mark Event as Canceled Or Not
        
        func markEventAsCanceledOrNot(_ isCancelled : Bool, _ eventId : Int) {
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
            offset = 0
            bolDecelerate = false
            isMoreEventAvailable = false
            
            upcomingEventsResponse = nil
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
   

