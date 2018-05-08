//
//  GalleryViewController.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 22/08/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit
protocol VCGalleryDelegate {
    func finishPassing(imgArray: NSMutableArray)
}
class GalleryViewController: UIViewController ,UIScrollViewDelegate {
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var shadowview: UIView!
    @IBOutlet weak var descLabel: UILabel!
    var scrolview: UIScrollView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var pagecontrol: UIPageControl!
    var imgOne : UIImageView!
    var imgtwo : UIImageView!
    var imgthree : UIImageView!
    var imgfour : UIImageView!
    var imgfive : UIImageView!
    var DeleteImgbtn : UIButton!
    
    var eventId : Int?
    var postcommentObj : PostCommentsInfo?
    var Tempimagearray : NSMutableArray!
    var delegate: VCGalleryDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 190/255, green: 20/255, blue: 17/255, alpha: 1)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        self.navigationController?.navigationBar.isHidden = true
         */
        self.deleteBtn.isHidden = true
        // Do any additional setup after loading the view.
        shadowview.layer.shadowColor = UIColor.black.cgColor
        shadowview.layer.shadowOffset = CGSize.zero
        shadowview.layer.shadowOpacity = 0.2
        shadowview.layer.shadowRadius = 5
        shadowview.backgroundColor = UIColor.clear
        mainView.clipsToBounds = true
        mainView.backgroundColor = UIColor.white
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // your code here
            //var resultArry = NSMutableArray()
            var resultArry: [PicturesInfo] = []
            let CurY = self.descLabel.frame.origin.y+self.descLabel.frame.height+10
            let heightS = self.mainView.frame.height - (CurY+20+(self.mainView.frame.height - self.pagecontrol.frame.origin.y))
            let widthS = self.view.frame.width - (2*self.mainView.frame.origin.x)
            self.scrolview = UIScrollView(frame : CGRect(x:0, y:CurY,width:widthS, height:heightS))
            self.scrolview.delegate = self
            self.scrolview.isPagingEnabled = true
            self.scrolview.bounces = false
            self.scrolview.showsHorizontalScrollIndicator = false
            self.mainView.addSubview(self.scrolview)
            
            let scrollViewWidth:CGFloat = self.scrolview.frame.width
            let scrollViewHeight:CGFloat = self.scrolview.frame.height
            
            self.imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
            self.imgtwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
            self.imgthree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
            self.imgfour = UIImageView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth, height:scrollViewHeight))
            self.imgfive = UIImageView(frame: CGRect(x:scrollViewWidth*4, y:0,width:scrollViewWidth, height:scrollViewHeight))
            
            self.imgOne.contentMode = .scaleAspectFit
            self.imgOne.clipsToBounds = true
            self.imgtwo.contentMode = .scaleAspectFit
            self.imgtwo.clipsToBounds = true
            self.imgthree.contentMode = .scaleAspectFit
            self.imgthree.clipsToBounds = true
            self.imgfour.contentMode = .scaleAspectFit
            self.imgfour.clipsToBounds = true
            self.imgfive.contentMode = .scaleAspectFit
            self.imgfive.clipsToBounds = true
            
            self.scrolview.addSubview(self.imgOne)
            self.scrolview.addSubview(self.imgtwo)
            self.scrolview.addSubview(self.imgthree)
            self.scrolview.addSubview(self.imgfour)
            self.scrolview.addSubview(self.imgfive)
            
            if self.postcommentObj != nil {
                self.doneBtn.isHidden = true
                self.backBtn.isHidden = false
                //self.headerLabel.text = "Picture Gallery"
                //self.navigationItem.title = "Picture Gallery"
                self.profileImageview.sd_setImage(with: URL(string: (self.postcommentObj?.guestsInfo?.pictureUrl)!), placeholderImage: nil)
                self.nameLabel.text = self.postcommentObj?.guestsInfo?.fullName
                self.timeLabel.text = self.timediffernce(dateStr: (self.postcommentObj?.commentTime)!)
                self.descLabel.text = self.postcommentObj?.commentName!
                //resultArry = self.postcommentObj?.picturesInfoListArray! as! NSMutableArray
                resultArry = (self.postcommentObj?.picturesInfoListArray!)!
                for i in (0..<resultArry.count)
                    {
                    if i>5{
                        return
                    }
                    
                    var imgURL : String =    (self.postcommentObj?.picturesInfoListArray?[i].pictureUrl)!
                    imgURL.remove(at: imgURL.startIndex)
                    let fullURL : String =  APIEndPoints.getwebURL()+imgURL
                    //print(fullURL)
                    if i == 0 {
                        self.imgOne.sd_setImage(with: URL(string: fullURL), placeholderImage: UIImage(named: ""))
                    }
                    else if i == 1 {
                        self.imgtwo.sd_setImage(with: URL(string: fullURL), placeholderImage: UIImage(named: ""))
                    }
                    else if i == 2 {
                        self.imgthree.sd_setImage(with: URL(string: fullURL), placeholderImage: UIImage(named: ""))
                    }
                    else if i == 3 {
                        self.imgfour.sd_setImage(with: URL(string: fullURL), placeholderImage: UIImage(named: ""))
                    }
                    else if i == 4 {
                        self.imgfive.sd_setImage(with: URL(string: fullURL), placeholderImage: UIImage(named: ""))
                    }
                    self.scrolview.contentSize = CGSize(width:self.scrolview.frame.width * CGFloat(resultArry.count), height:self.scrolview.frame.height)
                    self.pagecontrol.numberOfPages = resultArry.count
                }
            }else{
                self.doneBtn.isHidden = false
                self.backBtn.isHidden = true
                //self.navigationItem.title = "Edit"

                //self.headerLabel.text = "Edit"
                self.nameLabel.text = "\(String(describing:UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.userFName) as! String)) \(String(describing: UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.userLName) as! String))"

                self.profileImageview.sd_setImage(with: URL(string: UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.Imageurl) as! String), placeholderImage: nil)
                self.timeLabel.text = ""
                for i in (0..<self.Tempimagearray.count)
                {
                    if i>5{
                        return
                    }
                    if i == 0 {
                        self.imgOne.image = self.Tempimagearray[0] as! UIImage
                    }
                    else if i == 1 {
                        self.imgtwo.image = self.Tempimagearray[1] as! UIImage
                    }
                    else if i == 2 {
                        self.imgthree.image = self.Tempimagearray[2] as! UIImage
                    }
                    else if i == 3 {
                        self.imgfour.image = self.Tempimagearray[3] as! UIImage
                    }
                    else if i == 4 {
                        self.imgfive.image = self.Tempimagearray[4] as! UIImage
                    }
                }
                self.scrolview.contentSize = CGSize(width:self.scrolview.frame.width * CGFloat(self.Tempimagearray.count), height:self.scrolview.frame.height)
                self.pagecontrol.numberOfPages = self.Tempimagearray.count
                self.DeleteImgbtn = UIButton(frame: CGRect(x:scrollViewWidth-70, y:CurY,width:40, height:40))
                self.DeleteImgbtn.addTarget(self, action: #selector(self.deleteImgpressed(_:)), for: .touchUpInside)
                //self.DeleteImgbtn.backgroundColor = .red
                self.DeleteImgbtn.setImage(UIImage(named: "close.png"), for: .normal)
                self.DeleteImgbtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
                self.DeleteImgbtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.DeleteImgbtn.layer.shadowOpacity = 1.0
                self.DeleteImgbtn.layer.shadowRadius = 0.0
                self.DeleteImgbtn.layer.masksToBounds = false
                self.mainView.addSubview(self.DeleteImgbtn)
            }
            
            self.profileImageview.layer.cornerRadius = self.profileImageview.frame.size.height / 2
            self.profileImageview.clipsToBounds = true
            
            //4
            
            self.scrolview.delegate = self
            self.pagecontrol.currentPage = 0

        }
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        var title = ""
        if self.postcommentObj != nil {
            title = "Picture Gallery"
        } else {
            title = "Edit"
        }
        
        addPersonalizeNavBar(self, leftButtonTitle: nil, rightButtonTitle: "Done", rightButtonImage: nil, title: title, backhandler: {
            self.navigationController?.popViewController(animated: true)
            
        }) {
            if self.postcommentObj != nil {
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.delegate?.finishPassing(imgArray: self.Tempimagearray)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        
        //self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func deleteImgpressed(_ sender: Any) {
        //print(self.pagecontrol.currentPage)
        Tempimagearray.removeObject(at: self.pagecontrol.currentPage)
        self.pagecontrol.currentPage = 0;
        for i in (0..<self.Tempimagearray.count)
        {
            if i>5{
                return
            }
            if i == 0 {
                self.imgOne.image = self.Tempimagearray[0] as! UIImage
            }
            else if i == 1 {
                self.imgtwo.image = self.Tempimagearray[1] as! UIImage
            }
            else if i == 2 {
                self.imgthree.image = self.Tempimagearray[2] as! UIImage
            }
            else if i == 3 {
                self.imgfour.image = self.Tempimagearray[3] as! UIImage
            }
            else if i == 4 {
                self.imgfive.image = self.Tempimagearray[4] as! UIImage
            }
        }
        self.scrolview.contentSize = CGSize(width:self.scrolview.frame.width * CGFloat(self.Tempimagearray.count), height:self.scrolview.frame.height)
        self.scrolview.contentOffset.x = 0
        self.pagecontrol.numberOfPages = self.Tempimagearray.count
        if self.Tempimagearray.count == 0 {
            DeleteImgbtn.isHidden = true
            self.imgOne.image = nil
        }
        
    }
    
    @IBAction func deletebtnClicked(_ sender: Any) {
        
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        UNTZReqeustManager.sharedInstance.apiDeleteComment(eventId!, eventCommentId: (postcommentObj?.commentID!)!) {
            (feedResponse) -> Void in
            GLOBAL().hideLoadingIndicator()
            
            if let downloadError = feedResponse.error{
                print(downloadError)
                GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
            } else {
                GLOBAL().hideLoadingIndicator()
                
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    let dataValue = dictionary["data"] as! Bool!
                    
                    if dataValue == true {                        self.navigationController?.popViewController(animated: true)
                    } else {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                    }
                }
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pagecontrol.currentPage = Int(currentPage);
        // Change the text accordingly
    }

    func timediffernce(dateStr : String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ" //Your date format //yyyy-MM-dd'T'HH:mm:ss-mm:ss
        
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(name: "PT") as TimeZone!
        
        let date = dateFormatter.date(from: dateStr) //according to date format your date string
        let now = Date()
        let timeOffset = now.offset(from:date! ) //
        return ("\(timeOffset) ago")
        
    }
    @IBAction func doneBtnClicked(_ sender: Any) {
        if self.postcommentObj != nil {
            self.navigationController?.popViewController(animated: true)
        }
        else{
          delegate?.finishPassing(imgArray: Tempimagearray)
         self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
