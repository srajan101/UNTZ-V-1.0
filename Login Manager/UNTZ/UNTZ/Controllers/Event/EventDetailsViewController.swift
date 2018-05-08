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

class EventDetailsViewController: UIViewController, UIGestureRecognizerDelegate {

    var eventDetailsResponse : EventDetailsResponse?
    open var eventId : Int?
    open var eventImageURL : String?
    //var contentSize : CGFloat?
    
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
    
    @IBOutlet weak var detailview: UIView!
    @IBOutlet weak var shadowview: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var interestedButton: UNButton!
    @IBOutlet weak var artistsButton : UNButton!
    @IBOutlet weak var happeningTextButton: UNButton!
    @IBOutlet weak var requestTextButton: UNButton!
    @IBOutlet weak var playlistTextButton: UNButton!
    @IBOutlet weak var userdisplayView: UIView!
    @IBOutlet weak var DisplayTypeView: UIView!
    @IBOutlet weak var belowButtonView: UIView!
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var songImageView : UIImageView!
    @IBOutlet weak var songTitle : UNLabel!
    @IBOutlet weak var artistName : UNLabel!
    
    @IBOutlet weak var buttonViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var shadowViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var displayTypeHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var currentSongPlayingHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var currentSongPlayingTopSpaceConstraint : NSLayoutConstraint!
    @IBOutlet weak var buttonWidthConstraint : NSLayoutConstraint!
    @IBOutlet weak var buttonHeightConstraint : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initSetUp()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.imageDidLoadNotification(withNotification:)), name: NSNotification.Name(rawValue: "ReloadEventDetails"), object: nil)
        
        self.eventImageView.sd_setImage(with: URL.init(string: eventImageURL!))      { (image, error, imageCacheType, imageUrl) in
            
            DispatchQueue.main.async {
                if image != nil {
                    let height = 250
                    
                    self.mainViewHeightConstraint.constant = CGFloat(230 + height)
                    self.shadowViewHeightConstraint.constant = CGFloat(240 + height)
                    
                    //self.contentSize = self.shadowViewHeightConstraint.constant
                    self.contentViewHeightConstraint.constant = self.shadowViewHeightConstraint.constant
                } else {
                  
                    self.eventImageView.image = UIImage.init(named: "default_image")
                    let height = 250
                    
                    self.mainViewHeightConstraint.constant = CGFloat(230 + height)
                    self.shadowViewHeightConstraint.constant = CGFloat(240 + height)
                    
                    //self.contentSize = self.shadowViewHeightConstraint.constant
                    self.contentViewHeightConstraint.constant = self.shadowViewHeightConstraint.constant
                }
            }
            
            self.getEventDetails()
        }
        
        
        
        let tapGestureImg = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(sender:)))
        self.eventImageView.isUserInteractionEnabled = true
        self.eventImageView.addGestureRecognizer(tapGestureImg)
        
        shadowview.setViewShadow()
        
        profileImageview.layer.cornerRadius = profileImageview.frame.size.height/2
        profileImageview.clipsToBounds = true

        if (UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.Imageurl) != nil) {
            profileImageview.sd_setImage(with: URL(string: UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.Imageurl) as! String), placeholderImage: nil)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        profileImageview.isUserInteractionEnabled = true
        profileImageview.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        //self.scrollview.contentSize = CGSize.init(width: self.scrollview.frame.size.width, height: self.contentSize!)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        //self.navigationController?.isNavigationBarHidden = true
        addCustomNavBar(self, isMenuRequired: false, title: "Event Details", backhandler: {
            self.navigationController?.popViewController(animated: true)
        })
        
        addPersonalizeNavBar(self, leftButtonTitle: nil, rightButtonTitle: "", rightButtonImage: "aboutBtn", title: "Event Details", backhandler: {
            self.navigationController?.popViewController(animated: true)
            
        }) {
            self.aboutUsButtonEvent()
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReloadEventDetails"), object: nil)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
        self.contentSize = 0.0
        
        self.eventImageView.sd_setImage(with: URL.init(string: eventImageURL!), placeholderImage: UIImage.init(named: "default_image"), options: .refreshCached) { (image, error, imageCacheType, imageUrl) in
            
            if image != nil {
                let height = 250
                self.mainViewHeightConstraint.constant = CGFloat(250 + height)
                self.shadowViewHeightConstraint.constant = CGFloat(260 + height)
                
                self.contentSize = self.shadowViewHeightConstraint.constant
                
            } else {
                
                let image = UIImage.init(named: "default_image")
                //self.eventImageView.setIm
                let height = image?.size.height
                
                self.mainViewHeightConstraint.constant = 250 + height!
                self.shadowViewHeightConstraint.constant = 260 + height!
                
                self.contentSize = self.shadowViewHeightConstraint.constant
            }
            
        }
        self.getEventDetails()
         */
    }

    @objc func imageDidLoadNotification(withNotification notification: NSNotification) {
        let height = 250
        
        self.mainViewHeightConstraint.constant = CGFloat(230 + height)
        self.shadowViewHeightConstraint.constant = CGFloat(240 + height)
        
        //self.contentSize = self.shadowViewHeightConstraint.constant
        self.contentViewHeightConstraint.constant = self.shadowViewHeightConstraint.constant
        self.getEventDetails()
    }
    
    
    func initSetUp() -> Void {
        happeningTextButton.titleLabel?.textAlignment = .center
        requestTextButton.titleLabel?.textAlignment = .center
        playlistTextButton.titleLabel?.textAlignment = .center
        
        mainView.layer.cornerRadius = 5.0
        mainView.clipsToBounds = true
        //self.contentSize = 0.0
        scrollview.isHidden = true

        interestedButton.layer.borderColor = UIColor.red.cgColor
        interestedButton.layer.borderWidth = 0.5
        interestedButton.layer.cornerRadius = 3.6
        interestedButton.clipsToBounds = true
        
        artistsButton.layer.borderColor = UIColor.red.cgColor
        artistsButton.layer.borderWidth = 0.5
        artistsButton.layer.cornerRadius = 3.6
        artistsButton.clipsToBounds = true
        
        buttonWidthConstraint.constant = DYNAMICFONTSIZE.SCALE_FACT_FONT * 68;
        buttonHeightConstraint.constant = DYNAMICFONTSIZE.SCALE_FACT_FONT * 68;
        
        self.buttonViewHeightConstraint.constant = (DYNAMICFONTSIZE.SCALE_FACT_FONT * 68) + 70
        
        let eventDetailTapGesturer = UITapGestureRecognizer.init(target: self, action: #selector(openEventDetailsOnFacebook))
        self.peopleCountLabel.addGestureRecognizer(eventDetailTapGesturer)

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
                    
                    DispatchQueue.main.async {
                        self.displayUI()
                    }
                }
            }
        }
    }
    
    func RSVPStatusManagement() {
        if let RSVPStatusText = GLOBAL.sharedInstance.RSVPStatusText(eventStatus: (eventDetailsResponse?.eventInfo?.eventStatus)!, userName: nil) {
            performingLbl.isHidden = false
            performingLbl.text = RSVPStatusText
            eventTextLabel.isHidden = true
            performingLbl.layer.cornerRadius = 13
            performingLbl.layer.masksToBounds = true
            
            let width = performingLbl.intrinsicContentSize.width
            performingLbl.frame.size = CGSize.init(width: width, height: 26)
            
            if (eventDetailsResponse?.eventInfo?.islive)! {
                displayTypeHeightConstraint.constant = 60.0
            } else {
                displayTypeHeightConstraint.constant = 40.0
            }
            
        } else {
            eventTextLabel.isHidden = false
            performingLbl.isHidden = true
            displayTypeHeightConstraint.constant = 0.0
            
        }
    }

    func displayUI() {
        RSVPStatusManagement()
        
        if(eventDetailsResponse?.eventInfo?.islive)! {
            self.getCurrentlyPlayingTrack()
        }
        
        self.eventNameLabel.text = self.eventDetailsResponse?.eventInfo?.eventName
        self.eventTypeLabel.text = self.eventDetailsResponse?.eventInfo?.category?.replacingOccurrences(of: "_", with: " ")
        self.timeLabel.text = self.eventDetailsResponse?.eventInfo?.dateTimeStart
        
            self.placeLable.text = String.init(format: "%@", (self.eventDetailsResponse?.eventInfo?.eventLocation?.locationName)!)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" //Your date format //yyyy-MM-dd'T'HH:mm:ss-mm:ss
        dateFormatter.timeZone = NSTimeZone(name: "PT") as TimeZone!
        let date = dateFormatter.date(from: (self.eventDetailsResponse?.eventInfo?.dateTimeStart)!) //according to date format your date string
        if self.eventDetailsResponse?.eventInfo?.dateTimeEnd != nil {
            let endDate = dateFormatter.date(from: (self.eventDetailsResponse?.eventInfo?.dateTimeEnd)!) //according to date
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
        
        for eventAdmin in (self.eventDetailsResponse?.eventInfo?.eventAdminsArray)! {
            eventAdminName.append(eventAdmin.adminName! + ", ")
            charactersArray.append(eventAdmin.adminName!)
        }
        var truncatedEventAdminName = String(eventAdminName.dropLast())
        truncatedEventAdminName = String(truncatedEventAdminName.dropLast())
        
        self.hostedByLabel.text = String.init(format: "Hosted By %@", truncatedEventAdminName)
        //let attributes = [NSForegroundColorAttributeName: UIColor(red: 190, green: 20/255, blue: 17/255, alpha: 1),
                          //NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)]
        
        //self.hostedByLabel.attributedText = NSAttributedString(string: self.hostedByLabel.text!, attributes: attributes)
        //Step 2: Define a selection handler block
        let handler = {
            (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            self.openEventDetailsOnFacebookNew(strName: substring!)
        }
        
        //Step 3: Add link substrings
        self.hostedByLabel.setLinksForSubstrings(charactersArray, withLinkHandler: handler)
        self.hostedByLabel.isUserInteractionEnabled = true
        
        self.peopleCountLabel.text = String.init(format: "%ld Attending | %ld Interested", (self.eventDetailsResponse?.eventInfo?.facebookAttendingCount)!,(self.eventDetailsResponse?.eventInfo?.facebookInterestedCount)!)
        
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            
            if (eventDetailsResponse?.eventInfo?.eventStatus?.isUserArtist)! || (eventDetailsResponse?.eventInfo?.eventStatus?.isUserInterested)! || (eventDetailsResponse?.eventInfo?.eventStatus?.isUserJoined)! || (eventDetailsResponse?.eventInfo?.eventStatus?.isUserAdmin)! {
                userdisplayView.isHidden = false
                
                
//                self.contentSize = self.contentSize! + self.displayTypeHeightConstraint.constant

                if (eventDetailsResponse?.eventInfo?.eventStatus?.isUserAdmin)! {
                    if (eventDetailsResponse?.eventInfo?.islive)! {
                        if (eventDetailsResponse?.eventInfo?.isCancelled)! {
                            performTimeLbl.isHidden = false
                            eventTextLabel.isHidden = true

                            performTimeLbl.text = "This Event Has Been Cancelled!"
                            interestedButton.setTitle("UNDO CANCEL", for: UIControlState.normal)
                            interestedButton .setImage(UIImage.init(named: "undo_cancel"), for: UIControlState.normal)
                            interestedButton.tag = EventStates.UndoCancelEvent.rawValue
                            
                        } else {
                            performingLbl.isHidden = false
                            performTimeLbl.isHidden = false
                            eventTextLabel.isHidden = true

                            performTimeLbl.text = timediffernce()
                            interestedButton.setTitle("CANCEL", for: UIControlState.normal)
                            interestedButton .setImage(UIImage.init(named: "cancel_event"), for: UIControlState.normal)
                            interestedButton.tag = EventStates.CancelEvent.rawValue
                            
                        }
                        
                    } else {
                        performingLbl.isHidden = false
                        performTimeLbl.isHidden = false
                        eventTextLabel.isHidden = true

                        interestedButton .setTitle("GO LIVE", for: UIControlState.normal)
                        interestedButton .setImage(UIImage.init(named: "go_live"), for: UIControlState.normal)
                        interestedButton.tag = EventStates.MakeItLive.rawValue
                    }
                } else {
                    if (eventDetailsResponse?.eventInfo?.eventStatus?.isUserInterested)! {
                        if (eventDetailsResponse?.eventInfo?.islive)! {
                            if (eventDetailsResponse?.eventInfo?.eventStatus?.isUserJoined)! {
                                performingLbl.isHidden = false
                                performTimeLbl.isHidden = false
                                eventTextLabel.isHidden = true
                                
                                performTimeLbl.text = timediffernce()
                                interestedButton.setTitle("LEAVE", for: UIControlState.normal)
                                interestedButton .setImage(UIImage.init(named: "leave_event"), for: UIControlState.normal)
                                interestedButton.tag = EventStates.LeaveEvent.rawValue
                                
                            } else {
                                performingLbl.isHidden = false
                                performTimeLbl.isHidden = false
                                eventTextLabel.isHidden = true
                                
                                performTimeLbl.text = timediffernce()
                                //performingLbl.text = "You are Interested"
                                interestedButton .setTitle("JOIN", for: UIControlState.normal)
                                interestedButton .setImage(UIImage.init(named: "join_event"), for: UIControlState.normal)
                                interestedButton.tag = EventStates.JoinEvent.rawValue
                                
                            }
                        } else {
                            performingLbl.isHidden = true
                            performTimeLbl.isHidden = true
                            eventTextLabel.isHidden = true
                            
                            interestedButton.setTitle("REMOVE", for: UIControlState.normal)
                            interestedButton .setImage(UIImage.init(named: "delete"), for: UIControlState.normal)
                            interestedButton.tag = EventStates.DeleteEvent.rawValue
                        }
                        
                        
                    } else {
                        eventTextLabel.isHidden = false
                        interestedButton .setTitle("INTERESTED", for: UIControlState.normal)
                        interestedButton .setImage(UIImage.init(named: "interested_event"), for: UIControlState.normal)
                        interestedButton.tag = EventStates.MarkAsInterested.rawValue
                        
                    }
                }
                
                
                if (eventDetailsResponse?.eventInfo?.eventStatus?.isUserArtist)! {
                    //performingLbl.isHidden = false
                    //performTimeLbl.text = "You are performming!"
                    performTimeLbl.text = timediffernce()
                }
                
                eventTextLabel.isHidden = true
            } else {
                eventTextLabel.isHidden = false
                
                interestedButton .setTitle("INTERESTED", for: UIControlState.normal)
                interestedButton .setImage(UIImage.init(named: "interested_event"), for: UIControlState.normal)
                interestedButton.tag = EventStates.MarkAsInterested.rawValue
            }
            
            
        } else {
            eventTextLabel.isHidden = false
        }
        
        performingLbl.isHidden = false
        eventTextLabel.isHidden = true
        /*
        self.contentSize = self.contentSize! + self.buttonViewHeightConstraint.constant + 12

        self.contentSize = self.contentSize! + self.displayTypeHeightConstraint.constant

        self.contentSize = self.contentSize! + 250
        
        self.scrollview.contentSize = CGSize.init(width: self.scrollview.frame.size.width, height: self.contentSize!)
        */
        
        manageConstraints()
    }
    
    func manageConstraints() {
        self.contentViewHeightConstraint.constant = self.contentViewHeightConstraint.constant + self.buttonViewHeightConstraint.constant + 12 + self.displayTypeHeightConstraint.constant
        
        
        
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
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateHomeScreen"), object: self)
                        self.eventDetailsResponse?.eventInfo?.eventStatus?.isUserInterested = interested
                        
                        if interested {
                          self.eventDetailsResponse?.eventInfo?.eventStatus?.rsvpStatus = "interested"
                        } else {
                            self.eventDetailsResponse?.eventInfo?.eventStatus?.rsvpStatus = nil
                        }
                            
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
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateHomeScreen"), object: self)
                        self.eventDetailsResponse?.eventInfo?.isCancelled = isCancelled
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
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateHomeScreen"), object: self)
                        self.eventDetailsResponse?.eventInfo?.islive = true
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
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateHomeScreen"), object: self)
                        self.eventDetailsResponse?.eventInfo?.eventStatus?.isUserJoined = !isLeaving
                        
                        if isLeaving {
                            self.eventDetailsResponse?.eventInfo?.eventStatus?.rsvpStatus = "interested"
                        } else {
                            self.eventDetailsResponse?.eventInfo?.eventStatus?.rsvpStatus = "joined"
                        }
                        
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
        } else {
            //GLOBAL().showAlert(APPLICATION.applicationName, message: "Login to mark as Interested!", actions: nil)
            FacebookLoginManager.sharedInstance.startLoginProcess(viewController: self, isFromEventDetails: true)
        }
        
    }

    func markAsInterestedEvent() {
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            if (eventDetailsResponse?.eventInfo?.eventStatus?.isUserInterested)! {
                markEventAsInterested(false)
                //performingLbl.isHidden = true
                //performTimeLbl.isHidden = true
                //eventTextLabel.isHidden = true
                //interestedButton .setTitle("REMOVE", for: UIControlState.normal)
                //interestedButton .setImage(UIImage.init(named: "delete"), for: UIControlState.normal)
            } else {
                markEventAsInterested(true)
                //performingLbl.isHidden = false
                //performTimeLbl.isHidden = false
                //eventTextLabel.isHidden = false
                //interestedButton .setTitle("INTERESTED", for: UIControlState.normal)
                //interestedButton .setImage(UIImage.init(named: "interested_event"), for: UIControlState.normal)
            }
        } else {
            //GLOBAL().showAlert(APPLICATION.applicationName, message: "Login to mark as Interested!", actions: nil)
            FacebookLoginManager.sharedInstance.startLoginProcess(viewController: self, isFromEventDetails: true)
        }
    }
    
    // MARK: LIVE Event Platform
    
    func liveEventPlatform() {
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            if (eventDetailsResponse?.eventInfo?.islive)! {
                if (eventDetailsResponse?.eventInfo?.isCancelled)! {
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
            if (eventDetailsResponse?.eventInfo?.eventStatus?.isUserJoined)! {
                joinOrLeaveEvent(true)
                //interestedButton.setTitle("LEAVE", for: UIControlState.normal)
                //interestedButton .setImage(UIImage.init(named: "leave_event"), for: UIControlState.normal)
            } else {
                joinOrLeaveEvent(false)
                //interestedButton.setTitle("JOIN", for: UIControlState.normal)
                //interestedButton .setImage(UIImage.init(named: "join_event"), for: UIControlState.normal)
            }
        } else {
            //GLOBAL().showAlert(APPLICATION.applicationName, message: "Login to Join Event!", actions: nil)
            FacebookLoginManager.sharedInstance.startLoginProcess(viewController: self, isFromEventDetails: true)
        }
    }
    
    // MARK: Change View To Interested
    func changeViewToInterested () {
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            if (eventDetailsResponse?.eventInfo?.eventStatus?.isUserInterested)! {

                performingLbl.isHidden = false
                performTimeLbl.isHidden = true
                
                RSVPStatusManagement()
                manageConstraints()
                
                interestedButton.setTitle("REMOVE", for: UIControlState.normal)
                interestedButton .setImage(UIImage.init(named: "delete"), for: UIControlState.normal)
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.userdisplayView.isHidden = false
                    self.view.layoutIfNeeded()
                })

            } else {
                performingLbl.isHidden = true
                performTimeLbl.isHidden = true

                RSVPStatusManagement()
                manageConstraints()
                
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
            if (eventDetailsResponse?.eventInfo?.islive)! {
                if (eventDetailsResponse?.eventInfo?.eventStatus?.isUserJoined)! {
                    performingLbl.isHidden = false
                    performTimeLbl.isHidden = false
                    
                    
                    performTimeLbl.text = timediffernce()

                    RSVPStatusManagement()
                    manageConstraints()

                    interestedButton.setTitle("LEAVE", for: UIControlState.normal)
                    interestedButton .setImage(UIImage.init(named: "leave_event"), for: UIControlState.normal)
                    interestedButton.tag = EventStates.LeaveEvent.rawValue

                UIView.animate(withDuration: 1.0, animations: {
                    self.userdisplayView.isHidden = false
                    self.view.layoutIfNeeded()
                })
                }
            } else {
                performingLbl.isHidden = false
                performTimeLbl.isHidden = false
                
                performTimeLbl.text = timediffernce()
                
                //performingLbl.text = "   You are interested   "
                
                RSVPStatusManagement()
                manageConstraints()

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
            if (eventDetailsResponse?.eventInfo?.eventStatus?.isUserAdmin)! {
                if (eventDetailsResponse?.eventInfo?.islive)! {
                    if (eventDetailsResponse?.eventInfo?.isCancelled)! {
                        performingLbl.isHidden = false
                        performTimeLbl.isHidden = false
                        //performingLbl.text = "You are Hosting"
                        performTimeLbl.text = "This Event Has Been Cancelled!"
                        //eventTextLabel.isHidden = true
                        
                        RSVPStatusManagement()
                        manageConstraints()

                        
                        interestedButton.setTitle("UNDO CANCEL", for: UIControlState.normal)
                        interestedButton .setImage(UIImage.init(named: "undo_cancel"), for: UIControlState.normal)
                        interestedButton.tag = EventStates.UndoCancelEvent.rawValue
                        
                    } else {
                        performingLbl.isHidden = false
                        performTimeLbl.isHidden = false

                        //performingLbl.text = "You are Hosting"
                        performTimeLbl.text = timediffernce()
                        
                        RSVPStatusManagement()
                        manageConstraints()

                        interestedButton.setTitle("CANCEL", for: UIControlState.normal)
                        interestedButton .setImage(UIImage.init(named: "cancel_event"), for: UIControlState.normal)
                        interestedButton.tag = EventStates.CancelEvent.rawValue
                        
                    }
                    
                } else {
                    //eventTextLabel.isHidden = true
                    performingLbl.isHidden = false
                    //performingLbl.text = "You are Hosting"
                    
                    RSVPStatusManagement()
                    manageConstraints()

                    
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
        let facebookEventURL = String.init(format: "https://www.facebook.com/%@", (eventDetailsResponse?.eventInfo?.facebookid)!)
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
        for eventAdmin in (self.eventDetailsResponse?.eventInfo?.eventAdminsArray)! {
            if eventAdmin.adminName == strName{
                eventadminid = eventAdmin.facebookUserId!
            }
        }
        let facebookEventURL = String.init(format: "https://www.facebook.com/%@", eventadminid)
        //(eventDetailsResponse?.eventInfo?.facebookid)!
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
            //GLOBAL().showAlert(APPLICATION.applicationName, message: "Login to join the conversation!", actions: nil)
            FacebookLoginManager.sharedInstance.startLoginProcess(viewController: self, isFromEventDetails: true)
        }
    }
    
    @IBAction func requestsButtonEvent(_ sender: Any) {
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDUNTrackRequestsVC") as! UNTrackRequestsVC
            detailObj.eventId = eventId
            detailObj.hasUserEnabledSpotifyAuth = (self.eventDetailsResponse?.hasUserEnabledSpotifyAuth)!
            
            var showPlaylist : Bool? = false
            if let eventStatus =  (eventDetailsResponse?.eventInfo?.eventStatus) {
                
                
                if eventStatus.isUserAdmin || eventStatus.isUserArtist {
                    showPlaylist = true
                } else {
                    showPlaylist = false
                }
            } else {
                showPlaylist = false
            }
            detailObj.showPlaylist = showPlaylist
            pushStoryObj(obj: detailObj, on: self)
        }
        else {
            //GLOBAL().showAlert(APPLICATION.applicationName, message: "Login to join the conversation!", actions: nil)
            FacebookLoginManager.sharedInstance.startLoginProcess(viewController: self, isFromEventDetails: true)
        }
    }

	@IBAction func playListButtonEvent(_ sender: Any) {
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDEventPlayListsVC") as! EventPlayListsViewController
            detailObj.eventId = eventId
            
            var showPlaylist : Bool? = false
            if let eventStatus =  (eventDetailsResponse?.eventInfo?.eventStatus) {
                
                
                if eventStatus.isUserAdmin || eventStatus.isUserArtist {
                    showPlaylist = true
                } else {
                    showPlaylist = false
                }
            } else {
                showPlaylist = false
            }
            detailObj.showPlaylist = showPlaylist
            pushStoryObj(obj: detailObj, on: self)
        }
        else {
            //GLOBAL().showAlert(APPLICATION.applicationName, message: "Login to join the conversation!", actions: nil)
            FacebookLoginManager.sharedInstance.startLoginProcess(viewController: self, isFromEventDetails: true)
        }
    }
    
    func aboutUsButtonEvent() {
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDEventAboutVC") as! AboutDetailViewController
        detailObj.detailTxt = self.eventDetailsResponse?.eventInfo?.eventDescription
        detailObj.LocationTxt = (self.eventDetailsResponse?.eventInfo?.eventLocation?.locationName)
        pushStoryObj(obj: detailObj, on: self)
    }
    
    @IBAction func artistButtonEvent(_ sender: Any) {
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            let artistListVC = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDArtistListVC") as! ArtistListViewController
            artistListVC.eventId = eventId
            pushStoryObj(obj: artistListVC, on: self)
        } else {
            //GLOBAL().showAlert(APPLICATION.applicationName, message: "Login to view artists!", actions: nil)
            FacebookLoginManager.sharedInstance.startLoginProcess(viewController: self, isFromEventDetails: true)
        }
        
    }
    
    func timediffernce() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ" //Your date format //yyyy-MM-dd'T'HH:mm:ss-mm:ss
        
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(name: "PT") as TimeZone!
        if self.eventDetailsResponse?.eventInfo?.islivedatetime != nil {
            let date = dateFormatter.date(from: (self.eventDetailsResponse?.eventInfo?.islivedatetime)!) //according to date format your date string
            let now = Date()
            let timeOffset = now.offset(from:date! ) //
            return ("Went live \(timeOffset) ago")
        } else {
            return ("Went live few mins ago")
        }
    }
    
    // 3. this method is called when a tap is recognized
    func handleTap(sender: UITapGestureRecognizer) {
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDProfileVC") as! ProfileViewController
        detailObj.isFanProfile = true
        let userID = (UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.userID) as? String)!

        detailObj.userID = userID
        //detailObj.userID = String.init(format: "%ld", (fansaccobj?.id)!)
        pushStoryObj(obj: detailObj, on: self)
    }
    
    func handleImageTap(sender: UITapGestureRecognizer) {
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDImageVC") as! ImageViewController
        detailObj.imageURL = eventImageURL!
        self.navigationController?.present(detailObj, animated: true, completion: nil)
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
