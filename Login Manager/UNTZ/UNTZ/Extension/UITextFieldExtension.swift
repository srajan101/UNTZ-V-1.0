//
//  UITextFieldExtension.swift
//  Enmoji
//
//  Created by Mahesh on 27/12/16.
//  Copyright © 2016 Mahesh Sonaiya. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func addBorderLayer() {
        self.layer.borderWidth = (DYNAMICFONTSIZE.SCALE_FACT_FONT * 0.5)
        self.layer.borderColor = Theme.getTextFieldBorderColor().cgColor
        
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 8, height: 0))
        self.leftView = paddingView;
        self.leftViewMode = UITextFieldViewMode.always
    }
    
    func scaleTextFonts() {
        let newFontSize = (DYNAMICFONTSIZE.SCALE_FACT_FONT * (self.font?.pointSize)!)
        self.font = UIFont.init(name: (self.font?.fontName)!, size: newFontSize)
    }
}
