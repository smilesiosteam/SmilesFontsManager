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
    private let textStyle: UIFont.TextStyle
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
        textColor: UIColor? = nil
    ) {
        self.name = name
        self.fontName = fontName
        self.maximumPointSize = maximumPointSize
        self.minimumPointSize = minimumPointSize
        self.pointSize = fontSize
        self.letterSpacing = letterSpacing
        self.textColor = textColor
        self.textStyle = UIFont.TextStyle(rawValue: name)
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
        return font(fontName, pointSize: pointSize)
    }
    
    /// Convenience method for retrieving the line height.
    @MainActor
    public func lineHeight() -> CGFloat? {
        return font()?.lineHeight
    }
    
}

private extension Typography {
    
    private func resolvedMaxPointSize() -> Float? {
        return maximumPointSize
    }
    
    private func resolvedMinPointSize() -> Float? {
        return minimumPointSize
    }
    
    /// Resolves font definitions defined in configuration to the system font with the specified `UIFont.Weight`.
    /// e.g. 'system-ultra-light' resolves to the system font with `UIFont.Weight` of `.ultraLight`.
    private func resolveSystemFont(_ fontName: String, pointSize: Float) -> UIFont? {
        let lowerCasedFontName = fontName.lowercased()
        let points = CGFloat(pointSize)
        if let unweightedFont = unweightedSystemFont(fontName, pointSize: points) {
            return unweightedFont
        }
        let lowerCasedSystemFontName = type(of: self).systemFontName.lowercased()
        let lowerCasedMonospacedDigitSystemFontName = type(of: self).monospacedDigitSystemFontName.lowercased()
        let fontWeights = type(of: self).fontWeightMap
        for (fontWeightName, fontWeight) in fontWeights {
            let lowercasedFontWeightName = fontWeightName.lowercased()
            let systemFontWithWeightName = "\(lowerCasedSystemFontName)-\(lowercasedFontWeightName)"
            if lowerCasedFontName == systemFontWithWeightName {
                return UIFont.systemFont(ofSize: points, weight: fontWeight)
            }
            let monospacedDigitFontWithWeightName =
            "\(lowerCasedMonospacedDigitSystemFontName)-\(lowercasedFontWeightName)"
            if #available(iOS 9.0, *), lowerCasedFontName == monospacedDigitFontWithWeightName {
                return UIFont.monospacedDigitSystemFont(ofSize: points, weight: fontWeight)
            }
        }
        return nil
    }
    
    /// Scales `UIFont` using a `UIFontMetrics` obtained from a `UIFont.TextStyle`.
    private func scaleUsingFontMetrics(
        _ fontName: String,
        pointSize: Float,
        textStyle: UIFont.TextStyle,
        contentSizeCategory: UIContentSizeCategory
    ) -> UIFont? {
        guard var newFont = font(fontName, pointSize: pointSize) else {
            return nil
        }
        let traitCollection = UITraitCollection(preferredContentSizeCategory: contentSizeCategory)
        if let maxPointSize = resolvedMaxPointSize() {
            newFont = UIFontMetrics.default.scaledFont(
                for: newFont,
                maximumPointSize: CGFloat(maxPointSize),
                compatibleWith: traitCollection
            )
        } else {
            newFont = UIFontMetrics.default.scaledFont(for: newFont, compatibleWith: traitCollection)
        }
        if let minimumPointSize = resolvedMinPointSize(), newFont.pointSize < CGFloat(minimumPointSize) {
            return font(fontName, pointSize: minimumPointSize)
        } else {
            return newFont
        }
    }
    
    /// Scales `UIFont` using a step size * multiplier increasing in-line with the `UIContentSizeCategory` value.
    private func scaleUsingStepping(_ fontName: String, pointSize: Float, contentSize: UIContentSizeCategory)
    -> UIFont? {
        // No scaling if the UIContentSizeCategory cannot be found in map.
        let defaultContentSizeCategoryScaling: Float = 0.0
        let contentSizeCategoryScaling = type(of: self).contentSizeCategoryMap[contentSize]
        ?? defaultContentSizeCategoryScaling
        let stepSizeMultiplier: Float = 1.0
        let stepSize: Float = 2.0
        var newPointSize = pointSize + (stepSize * stepSizeMultiplier * contentSizeCategoryScaling)
        if let minimumPointSize = resolvedMinPointSize(), newPointSize < minimumPointSize {
            newPointSize = minimumPointSize
        }
        if let maximumPointSize = resolvedMaxPointSize(), maximumPointSize < newPointSize {
            newPointSize = maximumPointSize
        }
        return font(fontName, pointSize: newPointSize)
    }
    
    private func font(_ fontName: String, pointSize: Float) -> UIFont? {
        resolveSystemFont(fontName, pointSize: pointSize) ?? UIFont(name: fontName, size: CGFloat(pointSize))
    }
    
    /// Resolves font entries in configuration to the following `UIFont` methods:
    /// System -> systemFont(ofSize: CGFloat) -> UIFont
    /// BoldSystem -> boldSystemFont(ofSize: CGFloat) -> UIFont
    /// ItalicSystem -> italicSystemFont(ofSize: CGFloat) -> UIFont
    private func unweightedSystemFont(_ fontName: String, pointSize: CGFloat) -> UIFont? {
        let lowerCasedFontName = fontName.lowercased()
        let lowerCasedSystemFontName = type(of: self).systemFontName.lowercased()
        let lowerCasedBoldSystemFontName = type(of: self).boldSystemFontName.lowercased()
        let lowerCasedItalicSystemFontName = type(of: self).italicSystemFontName.lowercased()
        let points = CGFloat(pointSize)
        switch lowerCasedFontName {
        case lowerCasedSystemFontName:
            return UIFont.systemFont(ofSize: points)
        case lowerCasedBoldSystemFontName:
            return UIFont.boldSystemFont(ofSize: points)
        case lowerCasedItalicSystemFontName:
            return UIFont.italicSystemFont(ofSize: points)
        default:
            return nil
        }
    }
    
}
