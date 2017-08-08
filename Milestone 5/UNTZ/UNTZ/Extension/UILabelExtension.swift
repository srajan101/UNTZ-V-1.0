//
//  UILabelExtension.swift
//  Enmoji
//
//  Created by Mahesh on 02/01/17.
//  Copyright © 2017 Mahesh Sonaiya. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func scaleTextFonts() {
        let newFontSize = (DYNAMICFONTSIZE.SCALE_FACT_FONT * (self.font?.pointSize)!)
        self.font = UIFont.init(name: (self.font?.fontName)!, size: newFontSize)
    }
}
