//
//  EventDetailsViewController.swift
//  UNTZ
//
//  Created by Mahesh on 14/06/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

enum EventStates: Int {
    case MarkAsInterested = 1,
    DeleteEvent,
    JoinEvent,
    LeaveEvent,
    MakeItLive,
    CancelEvent,
    UndoCancelEvent
}

class EventDetailsViewController: UIViewController {

    var eventDetailsResponse : EventDetailsResponse?
    open var eventId : Int?
    open var eventImageURL : String?
    var contentSize : CGFloat?
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var hostedByLabel: FRHyperLabel!
    @IBOutlet weak var placeLable: UNLabel!
    @IBOutlet weak var peopleCountLabel: UNLabel!
    @IBOutlet weak var timeLabel: UNLabel!
    @IBOutlet weak var dateDayLabel: UNLabel!
    @IBOutlet weak var eventNameLabel: UNLabel!
    
    @IBOutlet weak var dateMonthLabel: UNLabel!
    
    @IBOutlet weak var performingLbl: UILabel!
    @IBOutlet weak var performTimeLbl: UILabel!
    @IBOutlet weak var eventTypeLabel: UNLabel!
    @IBOutlet weak var eventTextLabel: UNLabel!
    
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var interestedLabel: UILabel!
    
    @IBOutlet weak var detailview: UIView!
    @IBOutlet weak var shadowview: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var interestedButton: UNButton!
    @IBOutlet weak var artistsButton : UNButton!
    
    @IBOutlet weak var userdisplayView: UIView!
    @IBOutlet weak var DisplayTypeView: UIView!
    @IBOutlet weak var belowButtonView: UIView!
    
