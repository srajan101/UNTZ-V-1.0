//
//  CreateEventViewController.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 06/10/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {

    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var addBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*
        self.title = "Create Event"
        
        var image1 = UIImage(named: "menu")
        image1 = image1?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image1, style: .plain, target: self, action: #selector(showLeftView(sender:)))
        */
        imageV.layer.cornerRadius = 3.0
        imageV.clipsToBounds = true
        
        txtView.layer.cornerRadius = 3.0
        txtView.clipsToBounds = true
        txtView.layer.borderWidth = 0.5
        txtView.layer.borderColor = UIColor(red: 202/255, green: 202/255, blue: 202/255, alpha: 1).cgColor
        
        addBtn.layer.cornerRadius = 25.0
        addBtn.clipsToBounds = true
        
        //txtView.text = "https://www.facebook.com/events/275318846291891/"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        //self.navigationController?.isNavigationBarHidden = true
        
        addCustomNavBar(self, isMenuRequired: true, title: "Create Event", backhandler: {
            self.showLeftView()
        })
        
    }
    
    func showLeftView() {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    @IBAction func createEventAction(_ sender: Any) {
        self.txtView .resignFirstResponder()
        
        if txtView.text.length == 0 {
            GLOBAL().showAlert(APPLICATION.applicationName, message: "Please enter event URL!", actions: nil)
        } else {
            GLOBAL().showLoadingIndicatorWithMessage("")
            
            let escapedString = txtView.text.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            UNTZReqeustManager.sharedInstance.apiImportFacebookEvent(escapedString!, completionHandler: {
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
                            self.txtView.text = ""
                            self.txtView .resignFirstResponder()
                            
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            GLOBAL().showAlert(APPLICATION.applicationName, message: "Something is not working!", actions: nil)
                        }
                    }
                }
            })
        }
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
