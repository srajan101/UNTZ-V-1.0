//
//  ProfileViewController.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 05/11/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController , UITextViewDelegate {

    @IBOutlet weak var profilepic: UIImageView!
    @IBOutlet weak var followbtn: UIButton!
    @IBOutlet weak var followingbtn: UIButton!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var AboutMe_H1: NSLayoutConstraint!//21
    @IBOutlet weak var followerCntLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    @IBOutlet weak var aboutmeLbl: UILabel!
    @IBOutlet weak var aboutmeTextView: UITextView!
    fileprivate var profileModelResponse : UNProfileInfo?
    open var isFanProfile : Bool?
    open var userID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        followbtn.isHidden = true;
        followingbtn.isHidden = true;
        aboutmeTextView.delegate = self

     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profilepic.layer.cornerRadius = 70/2
        profilepic.clipsToBounds = true
        
        followbtn.layer.cornerRadius = 2.5
        followbtn.clipsToBounds = true
        followingbtn.layer.cornerRadius = 2.5
        followingbtn.clipsToBounds = true
        
        if(isFanProfile)!{
            addCustomNavBar(self, isMenuRequired: false,title: "Profile", isTranslucent: true, backhandler: {
                self.navigationController?.popViewController(animated: true)
            })
        }else{
            addCustomNavBar(self, isMenuRequired: true,title: "Profile", isTranslucent: true, backhandler: {
                self.sideMenuController?.showLeftView(animated: true, completionHandler: nil)
            })
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.navigationController?.navigationBar.isHidden = true
        self.aboutmeTextView.isHidden = true;
        self.aboutmeLbl.isHidden = true;
         self.getprofileDetails()
    }
    //*
    func getprofileDetails(){
     //let userID =     UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.emailID) as? String
    GLOBAL().showLoadingIndicatorWithMessage("")
        UNTZReqeustManager.sharedInstance.apiGetProfile(userID) {
        (feedResponse) -> Void in
            GLOBAL().hideLoadingIndicator()
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                    if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                        self.profileModelResponse = UNProfileInfo.init(jsonDict:dictionary["data"] as! Dictionary<String, AnyObject>)//init(jsonDict:dictionary)
                        self.usernameLbl.text = self.profileModelResponse?.fullName
                        self.profilepic.sd_setImage(with: URL.init(string: (self.profileModelResponse?.pictureUrl)!), completed: { (image, error, cacheType, imageURL) in
                        })
                        
                        if let aboutMe = self.profileModelResponse?.aboutme {
                            if !aboutMe.trimmingCharacters(in: .whitespaces).isEmpty && aboutMe != "Say something about yourself"{
                                self.aboutmeTextView.isHidden = false;
                                self.aboutmeLbl.isHidden = false;
                                // string contains non-whitespace characters
                                self.aboutmeTextView.textColor = UIColor.black
                                self.aboutmeTextView.text = aboutMe
                            }else{
                                    self.aboutmeTextView.isHidden = true;
                                    self.aboutmeLbl.isHidden = true;
                                }
                        }else{
                            self.aboutmeTextView.isHidden = true;
                            self.aboutmeLbl.isHidden = true;
                        }
                if(self.profileModelResponse?.userProfileRelationship?.isUsersOwnProfile)!{
                            self.followingbtn.isHidden = true
                            self.followbtn.isHidden = true
                        }else{
                    if(self.profileModelResponse?.userProfileRelationship?.isCurrentUserFanOfProfile==nil){
                            self.followbtn.isHidden = false;
                            self.followingbtn.isHidden = true;
                            }else{
                        if(self.profileModelResponse?.userProfileRelationship?.isCurrentUserFanOfProfile)!{
                            self.followbtn.isHidden = true;
                            self.followingbtn.isHidden = false;
                        }else{
                            self.followbtn.isHidden = false;
                            self.followingbtn.isHidden = true;
                        }
                          }
                        }
                        self.followerCntLbl.text = String.init(format: "%ld", (self.profileModelResponse?.fansCount!)!)
                        self.followingLbl.text = String.init(format: "%ld", (self.profileModelResponse?.fansOfCount!)!)
                }
            }
        }
    }
    //*/
    @IBAction func backClicked(_ sender: Any) {
        if(isFanProfile)!{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.navigationBar.isHidden = false
            sideMenuController?.showLeftView(animated: true, completionHandler: nil)
        }
    }
    @IBAction func upcomingEventClicked(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDUpcomingVC") as! UpcomingEventsViewController
        detailObj.accountId = String.init(format: "%ld", (profileModelResponse?.id)!)
        if let userRelationShip = profileModelResponse?.userProfileRelationship {
            if userRelationShip.isCurrentUserFanOfProfile == false {
                detailObj.fanName = profileModelResponse?.FirstName
            }
        }
        detailObj.isPushVC = true
        pushStoryObj(obj: detailObj, on: self)
    }
    
    @IBAction func followbtnclick(_ sender: Any) {
        self.becomFanAPI((profileModelResponse?.id)!)
    }
    @IBAction func followingbtnclick(_ sender: Any) {
        self.becomUnFanAPI((profileModelResponse?.id)!)
    }
   
    @IBAction func pastEventsbtnclick(_ sender: Any) {
        //past Events
       // GLOBAL().showAlert(APPLICATION.applicationName, message: "In progress!", actions: nil)
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDPasteventVC") as! PastEventViewController
        detailObj.accountId = (profileModelResponse?.id)!
        detailObj.userFullname = self.profileModelResponse?.fullName
        detailObj.profileimageURL = self.profileModelResponse?.pictureUrl
        pushStoryObj(obj: detailObj, on: self)
    }
    
    @IBAction func fanbtnClick(_ sender: Any) {
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDFansVC") as! FansViewController
        detailObj.userId = (profileModelResponse?.id)!
        detailObj.userName = (profileModelResponse?.FirstName)!
        detailObj.isFanProfile = isFanProfile
        pushStoryObj(obj: detailObj, on: self)
    }
    
    @IBAction func fansofClick(_ sender: Any) {
        // Write same here for FansOf Controller
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDFollowingVC") as! FollowingViewController
        detailObj.userId = (profileModelResponse?.id)!
        detailObj.userName = (profileModelResponse?.FirstName)!
        detailObj.isFanProfile = isFanProfile
        pushStoryObj(obj: detailObj, on: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(isFanProfile)!{
            return false
        }
        if(text == "\n") {
            textView.resignFirstResponder()
            if aboutmeTextView.text.count == 0 { GLOBAL().showAlert(APPLICATION.applicationName, message: "Please enter text!", actions: nil)
            } else {
                    self.saveAboutmeAPI()
            }
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Say something about yourself"
            textView.textColor = UIColor.lightGray
        }
    }
    func becomFanAPI(_ userId : Int) {
        GLOBAL().showLoadingIndicatorWithMessage("")
        UNTZReqeustManager.sharedInstance.apiBecomeFan(userId) {
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
                        self.getprofileDetails()
                    } else {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                    }
                }
            }
        }
    }
    func becomUnFanAPI(_ userId : Int) {
        GLOBAL().showLoadingIndicatorWithMessage("")
        UNTZReqeustManager.sharedInstance.apiUnfan(userId) {
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
                        self.getprofileDetails()
                    } else {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                    }
                }
            }
        }
    }
    func saveAboutmeAPI() {
        GLOBAL().showLoadingIndicatorWithMessage("")
        UNTZReqeustManager.sharedInstance.apiUpdateAboutMe(aboutMeText: aboutmeTextView.text!) {
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
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "About me updated!", actions: nil)
                    } else {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                    }
                }
            }
        }
    }
}
