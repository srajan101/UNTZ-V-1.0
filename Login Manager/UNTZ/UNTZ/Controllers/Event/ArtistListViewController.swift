//
//  ArtistListViewController.swift
//  UNTZ
//
//  Created by Mahesh Sonaiya on 07/10/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class ArtistListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var artistsTableView: UITableView!
    @IBOutlet weak var noresultLabel: UNLabel!
    
    open var eventId : Int?
    fileprivate var artistModelResponse : UNArtistModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        artistsTableView.register(UINib(nibName: "ArtistListCell", bundle: nil), forCellReuseIdentifier: "artistCell")
        
        artistsTableView.estimatedRowHeight = artistsTableView.rowHeight
        artistsTableView.rowHeight = UITableViewAutomaticDimension
        
        getListOfUserEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.navigationController?.navigationBar.isHidden = true
        
        addCustomNavBar(self, isMenuRequired: false, title: "Performing Artist", backhandler: {
            self.navigationController?.popViewController(animated: true)
        }) 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        artistsTableView.reloadData()
    }
    
    
    @IBAction func backClicked(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.artistModelResponse?.eventArtistDetails == nil {
            return 0
        } else
        {
            return (self.artistModelResponse?.eventArtistDetails.count)!;
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 85;//Choose your custom row height
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ArtistListCell = tableView.dequeueReusableCell(withIdentifier: "artistCell") as! ArtistListCell
        //cell.selectionStyle = UITableViewCellSelectionStyle.none
        let objEventDetails = self.artistModelResponse?.eventArtistDetails[indexPath.row]
        let artistObj = objEventDetails?.artistInfo
        cell.NameLabel.text = artistObj?.fullName
        cell.NameLabel.tag = indexPath.row
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        cell.NameLabel.isUserInteractionEnabled = true
        cell.NameLabel.addGestureRecognizer(tapGesture1)
        
        cell.fanLabel.text = ""//"artistObj?.fullName""
        if artistObj?.pictureUrl != nil{
            cell.profileImageView.sd_setImage(with: URL.init(string: (artistObj?.pictureUrl)!), completed: { (image, error, cacheType, imageURL) in
                //cell.linkImageview.stopAnimationOfImage()
                if error != nil {
                    let Image: UIImage = UIImage(named: "profile_default")!
                    cell.profileImageView.image = Image
                }
            })
        } else{
            let Image: UIImage = UIImage(named: "profile_default")!
            cell.profileImageView.image = Image
        }
        
        cell.profileImageView.tag = indexPath.row
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        cell.profileImageView.isUserInteractionEnabled = true
        cell.profileImageView.addGestureRecognizer(tapGesture)

        return cell
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK :- Get List Of Artist
    
    func getListOfUserEvents() {
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiGetListOfArtists(eventId!) {
            (feedResponse) -> Void in
            GLOBAL().hideLoadingIndicator()
            
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                GLOBAL().hideLoadingIndicator()
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                        self.artistModelResponse = UNArtistModel.init(jsonDict:dictionary["data"] as! Dictionary<String, AnyObject>)
                        //print(self.artistModelResponse?.eventArtistDetails.count ?? 0)
                        if self.artistModelResponse?.eventArtistDetails.count==0{
                            self.noresultLabel.isHidden = false
                        }else{
                            self.noresultLabel.isHidden = true
                        }
                    
                    self.artistsTableView.reloadData()
                }
            }
        }
    }

    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objEventDetails = self.artistModelResponse?.eventArtistDetails[indexPath.row]
        let artistObj = objEventDetails?.artistInfo
        
        let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDProfileVC") as! ProfileViewController
        
        let userID = String.init(format: "%@", UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.userID) as! CVarArg)
        if(artistObj?.aspNetUserId ==  userID) {
            detailObj.isFanProfile = true
            detailObj.userID = userID
        } else {
            detailObj.isFanProfile = true
            detailObj.userID = String.init(format: "%ld", (objEventDetails?.artistAccountId)!)
        }
        
        pushStoryObj(obj: detailObj, on: self)
        
    }


    // 3. this method is called when a tap is recognized
    func handleTap(sender: UITapGestureRecognizer) {
        let view = sender.view
        
        if let tag = view?.tag {
            let objEventDetails = self.artistModelResponse?.eventArtistDetails[tag]
            let artistObj = objEventDetails?.artistInfo
            
            let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDProfileVC") as! ProfileViewController
            
            let userID = String.init(format: "%@", UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.userID) as! CVarArg)
            if(artistObj?.aspNetUserId ==  userID) {
                detailObj.isFanProfile = true
                detailObj.userID = userID
            } else {
                detailObj.isFanProfile = true
                detailObj.userID = String.init(format: "%ld", (objEventDetails?.artistAccountId)!)
            }
            
            pushStoryObj(obj: detailObj, on: self)
            
        }
    }
}
