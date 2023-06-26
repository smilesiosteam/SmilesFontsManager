//
//  Typography.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/16/17.
//
//

import UIKit

public struct Typography {
    public let name: String
    public let fontName: String?
    public let maximumPointSize: Float?
    public let minimumPointSize: Float?
    public let pointSize: Float? // base point size for font
    public var letterSpacing: Double = 0
    public var textColor: UIColor?
    public var textLineHeight: CGFloat?
    public let textStyle: UIFont.TextStyle
    private static let contentSizeCategoryMap: [UIContentSizeCategory: Float] = [
        UIContentSizeCategory.extraSmall: -3,
        UIContentSizeCategory.small: -2,
        UIContentSizeCategory.medium: -1,
        UIContentSizeCategory.large: 0,
        UIContentSizeCategory.extraLarge: 1,
        UIContentSizeCategory.extraExtraLarge: 2,
        UIContentSizeCategory.extraExtraExtraLarge: 3,
        UIContentSizeCategory.accessibilityMedium: 4,
        UIContentSizeCategory.accessibilityLarge: 5,
        UIContentSizeCategory.accessibilityExtraLarge: 6,
        UIContentSizeCategory.accessibilityExtraExtraLarge: 7,
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 8
    ]
    private static let fontWeightMap: [String: UIFont.Weight] = [
        "black": UIFont.Weight.black,
        "bold": UIFont.Weight.bold,
        "heavy": UIFont.Weight.heavy,
        "light": UIFont.Weight.light,
        "medium": UIFont.Weight.medium,
        "regular": UIFont.Weight.regular,
        "semibold": UIFont.Weight.semibold,
        "thin": UIFont.Weight.thin,
        "ultraLight": UIFont.Weight.ultraLight,
        // Alternatives we wish to make parseable.
        "semi-bold": UIFont.Weight.semibold,
        "ultra-light": UIFont.Weight.ultraLight
    ]
    private static let boldSystemFontName = "Bold\(systemFontName)"
    private static let italicSystemFontName = "Italic\(systemFontName)"
    private static let monospacedDigitSystemFontName = "MonospacedDigit\(systemFontName)"
    private static let systemFontName = "System"
    
    public init?(for textStyle: UIFont.TextStyle) {
        guard let typographyStyle = TypographyFontStyles(rawValue: textStyle.rawValue)?.getTypography() else {
            return nil
        }
        self.name = typographyStyle.name
        self.fontName = typographyStyle.fontName
        self.maximumPointSize = typographyStyle.maximumPointSize
        self.minimumPointSize = typographyStyle.minimumPointSize
        self.pointSize = typographyStyle.pointSize
        self.letterSpacing = typographyStyle.letterSpacing
        self.textColor = typographyStyle.textColor
        self.textStyle = textStyle
    }
    
    public init(
        name: String,
        fontName: String? = nil,
        fontSize: Float? = nil,
        letterSpacing: Double = 0,
        maximumPointSize: Float? = nil,
        minimumPointSize: Float? = nil,
        textColor: UIColor? = nil,
        lineHeight: CGFloat? = nil
    ) {
        self.name = name
        self.fontName = fontName
        self.maximumPointSize = maximumPointSize
        self.minimumPointSize = minimumPointSize
        self.pointSize = fontSize
        self.letterSpacing = letterSpacing
        self.textColor = textColor
        self.textStyle = UIFont.TextStyle(rawValue: name)
        self.textLineHeight = lineHeight
    }
    
    /// Convenience method for retrieving the font for the preferred `UIContentSizeCategory`.
    @MainActor
    public func font() -> UIFont? {
        return font(UIApplication.shared.preferredContentSizeCategory)
    }
    
    /// Returns a `UIFont` scaled appropriately for the given `UIContentSizeCategory` using the specified scaling
    /// method.
    public func font(_ contentSizeCategory: UIContentSizeCategory) -> UIFont? {
        guard let fontName = self.fontName, let pointSize = self.pointSize else {
            return nil
        }
        return UIFont(name: fontName, size: CGFloat(pointSize))
    }
    
    /// Convenience method for retrieving the line height.
    @MainActor
    public func lineHeight() -> CGFloat? {
        return font()?.lineHeight
    }
    
}
