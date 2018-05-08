//
//  PostViewController.swift
//  UNTZ
//
//  Created by Shivang on 20/08/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit
protocol VCPostViewDelegate {
    func finishPosting()
}

class PostViewController: UIViewController, UITextViewDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate , VCGalleryDelegate{
    open var eventId : Int?
    
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    var delegate: VCPostViewDelegate?
    
    @IBOutlet weak var statusTextPop: UITextView!
    @IBOutlet weak var profileImgVPop: UIImageView!

    let picker = UIImagePickerController()
    var eventImages = NSMutableArray()
    open var iswithImage : Bool?
    open var isFirstTime = false
    
    open var imgVal : UIImage?
    @IBOutlet weak var ImgBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 190, green: 20/255, blue: 17/255, alpha: 1)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        self.navigationController?.navigationBar.isHidden = true
        */
        profileImgVPop.layer.cornerRadius = profileImgVPop.frame.size.height / 2
        profileImgVPop.clipsToBounds = true
        
        profileImgVPop.sd_setImage(with: URL(string: UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.Imageurl) as! String), placeholderImage: nil)

         eventImages = NSMutableArray()
        // Do any additional setup after loading the view.
        
        statusTextPop.text = "What’s on your mind?"
        statusTextPop.textColor = UIColor.lightGray
        statusTextPop.delegate = self
        
        picker.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        //self.navigationController?.isNavigationBarHidden = true
        
        addPersonalizeNavBar(self, leftButtonTitle: "Cancel", rightButtonTitle: "Post", rightButtonImage: nil, title: "Update Status", backhandler: {
            self.navigationController?.popViewController(animated: true)

        }) {
            self.userPostBtnClicked()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTime == false {
            isFirstTime = true
            if iswithImage! {
                //image1.isHidden = false
                //image1.image = imgVal
                eventImages.add(imgVal!)
                self.displayImagesfromArray()
            }else{
                image1.isHidden = true
                statusTextPop.becomeFirstResponder()
            }
            image2.isHidden = true
            image3.isHidden = true
            image4.isHidden = true
            image5.isHidden = true
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.isNavigationBarHidden = false
    }


    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func PostBtnClicked(_ sender: Any) {
        if statusTextPop.textColor == UIColor.lightGray {
            statusTextPop.text = nil
            statusTextPop.textColor = UIColor.black
        }
        if eventImages.count == 0 {
            uploadCommentWithOutImages()
        } else {
            uploadCommentWithImages()
        }
    }
    
    func userPostBtnClicked() {
        if statusTextPop.textColor == UIColor.lightGray {
            statusTextPop.text = nil
            statusTextPop.textColor = UIColor.black
        }
        if eventImages.count == 0 {
            uploadCommentWithOutImages()
        } else {
            uploadCommentWithImages()
        }
    }
    
    func uploadCommentWithOutImages() {
        GLOBAL().showLoadingIndicatorWithMessage("")
        
        let commentBodyParams: [String: String] =
            [UNTZAPIRequestKeys.comment:statusTextPop.text ,
             UNTZAPIRequestKeys.eventId: String.init(format: "%ld", self.eventId!)
        ]
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
                        self.statusTextPop.text = "What’s on your mind?"
                        self.statusTextPop.textColor = UIColor.lightGray
                        self.statusTextPop .resignFirstResponder()
                        
                        self.delegate?.finishPosting()
                self.navigationController?.popViewController(animated: true)
                    } else {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                    }
                }
            }
        }

    }
    
    func uploadCommentWithImages() {
        if UserInfo.sharedInstance.getUserDefault(key: UNUserInfoKeys.accessToken) != nil {
            
            var imageData = [Data]()

            for i in (0..<eventImages.count)
            {
                let image = eventImages[i] as! UIImage
                if let data = UIImageJPEGRepresentation(image, 0.5) {
                    imageData.append(data as Data)
                    
                }
            }
            
            if (imageData.count) > 0 {
                startUploadImageProcess(imageData: imageData)
            }
        } else {
            GLOBAL().showAlert(APPLICATION.applicationName, message: "Login to Update Status!", actions: nil)
            
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
                    
                        self.delegate?.finishPosting()
                            self.navigationController?.popViewController(animated: true)
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
    @IBAction func deleteImageClicked(_ sender: UIButton) {
        eventImages.removeObject(at: (sender.tag - 1))
        self.displayImagesfromArray()
    }
    @IBAction func openCameraOrLibrary(_ sender: UIButton) {
        if eventImages.count<5 {
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
    
    @IBAction func imagebtnClicked(_ sender: Any) {
        if eventImages.count > 0 {
                let detailObj = makeStoryObj(storyboard: storyboard_R1, Identifier: "IDGalleryViewController") as! GalleryViewController
            detailObj.delegate = self
            detailObj.eventId = eventId
            detailObj.Tempimagearray = eventImages
                pushStoryObj(obj: detailObj, on: self)
                
        }
    }
    func finishPassing(imgArray: NSMutableArray){
        eventImages = NSMutableArray()
        eventImages = imgArray
        self.displayImagesfromArray()
    }
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        eventImages.add(chosenImage)
        self.displayImagesfromArray()
        dismiss(animated:true, completion: nil) //5
        
    }
    
    func displayImagesfromArray(){
        image1.image = nil
        image1.contentMode = .scaleAspectFill
        image1.clipsToBounds = true
        
        image2.image = nil
        image2.contentMode = .scaleAspectFill
        image2.clipsToBounds = true
        
        image3.image = nil
        image3.contentMode = .scaleAspectFill
        image3.clipsToBounds = true
        
        image4.image = nil
        image4.contentMode = .scaleAspectFill
        image4.clipsToBounds = true
        
        image5.image = nil
        image5.contentMode = .scaleAspectFill
        image5.clipsToBounds = true
        
        
        for i in (0..<eventImages.count)
        {
            if i == 0 {
                image1.image = eventImages[0] as? UIImage
                image1.isHidden = false
            }
            if i == 1 {
                image2.image = eventImages[1] as? UIImage
                image2.isHidden = false
            }
            if i == 2 {
                image3.image = eventImages[2] as? UIImage
                image3.isHidden = false
            }
            if i == 3 {
                image4.image = eventImages[3] as? UIImage
                image4.isHidden = false
            }
            if i == 4 {
                image5.image = eventImages[4] as? UIImage
                image5.isHidden = false
            }
            
            var width1 = self.view.frame.width - (2*15)
            let height1 = ImgBtn.frame.height
            var height2 = height1
            let mainX = 10
            let mainY = Int(ImgBtn.frame.origin.y)
            if eventImages.count>1{
                width1 = (self.view.frame.width - (2*15))/2;
            }
            
            if eventImages.count == 1 {
                image1.frame = CGRect(x: mainX, y: mainY, width: Int(width1), height:Int(height1))
            }
            if eventImages.count==2 {
                if i == 0 {
                    image1.frame = CGRect(x: mainX, y: mainY, width: Int(width1), height:Int(height1))
                }
                else{
                    image2.frame = CGRect(x:mainX + Int(width1+5), y: mainY, width: Int(width1), height:Int(height2))
                }
                
            }
            if eventImages.count==3 {
                height2 = (height1/2)-10
                if i == 0 {
                    image1.frame = CGRect(x: mainX, y: mainY, width: Int(width1), height:Int(height1-15))
                }
                else if i == 1{
                    image2.frame = CGRect(x: mainX + Int(width1)+5, y: mainY, width: Int(width1), height:Int(height2))
                }
                else{
                    image3.frame = CGRect(x: mainX + Int(width1+5), y: mainY + Int(height2+5), width: Int(width1), height:Int(height2))
                }
            }
            if eventImages.count==4 {
                height2 = (height1/3)-10
                if i == 0 {
                    image1.frame = CGRect(x: mainX, y: mainY, width: Int(width1), height:Int(height1-20))
                }
                else if i == 1{
                    image2.frame = CGRect(x: mainX + Int(width1)+5, y: mainY, width: Int(width1), height:Int(height2))
                }
                else if i == 2{
                    image3.frame = CGRect(x: mainX + Int(width1)+5, y: mainY + Int(height2+5), width: Int(width1), height:Int(height2))
                }
                else {
                    image4.frame = CGRect(x: mainX + Int(width1)+5, y: mainY + Int(height2+height2+10), width: Int(width1), height:Int(height2))
                }
            }
            if eventImages.count>4 {
                height2 = (height1/2)-10
                let width2 = (self.view.frame.width - (2*15))/3 - 1
                if i == 0 {
                    image1.frame = CGRect(x: mainX, y: mainY, width: Int(width1), height:Int(height2))
                }
                else if i == 1{
                    image2.frame = CGRect(x: mainX + Int(width1)+5, y: mainY, width: Int(width1), height:Int(height2))
                }
                else if i == 2{
                    image3.frame = CGRect(x: mainX, y: mainY + Int(height2 + 5), width: Int(width2), height:Int(height2))
                }
                else if i == 3{
                    image4.frame = CGRect(x: mainX + Int(width2)+5, y: mainY + Int(height2 + 5), width: Int(width2), height:Int(height2))
                }
                else {
                    image5.frame = CGRect(x:mainX + Int(width2)+5+Int(width2)+5, y: mainY + Int(height2 + 5), width: Int(width2), height:Int(height2))
                }
            }
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
