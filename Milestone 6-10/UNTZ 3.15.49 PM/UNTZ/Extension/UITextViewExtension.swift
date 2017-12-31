//
//  UITextViewExtension.swift
//  Enmoji
//
//  Created by Mahesh on 09/01/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    
    func addBorderLayer() {
        self.layer.borderWidth = (DYNAMICFONTSIZE.SCALE_FACT_FONT * 0.5)
        self.layer.borderColor = Theme.getTextFieldBorderColor().cgColor
    }
    
    func scaleTextFonts() {
        let newFontSize = (DYNAMICFONTSIZE.SCALE_FACT_FONT * (self.font?.pointSize)!)
        self.font = UIFont.init(name: (self.font?.fontName)!, size: newFontSize)
    }
}
