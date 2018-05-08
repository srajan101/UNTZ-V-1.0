//
//  ImageViewController.swift
//  UNTZ
//
//  Created by Gaurang Pandya on 22/01/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageview: UIImageView!
    var imageURL : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageview.sd_setImage(with: URL.init(string: imageURL!), placeholderImage: UIImage.init(named: "default_image"), options: .refreshCached) { (image, error, imageCacheType, imageUrl) in
            if image != nil {
            } else {
            }
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
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
