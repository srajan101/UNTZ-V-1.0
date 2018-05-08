//
//  ExtendedViewController.swift
//  Enmoji
//
//  Created by Mahesh on 15/12/16.
//  Copyright © 2016 Mahesh Sonaiya. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}
