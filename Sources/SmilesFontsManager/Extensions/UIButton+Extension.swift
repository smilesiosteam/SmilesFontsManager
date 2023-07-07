//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 06/04/2023.
//

import Foundation
import UIKit

@objc public enum ButtonTitleColorApplyMode: Int, Codable {
    case all                // applies the style color to all control states
    case none               // doesn't apply the style color to any control states
    case normal             // applies the style color to the .normal state only
    case whereUnspecified   // applies the style color to any state where a color hasn't been explicitly specified
    
    init?(string: String) {
        switch string {
        case "all":
            self = .all
        case "none":
            self = .none
        case "normal":
            self = .normal
        case "where-unspecified":
            self = .whereUnspecified
        default:
            return nil
        }
    }
}


extension UIButton {
    
    public typealias TitleColorApplyMode = ButtonTitleColorApplyMode
    
    @objc public var fontTextStyle: UIFont.TextStyle {
        get {
            // swiftlint:disable:next force_cast
            return objc_getAssociatedObject(self, &TypographyKitPropertyAdditionsKey.fontTextStyle) as! UIFont.TextStyle
        }
        set {
            objc_setAssociatedObject(self, &TypographyKitPropertyAdditionsKey.fontTextStyle,
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
    
    @objc public var titleColorApplyMode: TitleColorApplyMode {
        get {
            objc_getAssociatedObject(
                self,
                &TypographyKitPropertyAdditionsKey.titleColorApplyMode
            ) as? TitleColorApplyMode ?? .whereUnspecified
        }
        set {
            objc_setAssociatedObject(
                self,
                &TypographyKitPropertyAdditionsKey.titleColorApplyMode,
                newValue,
                .OBJC_ASSOCIATION_RETAIN
            )
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
                self.titleLabel?.font = newFont
            }
            if let textColor = newValue.textColor {
                applyTitleColor(textColor, mode: titleColorApplyMode)
            }
            let attrString = NSAttributedString(string: self.title(for: .normal) ?? "")
            let spacingString = NSMutableAttributedString(attributedString: attrString)
            let textRange = NSRange(location: 0, length: attrString.string.count)
            spacingString.addAttribute(.kern, value: self.typography.letterSpacing, range: textRange)
            if let lineHeight = self.typography.textLineHeight {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = lineHeight
                spacingString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, spacingString.length))
            }
            self.titleLabel?.attributedText = spacingString
        }
    }
    
    // MARK: Functions
    
    public func attributedText(_ text: NSAttributedString?, style: UIFont.TextStyle, alignment: NSTextAlignment = .natural,
                               textColor: UIColor? = nil,
                               replacingDefaultTextColor: Bool = false) {
        // Update text.
        if let text = text {
            self.setAttributedTitle(text, for: .normal)
        }
        // Update text color.
        if let textColor = textColor {
            self.setTitleColor(textColor, for: .normal)
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
        
        mutableString.addAttribute(.kern, value: self.typography.letterSpacing, range: textRange)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        if let lineHeight = self.typography.textLineHeight {
            paragraphStyle.lineSpacing = lineHeight
        }
        mutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, mutableString.length))
        
        self.titleLabel?.attributedText = mutableString
        if replacingDefaultTextColor {
            let defaultColor = defaultTextColor(in: mutableString)
            let replacementString = replaceTextColor(defaultColor, with: typography.textColor, in: mutableString)
            self.titleLabel?.attributedText = replacementString
        }
        
    }
    
    public func text(_ text: String?, style: UIFont.TextStyle,
                     textColor: UIColor? = nil) {
        if let text = text {
            self.setTitle(text, for: .normal)
        }
        if var typography = Typography(for: style) {
            // Only override letterCase and textColor if explicitly specified
            if let textColor = textColor {
                typography.textColor = textColor
            }
            self.typography = typography
        }
    }
    
}

extension UIButton: TypographyKitElement {
    
    func isAttributed() -> Bool {
        guard let attributedText = titleLabel?.attributedText else {
            return false
        }
        return isAttributed(attributedText)
    }
    
    func contentSizeCategoryDidChange(_ notification: NSNotification) {
        if let newValue = notification.userInfo?[UIContentSizeCategory.newValueUserInfoKey] as? UIContentSizeCategory {
            if let attributedText = titleLabel?.attributedText, isAttributed(attributedText) {
                self.attributedText(attributedText, style: fontTextStyle)
            } else {
                self.titleLabel?.font = self.typography.font(newValue)
            }
        }
    }
    
}

extension UIButton {
    
    func applyTitleColor(_ color: UIColor, mode: TitleColorApplyMode) {
        switch mode {
        case .all:
            UIControl.State.allCases.forEach { controlState in
                setTitleColor(color, for: controlState)
            }
        case .none:
            return
        case .normal:
            setTitleColor(color, for: .normal)
        case .whereUnspecified:
            applyTitleColorWhereNoneSpecified(color)
        }
    }
    
    private func applyTitleColorWhereNoneSpecified(_ color: UIColor) {
        let defaultButton = UIButton(type: buttonType)
        let normalStateColor = titleColor(for: .normal)
        UIControl.State.allCases.forEach { controlState in
            let defaultStateColor = defaultButton.titleColor(for: controlState)
            let currentStateColor = titleColor(for: controlState)
            if defaultStateColor == currentStateColor
                || (controlState != .normal && currentStateColor == normalStateColor) {
                setTitleColor(color, for: controlState)
            }
        }
    }
    
}
