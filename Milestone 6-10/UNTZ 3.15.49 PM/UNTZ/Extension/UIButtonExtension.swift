//
//  UIButtonExtension.swift
//  Enmoji
//
//  Created by Mahesh on 02/01/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import Foundation
import UIKit

extension UIButton  {
    func scaleTextFonts() {
        let newFontSize = (DYNAMICFONTSIZE.SCALE_FACT_FONT * (self.titleLabel?.font?.pointSize)!)
        self.titleLabel?.font = UIFont.init(name: (self.titleLabel?.font?.fontName)!, size: newFontSize)
    }
    
    func makeCornerRounded(_ size : CGFloat) {
        self.layer.cornerRadius = (DYNAMICFONTSIZE.SCALE_FACT_FONT * (size))
        self.layer.masksToBounds = true
    }
 
}
