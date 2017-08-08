//
//  LeftViewController.swift
//  LGSideMenuControllerDemo
//
import FBSDKLoginKit


class LeftViewController: UITableViewController {
    
    private let titlesArray = ["Home","Create Event","My Upcoming Events","Profile","About Us","Contact Us","Logout"]

    private let titleImgArray = ["event.png","createEvent.png","upcomingEvent.png","profile.png","aboutUs.png","contactUs.png","logout.png"]
    var dict : [String : AnyObject]!
    
    init() {
        super.init(style: .plain)
        
        
        
        //tableView.register(LeftViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "LeftViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        //tableView.frame = CGRect(x: 0, y: fbView.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.height-fbView.frame.origin.y)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 60.0, left: 0.0, bottom: 60.0, right: 0.0)
        
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if FBSDKAccessToken.current() != nil {
            return 90.0;
        }
        return 0.0;
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
       vw.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 90)
        
       let profileView: UIImageView! = UIImageView(frame: CGRect(x: 15, y: 8, width: 50, height: 50))
        profileView.layer.cornerRadius = 50/2
        profileView.clipsToBounds = true
        vw.addSubview(profileView)
        let nameLbl : UNLabel = UNLabel()
        nameLbl.frame = CGRect(x:profileView.frame.size.width + 25, y: 8, width: self.view.frame.size.width - profileView.frame.size.width + 25, height: 25)
        nameLbl.font = UIFont(name: "Roboto-Regular", size: 21)
        nameLbl.textColor = .white
        nameLbl.textAlignment = .left
        vw.addSubview(nameLbl)
        
