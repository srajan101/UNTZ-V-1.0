//
//  NotificationsViewController.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 14/04/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var noresultLabel: UNLabel!
    open var isPushVC : Bool?
    open var accountId : String?
    var offset : Int = 0
    var bolDecelerate : Bool = false
    var isMoreEventAvailable : Bool = false
    var pageIndex : Int = 1
    
    var notificationRespone : PushNotificationInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationTableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "notificationcell")
        notificationTableView.estimatedRowHeight = notificationTableView.rowHeight
        notificationTableView.rowHeight = UITableViewAutomaticDimension
        
        //self.getListOfFans(self.userId!)
        self.getListOfNotifications()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.navigationBar.isHidden = true
        
        var isMenuRequired = true
        if(isPushVC)!{
            isMenuRequired = false
        }
        addCustomNavBar(self, isMenuRequired: isMenuRequired, title: "Notifications", backhandler: {
            self.navigationController?.popViewController(animated: true)
            if(self.isPushVC)! {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showLeftView()
            }
        })
    }
    func showLeftView() {
        if(isPushVC)!{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            sideMenuController?.showLeftView(animated: true, completionHandler: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.notificationTableView.reloadData()
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK :- Get List Of Notifications
    
    func getListOfNotifications() {
        self.noresultLabel.isHidden = true
        
        if self.notificationRespone == nil || self.notificationRespone?.notificationList?.count==0{
            GLOBAL().showLoadingIndicatorWithMessage("")
        }
        
        UNTZReqeustManager.sharedInstance.apiGetNotificationList(offset) {
        (feedResponse) -> Void in
            GLOBAL().hideLoadingIndicator()
            
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                GLOBAL().hideLoadingIndicator()
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    if(self.offset == 0) {
                        self.notificationRespone = PushNotificationInfo.init(jsonDict:dictionary["data"] as! Dictionary<String, AnyObject>)
                        if self.notificationRespone?.notificationList?.count == 0 {
                            self.noresultLabel.isHidden = false
                        }else{
                            self.noresultLabel.isHidden = true
                        }
                        
                        GLOBAL.sharedInstance.checkFacebookUserEventsUpdated()
                    } else {
                        self.notificationRespone?.appendData(jsonDict:dictionary["data"] as! Dictionary<String, AnyObject>)
                    }
                    
                    if(((self.notificationRespone?.numberOfItemsPerPage)! * self.pageIndex) == (self.notificationRespone?.notificationList?.count)) {
                        self.isMoreEventAvailable = true
                    } else {
                        self.isMoreEventAvailable = false
                        self.notificationTableView.tableFooterView?.isHidden = true
                    }
                    self.notificationTableView.reloadData()
                }
            }
        }
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.notificationRespone == nil {
            return 0
        } else
        {
            return (self.notificationRespone!.notificationList!.count);
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 85;//Choose your custom row height
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell:NotificationCell = tableView.dequeueReusableCell(withIdentifier: "notificationcell") as! NotificationCell
        //cell.selectionStyle = UITableViewCellSelectionStyle.none
        let objDetails = self.notificationRespone?.notificationList?[indexPath.row]
        let modelobj  = objDetails?.notificationFormatModel
        cell.datailLabel.text = objDetails?.notificationTextFormat
        if modelobj?.actorPictureUrl != nil{
            cell.profileImageView.sd_setImage(with: URL.init(string: (modelobj?.actorPictureUrl)!), completed: { (image, error, cacheType, imageURL) in
                //cell.linkImageview.stopAnimationOfImage()
            })
        }else{
            let Image: UIImage = UIImage(named: "profile_default")!
            cell.profileImageView.image = Image
        }
        return cell
   
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
                self.notificationTableView.tableFooterView?.isHidden = false
            }
        } else {
            tableView.tableFooterView = nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let objfansDetails = self.fansResponse?.fansList[indexPath.row]
        let fansaccobj  = objfansDetails?.fanAccount
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDProfileVC") as! ProfileViewController
        detailObj.isFanProfile = true
        detailObj.userID = String.init(format: "%ld", (fansaccobj?.id)!)
        pushStoryObj(obj: detailObj, on: self)
         */
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
                offset = (notificationRespone?.nextIndex)!
                self.isMoreEventAvailable = false;
                self.getListOfNotifications()
            }
        }
    }
    
}
