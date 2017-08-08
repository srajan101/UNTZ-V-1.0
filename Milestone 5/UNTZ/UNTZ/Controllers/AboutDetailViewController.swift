//
//  AboutDetailViewController.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 06/07/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class AboutDetailViewController: UIViewController {

    @IBOutlet weak var locationLabel: UNLabel!
    @IBOutlet weak var descriptiontextView: UNTextView!
    open var detailTxt : String?
    open var LocationTxt : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 190, green: 20/255, blue: 17/255, alpha: 1)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        locationLabel.text = LocationTxt
        descriptiontextView.text = detailTxt
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