    @IBOutlet weak var songImageView : UIImageView!
    @IBOutlet weak var songTitle : UNLabel!
    @IBOutlet weak var artistName : UNLabel!
    
    
    @IBOutlet weak var mainViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var shadowViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var displayTypeHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var currentSongPlayingHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var currentSongPlayingTopSpaceConstraint : NSLayoutConstraint!
    @IBOutlet weak var buttonWidthConstraint : NSLayoutConstraint!
    @IBOutlet weak var buttonHeightConstraint : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 190, green: 20/255, blue: 17/255, alpha: 1)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        self.navigationController?.navigationBar.isHidden = true
        
        
        initSetUp()
        
        self.eventImageView.sd_setImage(with: URL.init(string: eventImageURL!), placeholderImage: UIImage.init(named: "default_image"), options: .refreshCached) { (image, error, imageCacheType, imageUrl) in
            if image != nil {
                let height = image?.size.height
                
                self.mainViewHeightConstraint.constant = 220 + height!
                self.shadowViewHeightConstraint.constant = 230 + height!
                
                self.contentSize = self.shadowViewHeightConstraint.constant
                
            } else {
                
                let image = UIImage.init(named: "default_image")
                //self.eventImageView.setIm
                let height = image?.size.height
                
                self.mainViewHeightConstraint.constant = 220 + height!
                self.shadowViewHeightConstraint.constant = 230 + height!
                
                self.contentSize = self.shadowViewHeightConstraint.constant
            }
        }
        
        /*self.eventImageView.sd_setImage(with: URL.init(string: eventImageURL!))      { (image, error, imageCacheType, imageUrl) in
            
            if image != nil {
                let height = image?.size.height
                
                self.mainViewHeightConstraint.constant = 220 + height!
                self.shadowViewHeightConstraint.constant = 230 + height!
                
                self.contentSize = self.shadowViewHeightConstraint.constant

            } else {
              
                let image = UIImage.init(named: "default_image")
                //self.eventImageView.setIm
                let height = image?.size.height
                
                self.mainViewHeightConstraint.constant = 220 + height!
                self.shadowViewHeightConstraint.constant = 230 + height!
                
                self.contentSize = self.shadowViewHeightConstraint.constant
            }
        }
        */
        shadowview.setViewShadow()
        
        profileImageview.layer.cornerRadius = profileImageview.frame.size.height/2
        profileImageview.clipsToBounds = true

        if (UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.Imageurl) != nil) {
            profileImageview.sd_setImage(with: URL(string: UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.Imageurl) as! String), placeholderImage: nil)
        }

        self.getEventDetails()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        //self.scrollview.contentSize = CGSize.init(width: self.scrollview.frame.size.width, height: self.contentSize!)

    }
    
    func initSetUp() -> Void {
        mainView.layer.cornerRadius = 5.0
        mainView.clipsToBounds = true
        self.contentSize = 0.0
        scrollview.isHidden = true

        interestedButton.layer.borderColor = UIColor.red.cgColor
        interestedButton.layer.borderWidth = 0.5
        interestedButton.layer.cornerRadius = 3.6
        interestedButton.clipsToBounds = true
        
        artistsButton.layer.borderColor = UIColor.red.cgColor
        artistsButton.layer.borderWidth = 0.5
        artistsButton.layer.cornerRadius = 3.6
        artistsButton.clipsToBounds = true
        
        buttonWidthConstraint.constant = DYNAMICFONTSIZE.SCALE_FACT_FONT * 88;
        buttonHeightConstraint.constant = DYNAMICFONTSIZE.SCALE_FACT_FONT * 88;
        
        
        let eventDetailTapGesturer = UITapGestureRecognizer.init(target: self, action: #selector(openEventDetailsOnFacebook))
        self.peopleCountLabel.addGestureRecognizer(eventDetailTapGesturer)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK :- Get Event Details
    
    func getEventDetails() {
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiGetEventDetails(self.eventId!) {
            (feedResponse) -> Void in
            GLOBAL().hideLoadingIndicator()
            
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                GLOBAL().hideLoadingIndicator()
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    self.eventDetailsResponse = EventDetailsResponse.init(jsonDict:dictionary["data"] as! Dictionary<String, AnyObject>)
                    
                    print("\(String(describing: self.eventDetailsResponse?.userEventDetails?.eventInfo?.category))")
                    
                    self.displayUI()
                }
            }
        }
    }

    func displayUI() {
        if(eventDetailsResponse?.userEventDetails?.eventInfo?.islive)! {
            self.getCurrentlyPlayingTrack()
        }
        
        self.eventNameLabel.text = self.eventDetailsResponse?.userEventDetails?.eventInfo?.eventName
        self.eventTypeLabel.text = self.eventDetailsResponse?.userEventDetails?.eventInfo?.category?.replacingOccurrences(of: "_", with: " ")
        self.timeLabel.text = self.eventDetailsResponse?.userEventDetails?.eventInfo?.dateTimeStart
        if let distance  = self.eventDetailsResponse?.userEventDetails?.eventInfo?.distanceFromDeviceLocation {
            self.placeLable.text = String.init(format: "%@ (%0.01f miles)", (self.eventDetailsResponse?.userEventDetails?.eventInfo?.eventLocation?.locationName)!,distance)
        } else {
            self.placeLable.text = String.init(format: "%@ (0.0 miles)", (self.eventDetailsResponse?.userEventDetails?.eventInfo?.eventLocation?.locationName)!)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" //Your date format //yyyy-MM-dd'T'HH:mm:ss-mm:ss
        dateFormatter.timeZone = NSTimeZone(name: "PT") as TimeZone!
        let date = dateFormatter.date(from: (self.eventDetailsResponse?.userEventDetails?.eventInfo?.dateTimeStart)!) //according to date format your date string
        if self.eventDetailsResponse?.userEventDetails?.eventInfo?.dateTimeEnd != nil {
            let endDate = dateFormatter.date(from: (self.eventDetailsResponse?.userEventDetails?.eventInfo?.dateTimeEnd)!) //according to date
            if (endDate != nil && date != nil){
                dateFormatter.dateFormat = "EEE h:mm a"
                let dateName = dateFormatter.string(from: date!)
                
                dateFormatter.dateFormat = "h:mm a"
                let endDateName = dateFormatter.string(from: endDate!)
                self.timeLabel.text = String.init(format: "%@ - %@", dateName,endDateName)
                
            }
            else{
                self.timeLabel.text = ""
            }
        }
        else if (date != nil){
            dateFormatter.dateFormat = "EEE h:mm a"
            let dateName = dateFormatter.string(from: date!)
            self.timeLabel.text = dateName
        }
        
        if (date != nil){
            dateFormatter.dateFormat = "MMM"
            let monthName = dateFormatter.string(from: date!)
            self.dateMonthLabel.text = monthName
            
            dateFormatter.dateFormat = "dd"
            let datefmt = dateFormatter.string(from: date!)
            self.dateDayLabel.text = datefmt
            
        }  else{
            self.dateMonthLabel.text = ""
            self.dateDayLabel.text = ""
        }
        
        var eventAdminName : String = ""
        var charactersArray: [String] = []
        
        for eventAdmin in (self.eventDetailsResponse?.userEventDetails?.eventInfo?.eventAdminsArray)! {
            eventAdminName.append(eventAdmin.adminName! + ",")
            charactersArray.append(eventAdmin.adminName!)
        }
        let truncatedEventAdminName = String(eventAdminName.characters.dropLast())
        
        self.hostedByLabel.text = String.init(format: "Hosted By %@", truncatedEventAdminName)
        let attributes = [NSForegroundColorAttributeName: UIColor(red: 190, green: 20/255, blue: 17/255, alpha: 1),
                          NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)]
        
        self.hostedByLabel.attributedText = NSAttributedString(string: self.hostedByLabel.text!, attributes: attributes)
        //Step 2: Define a selection handler block
        let handler = {
            (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            self.openEventDetailsOnFacebookNew(strName: substring!)
        }
        
        //Step 3: Add link substrings
        self.hostedByLabel.setLinksForSubstrings(charactersArray, withLinkHandler: handler)
        self.hostedByLabel.isUserInteractionEnabled = true
        
        self.peopleCountLabel.text = String.init(format: "%ld Attending | %ld Interested", (self.eventDetailsResponse?.userEventDetails?.eventInfo?.facebookAttendingCount)!,(self.eventDetailsResponse?.userEventDetails?.eventInfo?.facebookInterestedCount)!)
 performTimeLbl.text = timediffernce()
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            
            if (eventDetailsResponse?.userEventDetails?.isUserArtist)! || (eventDetailsResponse?.userEventDetails?.isUserInterested)! || (eventDetailsResponse?.userEventDetails?.isUserAdmin)! {
                userdisplayView.isHidden = false
                
                displayTypeHeightConstraint.constant = 70.0
                
                self.contentSize = self.contentSize! + self.displayTypeHeightConstraint.constant

                if (eventDetailsResponse?.userEventDetails?.isUserAdmin)! {
                    if (eventDetailsResponse?.userEventDetails?.eventInfo?.islive)! {
                        if (eventDetailsResponse?.userEventDetails?.eventInfo?.isCancelled)! {
                            interestedLabel.isHidden = false
                            performingLbl.isHidden = false
                            performTimeLbl.isHidden = true
                            eventTextLabel.isHidden = true

                            performingLbl.text = "You are Hosting"
                            interestedLabel.text = "This Event Has Been Cancelled!"
                            interestedButton.setTitle("UNDO CANCEL", for: UIControlState.normal)
                            interestedButton .setImage(UIImage.init(named: "undo_cancel"), for: UIControlState.normal)
                            interestedButton.tag = EventStates.UndoCancelEvent.rawValue
                            
                        } else {
                            interestedLabel.isHidden = true
                            performingLbl.isHidden = false
                            performTimeLbl.isHidden = false
                            eventTextLabel.isHidden = true

                            performingLbl.text = "You are Hosting"
                            performTimeLbl.text = timediffernce()
                            interestedButton.setTitle("CANCEL", for: UIControlState.normal)
                            interestedButton .setImage(UIImage.init(named: "cancel_event"), for: UIControlState.normal)
                            interestedButton.tag = EventStates.CancelEvent.rawValue
                            
                        }
                        
                    } else {
                        interestedLabel.isHidden = true
                        performingLbl.isHidden = false
                        performTimeLbl.isHidden = false
                        eventTextLabel.isHidden = true

                        performingLbl.text = "You are Hosting"
                        interestedButton .setTitle("GO LIVE", for: UIControlState.normal)
                        interestedButton .setImage(UIImage.init(named: "go_live"), for: UIControlState.normal)
                        interestedButton.tag = EventStates.MakeItLive.rawValue
                    }
                } else {
                    if (eventDetailsResponse?.userEventDetails?.isUserInterested)! {
                        if (eventDetailsResponse?.userEventDetails?.eventInfo?.islive)! {
                            if (eventDetailsResponse?.userEventDetails?.isUserJoined)! {
                                interestedLabel.isHidden = true
                                performingLbl.isHidden = false
                                performTimeLbl.isHidden = false
                                eventTextLabel.isHidden = true
                                
                                performingLbl.text = "You have Joined"
                                //performTimeLbl.text = "Went Live 6 hours ago!"
                                performTimeLbl.text = timediffernce()
                                interestedButton.setTitle("LEAVE", for: UIControlState.normal)
                                interestedButton .setImage(UIImage.init(named: "leave_event"), for: UIControlState.normal)
                                interestedButton.tag = EventStates.LeaveEvent.rawValue
                                
                            } else {
                                interestedLabel.isHidden = true
                                performingLbl.isHidden = false
                                performTimeLbl.isHidden = false
                                eventTextLabel.isHidden = true
                                
                                //performTimeLbl.text = "Went Live 6 hours ago!"
                                performTimeLbl.text = timediffernce()
                                performingLbl.text = "You are Interested"
                                interestedButton .setTitle("JOIN", for: UIControlState.normal)
                                interestedButton .setImage(UIImage.init(named: "join_event"), for: UIControlState.normal)
                                interestedButton.tag = EventStates.JoinEvent.rawValue
                                
                            }
                        } else {
                            interestedLabel.isHidden = false
                            performingLbl.isHidden = true
                            performTimeLbl.isHidden = true
                            eventTextLabel.isHidden = true
                            
                            interestedButton.setTitle("DELETE", for: UIControlState.normal)
                            interestedButton .setImage(UIImage.init(named: "delete"), for: UIControlState.normal)
                            interestedButton.tag = EventStates.DeleteEvent.rawValue
                        }
                        
                        
                    } else {
                        interestedLabel.isHidden = true
                        eventTextLabel.isHidden = false
                        interestedButton .setTitle("INTERESTED", for: UIControlState.normal)
                        interestedButton .setImage(UIImage.init(named: "interested_event"), for: UIControlState.normal)
                        interestedButton.tag = EventStates.MarkAsInterested.rawValue
                        
                    }
                }
                
                
                if (eventDetailsResponse?.userEventDetails?.isUserArtist)! {
                    //performingLbl.isHidden = false
                    //performTimeLbl.text = "You are performming!"
                }
                
                eventTextLabel.isHidden = true
            } else {
                eventTextLabel.isHidden = false
                
                interestedLabel.isHidden = true
                interestedButton .setTitle("INTERESTED", for: UIControlState.normal)
                interestedButton .setImage(UIImage.init(named: "interested_event"), for: UIControlState.normal)
                interestedButton.tag = EventStates.MarkAsInterested.rawValue
            }
            
            
        } else {
            eventTextLabel.isHidden = false
        }
        
        self.contentSize = self.contentSize! + 125 + 80
        
        self.scrollview.contentSize = CGSize.init(width: self.scrollview.frame.size.width, height: self.contentSize!)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollview.isHidden = false
            self.view.layoutIfNeeded()
        })
        
    }
    
    func getCurrentlyPlayingTrack() {
        //GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiGetCurrentlyPlayingTrack(self.eventId!) { (feedResponse) -> Void in
            //GLOBAL().hideLoadingIndicator()
            
            if let downloadError = feedResponse.error {
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                //GLOBAL().hideLoadingIndicator()
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject> {
                    print(dictionary)
                    if let dataDict = dictionary["data"] as? Dictionary<String,AnyObject> {
                        self.displayLiveSong(dataDict)
                    }
                    
                }
            }
        }
    }

    func displayLiveSong(_ data: Dictionary<String, AnyObject>) -> Void {
        let curretntlyEventPlayingTrack = data["EventPlaylistTrack"] as! Dictionary<String,AnyObject>
        
        let songName = curretntlyEventPlayingTrack["spotifyTrackName"] as! String
        let imagePath = curretntlyEventPlayingTrack["spotifyAlbumImageUri"] as! String
        let artistsArray = curretntlyEventPlayingTrack["eventTrackArtists"] as! Array<Dictionary<String,AnyObject>>
        
        let artistDict = artistsArray[0] 
        let artistNameValue = artistDict["name"] as! String
        
        songTitle.text = songName
        artistName.text = artistNameValue
        
        songImageView.layer.cornerRadius = profileImageview.frame.size.height/2
        songImageView.clipsToBounds = true

        songImageView.sd_setImage(with: URL.init(string: imagePath))
        
        UIView.animate(withDuration: 0.5, animations: {
            self.userdisplayView.isHidden = false
            self.currentSongPlayingHeightConstraint.constant = 70
            self.view.layoutIfNeeded()
        })
        
    }
    //MARK :- Mark Event as Interested Or Not
    
    func markEventAsInterested(_ interested : Bool) {
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiMarkEventAsInterestedOrNot(self.eventId!, isInterested: interested) {
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
                        self.eventDetailsResponse?.userEventDetails?.isUserInterested = interested
                        self.changeViewToInterested()
                        
                    } else {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                    }
                }
            }
        }
    }
    
    //MARK :- Mark Event as Canceled Or Not
    
    func markEventAsCanceledOrNot(_ isCancelled : Bool) {
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiMarkEventAsCanceledOrNot(self.eventId!, isCancelled: isCancelled) {
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
                        self.eventDetailsResponse?.userEventDetails?.eventInfo?.isCancelled = isCancelled
                        self.changeViewToLiveOrCancel()
                    } else {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                    }

                }
            }
        }
    }

    // MARK: Mark Event as Go Live
    
    func goLiveEvent() {
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiGoLiveEvent(self.eventId!) {
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
                        self.eventDetailsResponse?.userEventDetails?.eventInfo?.islive = true
                        self.changeViewToLiveOrCancel()
                    } else {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                    }

                }
            }
        }
    }

    //MARK: Join Event or Leave Event
    
    func joinOrLeaveEvent(_ isLeaving : Bool) {
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiJoinOrLeaveEvent(self.eventId!, isLeaving: isLeaving) {
            (feedResponse) -> Void in
            GLOBAL().hideLoadingIndicator()
            
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                GLOBAL().hideLoadingIndicator()
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    print("\(dictionary)")
                    
                    let dataValue = dictionary["data"] as! Bool!
                    
                    if dataValue == true {
                        self.eventDetailsResponse?.userEventDetails?.isUserJoined = !isLeaving
                        self.changeViewToJoinOrLeave()
                    } else {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                    }

                }
            }
        }
    }

    @IBAction func interestedButtonEvent(_ sender: UIButton) {
        let eventStateValue = sender.tag as Int!
        
        if (eventStateValue == EventStates.MarkAsInterested.rawValue || eventStateValue == EventStates.DeleteEvent.rawValue) {
            markAsInterestedEvent()
        } else if (eventStateValue == EventStates.JoinEvent.rawValue || eventStateValue == EventStates.LeaveEvent.rawValue) {
            joinEventPlatform()
        } else if (eventStateValue == EventStates.MakeItLive.rawValue || eventStateValue == EventStates.CancelEvent.rawValue || eventStateValue == EventStates.UndoCancelEvent.rawValue) {
            liveEventPlatform()
        }
        
    }

    func markAsInterestedEvent() {
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            if (eventDetailsResponse?.userEventDetails?.isUserInterested)! {
                markEventAsInterested(false)
                interestedLabel.isHidden = false
                performingLbl.isHidden = true
                performTimeLbl.isHidden = true
                eventTextLabel.isHidden = true
                interestedButton .setTitle("DELETE", for: UIControlState.normal)
                interestedButton .setImage(UIImage.init(named: "delete"), for: UIControlState.normal)
            } else {
                markEventAsInterested(true)
                interestedLabel.isHidden = true
                performingLbl.isHidden = false
                performTimeLbl.isHidden = false
                eventTextLabel.isHidden = false
                interestedButton .setTitle("INTERESTED", for: UIControlState.normal)
                interestedButton .setImage(UIImage.init(named: "interested_event"), for: UIControlState.normal)
            }
        } else {
            GLOBAL().showAlert(APPLICATION.applicationName, message: "Login to mark as Interested!", actions: nil)
            
        }
    }
    
    // MARK: LIVE Event Platform
    
    func liveEventPlatform() {
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            if (eventDetailsResponse?.userEventDetails?.eventInfo?.islive)! {
                if (eventDetailsResponse?.userEventDetails?.eventInfo?.isCancelled)! {
                    markEventAsCanceledOrNot(false)
                } else {
                    markEventAsCanceledOrNot(true)
                }
                
//                interestedButton.setTitle("LIVE", for: UIControlState.normal)
//                interestedButton .setImage(UIImage.init(named: "go_live"), for: UIControlState.normal)
            } else {
                goLiveEvent()
//                interestedButton.setTitle("CANCEL", for: UIControlState.normal)
//                interestedButton .setImage(UIImage.init(named: "cancel_event"), for: UIControlState.normal)
            }
        } else {
            GLOBAL().showAlert(APPLICATION.applicationName, message: "You are not admin!", actions: nil)
            
        }
    }
    
    // MARK: JOIN Event Platform
    func joinEventPlatform() {
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            if (eventDetailsResponse?.userEventDetails?.isUserJoined)! {
                joinOrLeaveEvent(true)
                interestedButton.setTitle("LEAVE", for: UIControlState.normal)
                interestedButton .setImage(UIImage.init(named: "leave_event"), for: UIControlState.normal)
            } else {
                joinOrLeaveEvent(false)
                interestedButton.setTitle("JOIN", for: UIControlState.normal)
                interestedButton .setImage(UIImage.init(named: "join_event"), for: UIControlState.normal)
            }
        } else {
            GLOBAL().showAlert(APPLICATION.applicationName, message: "Login to Join Event!", actions: nil)
        }
    }
    
    // MARK: Change View To Interested
    func changeViewToInterested () {
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            if (eventDetailsResponse?.userEventDetails?.isUserInterested)! {
                interestedLabel.isHidden = false
                eventTextLabel.isHidden = true
                performingLbl.isHidden = true
                performTimeLbl.isHidden = true

                interestedButton.setTitle("DELETE", for: UIControlState.normal)
                interestedButton .setImage(UIImage.init(named: "delete"), for: UIControlState.normal)
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.userdisplayView.isHidden = false
                    self.view.layoutIfNeeded()
                })

            } else {
                interestedLabel.isHidden = true
                eventTextLabel.isHidden = false
                performingLbl.isHidden = true
                performTimeLbl.isHidden = true

                interestedButton .setTitle("INTERESTED", for: UIControlState.normal)
                interestedButton .setImage(UIImage.init(named: "interested_event"), for: UIControlState.normal)
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.userdisplayView.isHidden = true
                    
                    self.view.layoutIfNeeded()
                })

            }
        } else {
            userdisplayView.isHidden = true
        }

    }

    // MARK: Change View To Join Or Leave
    func changeViewToJoinOrLeave () {
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            if (eventDetailsResponse?.userEventDetails?.eventInfo?.islive)! {
                if (eventDetailsResponse?.userEventDetails?.isUserJoined)! {
                    interestedLabel.isHidden = true
                    performingLbl.isHidden = false
                    performTimeLbl.isHidden = false
                    eventTextLabel.isHidden = true
                    
                    performingLbl.text = "You have Joined"
                    performTimeLbl.text = "Went Live 6 hours ago!"
                    eventTextLabel.isHidden = true
                    interestedButton.setTitle("LEAVE", for: UIControlState.normal)
                    interestedButton .setImage(UIImage.init(named: "leave_event"), for: UIControlState.normal)
                    interestedButton.tag = EventStates.LeaveEvent.rawValue

                UIView.animate(withDuration: 1.0, animations: {
                    self.userdisplayView.isHidden = false
                    self.view.layoutIfNeeded()
                })
                }
            } else {
                interestedLabel.isHidden = true
                performingLbl.isHidden = false
                performTimeLbl.isHidden = false
                eventTextLabel.isHidden = true
                
                performTimeLbl.text = "Went Live 6 hours ago!"
                interestedLabel.text = "You are Interested"
                interestedButton .setTitle("JOIN", for: UIControlState.normal)
                interestedButton .setImage(UIImage.init(named: "join_event"), for: UIControlState.normal)
                interestedButton.tag = EventStates.JoinEvent.rawValue
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.userdisplayView.isHidden = true
                    
                    self.view.layoutIfNeeded()
                })
                
            }
        } else {
            userdisplayView.isHidden = true
        }
        
    }

    // MARK: Change View To Live And Cancel
    func changeViewToLiveOrCancel () {
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            if (eventDetailsResponse?.userEventDetails?.isUserAdmin)! {
                if (eventDetailsResponse?.userEventDetails?.eventInfo?.islive)! {
                    if (eventDetailsResponse?.userEventDetails?.eventInfo?.isCancelled)! {
                        interestedLabel.isHidden = false
                        performingLbl.isHidden = false
                        performTimeLbl.isHidden = true
                        performingLbl.text = "You are Hosting"
                        interestedLabel.text = "This Event Has Been Cancelled!"
                        eventTextLabel.isHidden = true
                        interestedButton.setTitle("UNDO CANCEL", for: UIControlState.normal)
                        interestedButton .setImage(UIImage.init(named: "undo_cancel"), for: UIControlState.normal)
                        interestedButton.tag = EventStates.UndoCancelEvent.rawValue
                        
                    } else {
                        interestedLabel.isHidden = true
                        performingLbl.isHidden = false
                        performTimeLbl.isHidden = false

                        performingLbl.text = "You are Hosting"
                        performTimeLbl.text = timediffernce()
                        eventTextLabel.isHidden = true
                        interestedButton.setTitle("CANCEL", for: UIControlState.normal)
                        interestedButton .setImage(UIImage.init(named: "cancel_event"), for: UIControlState.normal)
                        interestedButton.tag = EventStates.CancelEvent.rawValue
                        
                    }
                    
                } else {
                    interestedLabel.isHidden = false
                    eventTextLabel.isHidden = true
                    performingLbl.isHidden = true
                    interestedLabel.text = "You are Hosting"
                    interestedButton .setTitle("GO LIVE", for: UIControlState.normal)
                    interestedButton .setImage(UIImage.init(named: "go_live"), for: UIControlState.normal)
                    interestedButton.tag = EventStates.MakeItLive.rawValue
                }
            }
        } else {
            userdisplayView.isHidden = true
        }
        
    }

    
    func openEventDetailsOnFacebook()  {
        let facebookEventURL = String.init(format: "https://www.facebook.com/%@", (eventDetailsResponse?.userEventDetails?.eventInfo?.facebookid)!)
        if UIApplication.shared.canOpenURL(URL.init(string: facebookEventURL)!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open((URL.init(string: facebookEventURL)!), options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL.init(string: facebookEventURL)!)
            }
        }
    }
    func openEventDetailsOnFacebookNew(strName :String)  {
        
        var eventadminid : String
        eventadminid = strName
        for eventAdmin in (self.eventDetailsResponse?.userEventDetails?.eventInfo?.eventAdminsArray)! {
            if eventAdmin.adminName == strName{
                eventadminid = eventAdmin.facebookUserId!
            }
        }
        let facebookEventURL = String.init(format: "https://www.facebook.com/%@", eventadminid)
        //(eventDetailsResponse?.userEventDetails?.eventInfo?.facebookid)!
        if UIApplication.shared.canOpenURL(URL.init(string: facebookEventURL)!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open((URL.init(string: facebookEventURL)!), options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL.init(string: facebookEventURL)!)
            }
        }
    }
    
    @IBAction func whatsHappeningButtonEvent(_ sender: Any) {
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDFeedPostVC") as! FeedPostViewController
            detailObj.eventId = eventId
            pushStoryObj(obj: detailObj, on: self)
        }
        else {
            GLOBAL().showAlert(APPLICATION.applicationName, message: "Login to join the conversation!", actions: nil)
            
        }
    }
    
    @IBAction func requestsButtonEvent(_ sender: Any) {
        GLOBAL().showAlert(APPLICATION.applicationName, message: "Under Progress!", actions: nil)
    }
    
    @IBAction func aboutUsButtonEvent(_ sender: Any) {
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDEventAboutVC") as! AboutDetailViewController
        detailObj.detailTxt = self.eventDetailsResponse?.userEventDetails?.eventInfo?.eventDescription
        detailObj.LocationTxt = (self.eventDetailsResponse?.userEventDetails?.eventInfo?.eventLocation?.locationName)
        pushStoryObj(obj: detailObj, on: self)
    }
    
    @IBAction func artistButtonEvent(_ sender: Any) {
        GLOBAL().showAlert(APPLICATION.applicationName, message: "Under Progress!", actions: nil)

    }
    
    func timediffernce() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ" //Your date format //yyyy-MM-dd'T'HH:mm:ss-mm:ss
        
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(name: "PT") as TimeZone!
        if self.eventDetailsResponse?.userEventDetails?.eventInfo?.islivedatetime != nil {
            let date = dateFormatter.date(from: (self.eventDetailsResponse?.userEventDetails?.eventInfo?.islivedatetime)!) //according to date format your date string
            let now = Date()
            let timeOffset = now.offset(from:date! ) //
            return ("Went live \(timeOffset) ago")
        } else {
            return ("Went live few mins ago")
        }
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
