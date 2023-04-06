//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 06/04/2023.
//

import Foundation
import UIKit

enum TypographyKitPropertyAdditionsKey {
    static var fontTextStyle: UInt8 = 0
    static var typography: UInt8 = 1
    static var letterCase: UInt8 = 2
    static var titleColorApplyMode: UInt8 = 3
}

extension UILabel {
    
    @objc public var fontTextStyle: UIFont.TextStyle {
        get {
            // swiftlint:disable:next force_cast
            return objc_getAssociatedObject(self, &TypographyKitPropertyAdditionsKey.fontTextStyle) as! UIFont.TextStyle
        }
        set {
            objc_setAssociatedObject(self,
                                     &TypographyKitPropertyAdditionsKey.fontTextStyle,
                                     newValue, .OBJC_ASSOCIATION_RETAIN)
            if let typography = Typography(for: newValue) {
                self.typography = typography
            }
        }
    }
    
    @objc public var fontTextStyleName: String {
        get {
            return fontTextStyle.rawValue
        }
        set {
            fontTextStyle = UIFont.TextStyle(rawValue: newValue)
        }
    }
    
    public var typography: Typography {
        get {
            // swiftlint:disable:next force_cast
            return objc_getAssociatedObject(self, &TypographyKitPropertyAdditionsKey.typography) as! Typography
        }
        set {
            objc_setAssociatedObject(self, &TypographyKitPropertyAdditionsKey.typography,
                                     newValue, .OBJC_ASSOCIATION_RETAIN)
            addObserver()
            guard !isAttributed() else {
                return
            }
            if let newFont = newValue.font(UIApplication.shared.preferredContentSizeCategory) {
                self.font = newFont
            }
            if let textColor = newValue.textColor {
                self.textColor = textColor
            }
        }
    }
    
    // MARK: Functions
    
    /// - parameters:
    ///     - replacingDefaultTextColor: If the `NSAttributedString` already specifies `foregroundColor` attributes
    /// then setting this value to `true` determines the most used foregroundColor attribute and replaces the color
    /// value with the value of the `textColor` parameter.
    public func attributedText(_ text: NSAttributedString?, style: UIFont.TextStyle,
                               textColor: UIColor? = nil,
                               replacingDefaultTextColor: Bool = false) {
        // Update text.
        if let text = text {
            self.attributedText = text
        }
        // Update text color.
        if let textColor = textColor {
            self.textColor = textColor
        }
        guard var typography = Typography(for: style), let attrString = text else {
            return
        }
        // Apply overriding parameters.
        typography.textColor = textColor ?? typography.textColor
        self.fontTextStyle = style
        self.typography = typography
        let mutableString = NSMutableAttributedString(attributedString: attrString)
        let textRange = NSRange(location: 0, length: attrString.string.count)
        mutableString.enumerateAttributes(in: textRange, options: [], using: { value, range, _ in
            update(attributedString: mutableString, with: value, in: range, and: typography)
        })
        self.attributedText = mutableString
        if replacingDefaultTextColor {
            let defaultColor = defaultTextColor(in: mutableString)
            let replacementString = replaceTextColor(defaultColor, with: typography.textColor, in: mutableString)
            self.attributedText = replacementString
        }
        if self.typography.letterSpacing > 0 {
            guard let attrString = self.attributedText else {
                return
            }
            let spacingString = NSMutableAttributedString(attributedString: attrString)
            spacingString.addAttribute(.kern, value: self.typography.letterSpacing, range: textRange)
            self.attributedText = spacingString
        }
    }

    public func text(_ text: String?, style: UIFont.TextStyle,
                     textColor: UIColor? = nil) {
        if let text = text {
            self.text = text
        }
        if var typography = Typography(for: style) {
            // Only override letterCase and textColor if explicitly specified
            if let textColor = textColor {
                typography.textColor = textColor
            }
            self.typography = typography
            
            if self.typography.letterSpacing > 0 {
                self.attributedText(NSAttributedString(string: self.text ?? ""), style: style)
            }
        }
    }
    
}

extension UILabel: TypographyKitElement {
    
    func isAttributed() -> Bool {
        guard let attributedText = attributedText else {
            return false
        }
        return isAttributed(attributedText)
    }
    
    func contentSizeCategoryDidChange(_ notification: NSNotification) {
        if let newValue = notification.userInfo?[UIContentSizeCategory.newValueUserInfoKey] as? UIContentSizeCategory {
            if isAttributed(attributedText) {
                self.attributedText(attributedText, style: fontTextStyle)
            } else {
                self.font = self.typography.font(newValue)
            }
            self.setNeedsLayout()
        }
    }
    
}
