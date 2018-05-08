//
//  FeedPostViewController.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 10/07/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class FeedPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextViewDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,VCPostViewDelegate {
    @IBOutlet weak var feedPostsTableView: UITableView!
    open var eventId : Int?
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var noresultLabel: UNLabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var StatustextView: UITextView!
    @IBOutlet weak var profileImagV: UIImageView!
    let cellReuseIdendifier = "cell"
    var eventFeedPostResponse : UNEventFeedPostResponse?
    @IBOutlet weak var popUpview: UIView!
    
    @IBOutlet weak var statusTextPop: UITextView!
    @IBOutlet weak var profileImgVPop: UIImageView!
    
    @IBOutlet weak var popImageview3: UIView!
    @IBOutlet weak var popImageview2: UIView!
    @IBOutlet weak var popImageview1: UIView!
    
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    let picker = UIImagePickerController()
    var eventImages = NSMutableArray()
    
    var offset : Int = 0
    var pageIndex : Int = 1
    var isMoreEventAvailable : Bool = false
    var bolDecelerate : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.title = "What's Happening"
        // Do any additional setup after loading the view.
        /*
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 190, green: 20/255, blue: 17/255, alpha: 1)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        self.navigationController?.navigationBar.isHidden = true
*/
        feedPostsTableView.register(WhatshappeningCell.self, forCellReuseIdentifier: cellReuseIdendifier)
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOffset = CGSize.zero
        headerView.layer.shadowOpacity = 0.2
        headerView.layer.shadowRadius = 5
        headerView.backgroundColor = UIColor.clear
        
        mainView.layer.cornerRadius = 5.0
        mainView.clipsToBounds = true
        mainView.backgroundColor = UIColor.white
        
        profileImagV.layer.cornerRadius = 20
        profileImagV.clipsToBounds = true
        
        profileImagV.sd_setImage(with: URL(string: UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.Imageurl) as! String), placeholderImage: nil)
        
        profileImgVPop.sd_setImage(with: URL(string: UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.Imageurl) as! String), placeholderImage: nil)
        
        profileImgVPop.layer.cornerRadius = 20
        profileImgVPop.clipsToBounds = true
        
        StatustextView.text = "What’s on your mind?"
        StatustextView.textColor = UIColor.lightGray
        StatustextView.delegate = self
        
        statusTextPop.text = "What’s on your mind?"
        statusTextPop.textColor = UIColor.lightGray
        statusTextPop.delegate = self
        
        picker.delegate = self
        
        popUpview.isHidden = true
        popImageview1.isHidden = true
        popImageview2.isHidden = true
        popImageview3.isHidden = true
        
        feedPostsTableView.estimatedRowHeight = feedPostsTableView.rowHeight
        feedPostsTableView.rowHeight = UITableViewAutomaticDimension
        
        getListOfFeedPosts(eventId!)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        //self.navigationController?.isNavigationBarHidden = true
        
        addCustomNavBar(self, isMenuRequired: false, title: "What's Happening", backhandler: {
            self.navigationController?.popViewController(animated: true)
        }) 

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        feedPostsTableView.reloadData()
    }
    
    func finishPosting(){
        getListOfFeedPosts(eventId!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK :- Get List Of Posts
    
    func getListOfFeedPosts(_ eventId : Int) {
        if self.eventFeedPostResponse == nil || self.eventFeedPostResponse?.eventFeedPostListArray?.count == 0{
            GLOBAL().showLoadingIndicatorWithMessage("")
        }
         UNTZReqeustManager.sharedInstance.apiGetListOfComments(offset,eventId: eventId) {
            (feedResponse) -> Void in
            GLOBAL().hideLoadingIndicator()
            
        self.feedPostsTableView.tableFooterView?.isHidden = false
            
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                GLOBAL().hideLoadingIndicator()
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    
                    if(self.offset == 0) {
                        self.eventFeedPostResponse = UNEventFeedPostResponse.init(jsonDict:dictionary["data"] as! Dictionary<String, AnyObject>)
                        
                    } else {
                       self.eventFeedPostResponse?.appendData(jsonDict: dictionary["data"] as! Dictionary<String, AnyObject>)
                        
                    }
                    
                    if (self.eventFeedPostResponse?.eventFeedPostListArray?.count == 0){
                        self.feedPostsTableView.isHidden = true
                        self.noresultLabel.isHidden = false
                    }else{
                        self.feedPostsTableView.isHidden = false
                        self.noresultLabel.isHidden = true
                        self.feedPostsTableView.reloadData()
                    }
                    
                    if(((self.eventFeedPostResponse?.numberOfItemsPerPage)! * self.pageIndex) == (self.eventFeedPostResponse?.eventFeedPostListArray?.count)) {
                        self.isMoreEventAvailable = true
                    } else {
                        self.isMoreEventAvailable = false
                    }
                    self.feedPostsTableView.tableFooterView?.isHidden = true

                    
                    
                }
            }
        }
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if eventFeedPostResponse == nil {
            return 0
        } else
        {
            return (eventFeedPostResponse?.eventFeedPostListArray?.count)!;
        }
 
        //return myArray.count
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
                self.feedPostsTableView.tableFooterView?.isHidden = false
            }
        } else {
            tableView.tableFooterView = nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (eventFeedPostResponse?.eventFeedPostListArray?.count)! > 0{
            let eventObj : UnEventFeedPostList =  (eventFeedPostResponse?.eventFeedPostListArray?[indexPath.row])!
            if eventObj.postCommentsInfo != nil{
                let postcomment : PostCommentsInfo = eventObj.postCommentsInfo!
                let isShareEvent = false //if cell accept-delete cell
                
                let xVal = 10;
                var width_val : CGFloat
                var height_val : CGFloat
                
                width_val = tableView.frame.size.width - (2*CGFloat(xVal))
                height_val = 40 + CGFloat(xVal) + 10
                if isShareEvent {
                    height_val += 25
                }
                let heightdeslbl = self.height(string: postcomment.commentName! as NSString, withConstrainedWidth: width_val - (2*CGFloat(xVal)), font: UIFont(name: "Roboto-Regular", size: 13.6)!)
                
                height_val += heightdeslbl + 10;
                if (postcomment.picturesInfoListArray?.count)!>0 {
                    let count = (postcomment.picturesInfoListArray?.count)! % 2
                    var totalCount = 0
                    if(count>0){
                        totalCount = Int((postcomment.picturesInfoListArray?.count)!/2) + 1
                    }else{
                        totalCount = (postcomment.picturesInfoListArray?.count)!/2
                    }
                    height_val += 300 + 10;
                }
                
                height_val += 10
                
                return height_val;
                
            }
                
            else if eventObj.requestedTrackInfo != nil
                
            {
                let postcomment : RequestedTrackInfo = eventObj.requestedTrackInfo!
                let xVal = 10;
                var width_val : CGFloat
                var height_val : CGFloat
                
                width_val = tableView.frame.size.width - (2*CGFloat(xVal))
                height_val = 50 + CGFloat(xVal) + 10
                height_val += 20
                
                let results = postcomment.eventTrackArtistsInfoList!
                var nameList:String = ""
                
                for i in (0..<results.count)
                {
                    let name : String =    (postcomment.eventTrackArtistsInfoList?[i].eventTrackName)!
                    if i>0 {
                        nameList = nameList + "-"
                    }
                    nameList = nameList + name
                }
                let heightdeslbl = self.height(string: nameList as NSString, withConstrainedWidth: width_val - (2*CGFloat(xVal)), font: UIFont(name: "Roboto-Regular", size: 13.6)!)
                
                height_val += heightdeslbl + 20;
                height_val += 10
                
                return height_val;
                
            }
            return 0;
        }
        return 0;
    }
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdendifier, for: indexPath) as! WhatshappeningCell
        
        let eventObj : UnEventFeedPostList =  (eventFeedPostResponse?.eventFeedPostListArray![indexPath.row])!
        if eventObj.postCommentsInfo != nil{
            cell.imageContainer.isHidden = false
            
            let theSubviews = (cell.imageContainer.subviews)
            for view in theSubviews
            {
                view.removeFromSuperview()
            }
            
            let postcomment : PostCommentsInfo = eventObj.postCommentsInfo!
            cell.generateViews(postcommentObj: postcomment)
            
            cell.profileview.layer.cornerRadius = cell.profileview.frame.size.height / 2
            cell.profileview.clipsToBounds = true
 //cell.profileview.startAnimationOfImage(animation: false)
            cell.profileview.sd_setImage(with: URL.init(string: (postcomment.guestsInfo?.pictureUrl)!), completed: { (image, error, cacheType, imageURL) in
                cell.profileview.layer.cornerRadius = 20
                
                cell.profileview.clipsToBounds = true
                if (image != nil) || (error == nil) {
                    cell.profileview.image = image
                } else {
                    cell.profileview.image = UIImage.init(named: "default_user_pict")
                }
                
                //cell.profileview.stopAnimationOfImage()
            })
           
            cell.profileview.tag = indexPath.row
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
            cell.profileview.isUserInteractionEnabled = true
            cell.profileview.addGestureRecognizer(tapGesture)

            cell.nameLabel.text = postcomment.guestsInfo?.fullName
            cell.selectionStyle = .none
            
            cell.nameLabel.isHighlighted = false
            cell.nameLabel.highlightedTextColor = UIColor.lightGray
            cell.nameLabel.tag = indexPath.row
            let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
            cell.nameLabel.isUserInteractionEnabled = true
            cell.nameLabel.addGestureRecognizer(tapGesture1)
            
            
            let userID = String.init(format: "%@", UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.userID) as! CVarArg)
            if(postcomment.guestsInfo?.aspNetUserId ==  userID) {
                cell.deleteButton.isHidden = false
            } else {
                cell.deleteButton.isHidden = true
            }
            
            cell.deleteButton.tag = indexPath.row;
            
            cell.deleteButton.removeTarget(self, action: #selector(deleteRequestButtonEvent(_:)), for: .touchUpInside)

            cell.deleteButton.addTarget(self, action: #selector(deleteButtonEvent(_:)), for: .touchUpInside)

        }
        else if eventObj.requestedTrackInfo != nil {
            cell.imageContainer.isHidden = true
            let requestedTrackInfo : RequestedTrackInfo = eventObj.requestedTrackInfo!
            cell.generateRequestViews(postcommentObj : requestedTrackInfo)
            cell.profileview.layer.cornerRadius = cell.profileview.frame.size.height / 2
           cell.profileview.clipsToBounds = true
            cell.profileview.tag = indexPath.row
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
            cell.profileview.isUserInteractionEnabled = true
            cell.profileview.addGestureRecognizer(tapGesture)

            //cell.profileview.startAnimationOfImage(animation: false)
            cell.profileview.sd_setImage(with: URL.init(string: (requestedTrackInfo.guestsInfo?.pictureUrl)!), completed: { (image, error, cacheType, imageURL) in
                //cell.profileview.stopAnimationOfImage()
            })
            cell.nameLabel.isHighlighted = false
            cell.nameLabel.highlightedTextColor = UIColor.lightGray
            
            cell.nameLabel.text = requestedTrackInfo.guestsInfo?.fullName
            cell.nameLabel.tag = indexPath.row
            let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
            cell.nameLabel.isUserInteractionEnabled = true
            cell.nameLabel.addGestureRecognizer(tapGesture1)
            
            cell.trackNameLabel.text = requestedTrackInfo.spotifyTrackName
            
            
            cell.linkImageview.startAnimationOfImage(animation: false)
            if requestedTrackInfo.spotifyAlbumImageUri != nil{
            cell.linkImageview.sd_setImage(with: URL.init(string: (requestedTrackInfo.spotifyAlbumImageUri)!), completed: { (image, error, cacheType, imageURL) in
                cell.linkImageview.stopAnimationOfImage()
            })
            }
            cell.selectionStyle = .none
            
            cell.acceptButton.isHidden = true
            if (requestedTrackInfo.guestsInfo?.facebookUserId == requestedTrackInfo.currentUserInfo?.facebookUserId) {
                cell.deleteButton.isHidden = false
                cell.deleteButton.tag = indexPath.row;
                
                cell.deleteButton.removeTarget(self, action: #selector(deleteButtonEvent(_:)), for: .touchUpInside)

                cell.deleteButton.addTarget(self, action: #selector(deleteRequestButtonEvent(_:)), for: .touchUpInside)

                if requestedTrackInfo.isUserAdminOrArtist! {
                    cell.acceptButton.tag = indexPath.row;
                    cell.acceptButton.addTarget(self, action: #selector(acceptButtonEvent(_:)), for: .touchUpInside)
                    
                } else {
                    cell.acceptButton.isHidden = true
                }
            }
            else {
                cell.deleteButton.isHidden = true
                
                if requestedTrackInfo.isUserAdminOrArtist! {
                    if requestedTrackInfo.isSongAccepted! {
                        cell.acceptButton.setImage(UIImage(named: "undo_cancel"), for: .normal)
                    } else {
                        cell.acceptButton.setImage(UIImage(named: "acceptBtn"), for: .normal)

                    }
                    cell.acceptButton.tag = indexPath.row;
                    cell.acceptButton.addTarget(self, action: #selector(acceptButtonEvent(_:)), for: .touchUpInside)
                }

            }
        }
        
        
        return cell
        
    }
    @IBAction func deleteButtonEvent(_ sender: UIButton) {
        let eventIndex = sender.tag as Int!
        
        let userEventDetails = eventFeedPostResponse?.eventFeedPostListArray?[eventIndex!] as UnEventFeedPostList!
        
        let postCommentsInfo = userEventDetails?.postCommentsInfo
        
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiDeleteComment(eventId!, eventCommentId: (postCommentsInfo?.commentID!)!) {
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
    
    @IBAction func deleteRequestButtonEvent(_ sender: UIButton) {
        let eventIndex = sender.tag as Int!
        
        let userEventDetails = eventFeedPostResponse?.eventFeedPostListArray?[eventIndex!] as UnEventFeedPostList!
        let requestedTrackInfo = userEventDetails?.requestedTrackInfo
        
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiDeleteRequest(eventId!, eventRequestedTrackId: (requestedTrackInfo?.trackID)!) {
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
    @IBAction func acceptButtonEvent(_ sender: UIButton) {
        let eventIndex = sender.tag as Int!
        
        let userEventDetails = eventFeedPostResponse?.eventFeedPostListArray?[eventIndex!] as UnEventFeedPostList!
        let requestedTrackInfo = userEventDetails?.requestedTrackInfo
        
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            if requestedTrackInfo?.isUserAdminOrArtist == true {
                if (requestedTrackInfo?.isSongAccepted)! {
                    acceptOrRejectSong(false,(requestedTrackInfo?.trackID)!)
                } else {
                    acceptOrRejectSong(true,(requestedTrackInfo?.trackID)!)
                }
            } else {
                GLOBAL().showAlert(APPLICATION.applicationName, message: "You are not authorised user to perform this action!", actions: nil)
            }
        }

    }
    
    func acceptOrRejectSong(_ isAccept : Bool, _ eventRequestedTrackId : Int) {
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiAcceptOrRejectRequest(eventId!, eventRequestedTrackId: eventRequestedTrackId, isAccept: isAccept) {
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

    
    @IBAction func presentPostViewController(_ sender: Any) {
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDPostViewController") as! PostViewController
        detailObj.delegate = self
        detailObj.iswithImage = false
        detailObj.eventId = eventId
        pushStoryObj(obj: detailObj, on: self)
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let userEventDetails = eventFeedPostResponse?.eventFeedPostListArray?[indexPath.row] as UnEventFeedPostList!
        //let eventInfo = userEventDetails?.postCommentsInfo
    
        let eventObj : UnEventFeedPostList =  (eventFeedPostResponse?.eventFeedPostListArray![indexPath.row])!
        if eventObj.postCommentsInfo != nil{
            let postcomment : PostCommentsInfo = eventObj.postCommentsInfo!
            let results = postcomment.picturesInfoListArray!
            if results.count>0 {
                let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDGalleryViewController") as! GalleryViewController
                detailObj.postcommentObj = postcomment
                detailObj.eventId = eventId
                pushStoryObj(obj: detailObj, on: self)
                
            }
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
    
    func height(string: NSString,withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func width(string: NSString,withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.width
    }
    
    @IBAction func uploadClicked(_ sender: Any) {
        // upload text api
        GLOBAL().showLoadingIndicatorWithMessage("")
    
        let commentBodyParams: [String: String] =
            [UNTZAPIRequestKeys.comment:StatustextView.text ,
             UNTZAPIRequestKeys.eventId: String.init(format: "%ld", self.eventId!)
        ]
        
        print(commentBodyParams)
        UNTZReqeustManager.sharedInstance.apiAddComment(eventId!,bodyParameters: commentBodyParams as [String : AnyObject]) {
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
                        self.StatustextView.text = "What’s on your mind?"
                        self.StatustextView.textColor = UIColor.lightGray
                        self.StatustextView .resignFirstResponder()
                        
                        self.refreshList()
                    } else {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                    }
                }
            }
        }

    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What’s on your mind?"
            textView.textColor = UIColor.lightGray
        }
    }
    
   @IBAction func showPopupview ()
   {
        eventImages = NSMutableArray()

        popUpview.isHidden = false
        popImageview1.isHidden = true
        popImageview2.isHidden = true
        popImageview3.isHidden = true
        statusTextPop.text = "What’s on your mind?"
        statusTextPop.textColor = UIColor.lightGray
        
    }
    
    @IBAction func openCameraOrLibrary(_ sender: UIButton) {
        if eventImages.count<3 {
            picker.allowsEditing = false
            if sender.tag == 1{
                picker.sourceType = .camera
            }else{
                picker.sourceType = .photoLibrary
            }
            
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            present(picker, animated: true, completion: nil)
        }
    }
  
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        
        dismiss(animated:true, completion: nil) //5
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDPostViewController") as! PostViewController
        detailObj.delegate = self
        detailObj.imgVal = chosenImage
        detailObj.iswithImage = true
        detailObj.eventId = eventId
        pushStoryObj(obj: detailObj, on: self)
        
    }
    
    func displayImagesfromArray(){
        image1.image = nil
        image2.image = nil
        image3.image = nil
        popImageview1.isHidden = true
        popImageview2.isHidden = true
        popImageview3.isHidden = true
        
        for var i in (0..<eventImages.count)
        {
            if i == 0 {
                image1.image = eventImages[0] as? UIImage
                popImageview1.isHidden = false
            }
            if i == 1 {
                image2.image = eventImages[1] as? UIImage
                popImageview2.isHidden = false
            }
            if i == 2 {
                image3.image = eventImages[2] as? UIImage
                popImageview3.isHidden = false
            }
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func closePopupClicked(_ sender: Any) {
        popUpview.isHidden = true
    }
    
    @IBAction func startUploadClickedPopup(_ sender: Any) {
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            
            var imageData = [Data]()
            var index = 0
            for var i in (0..<eventImages.count)
            {
                let image = eventImages[i] as! UIImage
                    if let data = UIImageJPEGRepresentation(image, 0.75) {
                        imageData.append(data as Data)

                }
            }
            
            if (imageData.count) > 0 {
                startUploadImageProcess(imageData: imageData)
            }
        } else {
            GLOBAL().showAlert(APPLICATION.applicationName, message: "Login to join the conversation!", actions: nil)
                
        }
    }
    
    func startUploadImageProcess(imageData : [Data]) {
        // upload text api
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        let pictureCommentBodyParams: [String: String] =
            [UNTZAPIRequestKeys.EventCommentParam:statusTextPop.text ,
             UNTZAPIRequestKeys.EventIdParam: String.init(format: "%ld", self.eventId!)
        ]
        
        let fileName = String.init(format: "Image_%ld", self.eventId!)
        
        UNTZReqeustManager.sharedInstance.apiPictureComment(eventId!, bodyParameters: pictureCommentBodyParams as [String : AnyObject], imageData: imageData, fileName: fileName) {
            
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
                        self.statusTextPop.text = "What’s on your mind?"
                        self.statusTextPop.textColor = UIColor.lightGray
                        self.statusTextPop .resignFirstResponder()
                        self.popUpview.isHidden = true
                        self.refreshList()
                    } else {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                    }
                }
            }
        }
        
    }

    @IBAction func deleteImageClicked(_ sender: UIButton) {
        eventImages.removeObject(at: (sender.tag - 1))
        self.displayImagesfromArray()
    }
    
    func refreshList()  {
        eventFeedPostResponse = nil
        offset = 0
        pageIndex = 1
        bolDecelerate = false
        isMoreEventAvailable = false
        getListOfFeedPosts(eventId!)
    }
    
    @IBAction func camerabtnClicked(_ sender: Any) {
        picker.sourceType = .camera
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    @IBAction func galleryBtnClicked(_ sender: Any) {
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    // 3. this method is called when a tap is recognized
    func handleTap(sender: UITapGestureRecognizer) {
        let view = sender.view
        
        if let tag = view?.tag {
            let eventObj : UnEventFeedPostList =  (eventFeedPostResponse?.eventFeedPostListArray![tag])!

            let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDProfileVC") as! ProfileViewController

            let userID = String.init(format: "%@", UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.userID) as! CVarArg)
            if(eventObj.postCommentsInfo?.guestsInfo?.aspNetUserId ==  userID) {
                detailObj.isFanProfile = true
                detailObj.userID = userID
            } else {
                detailObj.isFanProfile = true
                detailObj.userID = String.init(format: "%ld", eventObj.guestAccountId!)
            }
            
            pushStoryObj(obj: detailObj, on: self)
        
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
                pageIndex = pageIndex + 1
                offset = (eventFeedPostResponse?.nextIndex)!
                self.isMoreEventAvailable = false
                self.getListOfFeedPosts(self.eventId!)
            }
        }
    }
}