        let emailLbl : UNLabel = UNLabel()
        emailLbl.frame = CGRect(x:profileView.frame.size.width + 25, y: 8+nameLbl.frame.size.height, width: self.view.frame.size.width - profileView.frame.origin.x + 25, height: 25)
        emailLbl.textColor = .white
        emailLbl.textAlignment = .left
        emailLbl.font = UIFont(name: "Roboto-Regular", size: 13)
        vw.addSubview(emailLbl)
        if FBSDKAccessToken.current() != nil {
            nameLbl.text = "\(String(describing:UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.userFName) as! String)) \(String(describing: UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.userLName) as! String))"
            emailLbl.text = UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.emailID) as? String
            if (UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.Imageurl) != nil) {
                profileView.sd_setImage(with: URL(string: UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.Imageurl) as! String), placeholderImage: nil)
            }
        }
        return vw
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if FBSDKAccessToken.current() != nil {
            return titlesArray.count
        }
        return titlesArray.count-1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeftViewCell

        if FBSDKAccessToken.current() == nil && indexPath.row == 3 {
            cell.menuLabel!.text = "LogIn"
        }else{
            cell.menuLabel!.text = titlesArray[indexPath.row]
        }
        let newImg: UIImage? = UIImage(named: titleImgArray[indexPath.row])
        cell.menuImg.image = newImg
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainViewController = sideMenuController!
        
        if indexPath.row == 0 {
            let navigationController = mainViewController.rootViewController as! NavigationController
            let viewController = storyboard_R1.instantiateViewController(withIdentifier: "IDViewController")
            navigationController.setViewControllers([viewController], animated: false)
            mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
        }
        else if indexPath.row == 2 {
            if FBSDKAccessToken.current() != nil {
                let navigationController = mainViewController.rootViewController as! NavigationController
                let viewController = storyboard_R1.instantiateViewController(withIdentifier: "IDUpcomingVC")
                navigationController.setViewControllers([viewController], animated: false)
            }
            mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
        }
        else if indexPath.row == 3 {
            if FBSDKAccessToken.current() != nil {
                //profile
                mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
            }
            else{
               mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
                fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
                    if(error != nil){
                        FBSDKLoginManager().logOut()
                    }else if(result?.isCancelled)!{
                        FBSDKLoginManager().logOut()
                    }else{
                                print("Getting profile")
                                print("FB version: \(FBSDKSettings.sdkVersion())")
                                print("Tokensssss:  \(String(describing: FBSDKAccessToken.current()?.tokenString))")
                                self.getFBUserData()
                        UNTZReqeustManager.sharedInstance.apiFacebookLogin((FBSDKAccessToken.current()?.tokenString)!, provider: "Facebook", completionHandler:{ (feedResponse) -> Void in
                            if let downloadError = feedResponse.error{
                                print(downloadError)
                                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
                            } else {
                                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                                    
                                    self.parseTokenInfo(jsonDict: dictionary)
                                }

                                print("\(feedResponse)")
                                mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                                tableView.reloadData()
                            }
                        })
                    }
                  }
            }
        
        }
        else if indexPath.row == 6 {
            //logout
            FBSDKLoginManager().logOut()
            UserInfo.sharedInstance.clearUserInfoWhenUserLoggedOut()
            mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
            tableView.reloadData()
        }
        else{
           mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
        }
        
       /* else if indexPath.row == 2 {
            let navigationController = mainViewController.rootViewController as! NavigationController
            let viewController: UIViewController!
            viewController = HomeViewController()
            navigationController.setViewControllers([viewController], animated: false)
            // Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
            // You can use delay to avoid this and probably other unexpected visual bugs
            mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
        }
        else {
            let viewController = UIViewController()
            viewController.view.backgroundColor = .white
            viewController.title = "Test \(titlesArray[indexPath.row])"
            
            let navigationController = mainViewController.rootViewController as! NavigationController
            navigationController.pushViewController(viewController, animated: true)
            
            mainViewController.hideLeftView(animated: true, completionHandler: nil)
        }
        */
    }
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(self.dict)
                    let fname = self.dict["first_name"] as? String
                    let lname = self.dict["last_name"] as? String
                    let email = self.dict["email"] as? String
                    if let imageURL = ((self.dict["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                        //Download image from imageURL
                    UserInfo.sharedInstance.setUserInfoInCache(value: imageURL as AnyObject?, key: UNUserInfoKeys.Imageurl)
                    }
                    UserInfo.sharedInstance.setUserInfoInCache(value: fname as AnyObject?, key: UNUserInfoKeys.userFName)
                    UserInfo.sharedInstance.setUserInfoInCache(value: lname as AnyObject?, key: UNUserInfoKeys.userLName)
                    UserInfo.sharedInstance.setUserInfoInCache(value: email as AnyObject?, key: UNUserInfoKeys.emailID)
                    
                }
            })
        }
    }
    
    func parseTokenInfo(jsonDict: Dictionary<String, AnyObject>) {
        let accessToken = jsonDict["access_token"] as? String
        let tokenExpiresIn = jsonDict["expires_in"] as? Int
        let tokenType = jsonDict["token_type"] as? String
        let refreshToken = jsonDict["refresh_token"] as? String
        let userName = jsonDict["userName"] as? String
        let userId = jsonDict["id"] as? String

        
        UserInfo.sharedInstance.setUserInfoInCache(value: accessToken as AnyObject?, key: UNUserInfoKeys.accessToken)
        UserInfo.sharedInstance.setUserInfoInCache(value: tokenExpiresIn as AnyObject?, key: UNUserInfoKeys.tokenExpiresIn)
        UserInfo.sharedInstance.setUserInfoInCache(value: tokenType as AnyObject?, key: UNUserInfoKeys.tokenType)
        UserInfo.sharedInstance.setUserInfoInCache(value: refreshToken as AnyObject?, key: UNUserInfoKeys.refreshToken)
        UserInfo.sharedInstance.setUserInfoInCache(value: userName as AnyObject?, key: UNUserInfoKeys.emailID)
        UserInfo.sharedInstance.setUserInfoInCache(value: userId as AnyObject?, key: UNUserInfoKeys.userID)
        
    }

}
