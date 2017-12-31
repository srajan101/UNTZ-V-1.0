//
//  ImageViewExtension.swift
//  Enmoji
//
//  Created by Mahesh on 28/12/16.
//  Copyright © 2016 Mahesh Sonaiya. All rights reserved.
//

import Foundation
import AlamofireImage
import Alamofire

extension UIImageView {
   
    public func makeCircle() {
        self.layer.cornerRadius = ((DYNAMICFONTSIZE.SCALE_FACT_FONT * self.frame.height) / 2)
        self.layer.masksToBounds = true
    }
    
    public func loadImage(_ URL:String) {
        Alamofire.request(URL).responseImage { response in
            debugPrint(response)
            
            debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                self.image = image
            }
        }
    }
}
