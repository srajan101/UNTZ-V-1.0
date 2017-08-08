//
//  Theme.swift
//  Enmoji
//
//  Created by Mahesh on 16/12/16.
//  Copyright © 2016 Mahesh Sonaiya. All rights reserved.
//

import Foundation
import UIKit

class Theme {
    static func getRobotoMedium(size : CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size)!
    }
 
    static func getRobotoRegular(size : CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size)!
    }
    
    static func getMenuItemSelectedColor() -> UIColor {
        return UIColor(red: 66.0/255, green: 133.0/255, blue: 244.0/255, alpha: 1.0)
    }
    
    static func getMenuItemNormalColor() -> UIColor {
        return UIColor(red: 157.0/255, green: 157.0/255, blue: 157.0/255, alpha: 1.0)
    }
    
    static func getTextFieldBorderColor() -> UIColor {
        return UIColor(red: 202.0/255, green: 202.0/255, blue: 202.0/255, alpha: 1.0)
    }
}
