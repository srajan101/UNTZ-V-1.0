//
//  StringExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/22/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    func returnSignupFontBold(_ compareText : String) -> NSAttributedString {
        
        /* Find the position of the search string. Cast to NSString as we want
         range to be of type NSRange, not Swift's Range<Index> */
        let range = (self as NSString).range(of: compareText)
        
        /* Make the text at the given range bold. Rather than hard-coding a text size,
         Use the text size configured in Interface Builder. */
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Theme.getMenuItemSelectedColor(), range: range)
        
        /* Put the text in a label */
        return attributedString
    }
    
    var length: Int {
        return self.characters.count
    }
    
    //To check text field or String is blank or not
    var isStringBlank: Bool {
        get {
            let trimmed =
                self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    var isValidEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    //validate PhoneNumber
    var isValidPhoneNumber: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^+(?:[0-9] ?){9,14}[0-9]$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    
    var isValidUserName : Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-z0-9_-]{3,}$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil

        } catch {
            return false
        }
    }
    
    var isValidPassword : Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^(?=.*\\d)[A-Za-z\\d]{4,}$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
            
        } catch {
            return false
        }
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.width
    }
    
    func getBlankValidationMessage() -> String {
        return String.init(format: "Please enter %@.", self)
    }
    
    func getInvalidFieldValidationMessage() -> String {
        return String.init(format: "Please enter valid %@.",self)
    }
    
    func getMinCharsValidationMessage(_ length : Int) -> String {
        return String.init(format: "Please enter minimum %ld characters in %@.",length,self)
    }
    
    func getInvalidFieldValidationMessageWithSuggestion(_ suggestionRequired : String) -> String {
        return String.init(format: "Please enter valid %@ %@.", self,suggestionRequired)
    }
}
