//
//  FansViewController.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 13/11/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class FansViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var fansTableView: UITableView!
    @IBOutlet weak var noresultLabel: UNLabel!
    
    var fansResponse : UNFansResponse?
    open var userId : Int?
    open var userName : String?
    open var isFanProfile : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        */
        fansTableView.register(UINib(nibName: "FansListCell", bundle: nil), forCellReuseIdentifier: "fanCell")
        fansTableView.estimatedRowHeight = fansTableView.rowHeight
        fansTableView.rowHeight = UITableViewAutomaticDimension

        if(isFanProfile!) {
            noresultLabel.text = String.init(format: "%@  has no followers yet.", userName!)
        } else {
            noresultLabel.text = "You have no followers yet."
        }
        
        self.getListOfFans(self.userId!)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.navigationBar.isHidden = true
        
        addCustomNavBar(self, isMenuRequired: false, title: "Followers", backhandler: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK :- Get List Of Events
    
    func getListOfFans(_ userId : Int) {
        GLOBAL().showLoadingIndicatorWithMessage("")
        UNTZReqeustManager.sharedInstance.apiGetListOfFans(userId) {
            (feedResponse) -> Void in
            GLOBAL().hideLoadingIndicator()
            
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                GLOBAL().hideLoadingIndicator()
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    self.fansResponse = UNFansResponse.init(jsonDict:dictionary["data"] as! Dictionary<String, AnyObject>)
                    if self.fansResponse?.fansList.count==0{
                        self.noresultLabel.isHidden = false
                    }else{
                        self.noresultLabel.isHidden = true
                    }
                    self.fansTableView.reloadData()
                }
            }
        }
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                if self.fansResponse?.fansList == nil {
                    return 0
                } else
                {
                    return (self.fansResponse?.fansList.count)!;
                }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 85;//Choose your custom row height
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FansListCell = tableView.dequeueReusableCell(withIdentifier: "fanCell") as! FansListCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let objfansDetails = self.fansResponse?.fansList[indexPath.row]
        let fansaccobj  = objfansDetails?.fanAccount
                cell.NameLabel.text = fansaccobj?.fullName
                if fansaccobj?.pictureUrl != nil{
                    cell.profileImageView.sd_setImage(with: URL.init(string: (fansaccobj?.pictureUrl)!), completed: { (image, error, cacheType, imageURL) in
                        //cell.linkImageview.stopAnimationOfImage()
                    })
                }else{
                    let Image: UIImage = UIImage(named: "profile_default")!
                    cell.profileImageView.image = Image
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objfansDetails = self.fansResponse?.fansList[indexPath.row]
        let fansaccobj  = objfansDetails?.fanAccount
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDProfileVC") as! ProfileViewController
        detailObj.isFanProfile = true
        detailObj.userID = String.init(format: "%ld", (fansaccobj?.id)!)
        pushStoryObj(obj: detailObj, on: self)
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

