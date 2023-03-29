//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 22/03/2023.
//

import Foundation
import UIKit

public enum SmilesFonts {
    
    case circular(FontStyle)
    case montserrat(FontStyle)
    case lato(FontStyle)
    
    func rawValued() -> String {
        switch self {
        case .circular(let fontStyle):
            return "CircularXXTT-" + fontStyle.rawValue
        case .montserrat(let fontStyle):
            return "Montserrat-" + fontStyle.rawValue
        case .lato(let fontStyle):
            return "Lato-" + fontStyle.rawValue
        }
    }
    
    public func getFont(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValued(), size: size) ?? .systemFont(ofSize: size)
    }
    
}

public enum FontStyle: String {
    
    case black = "Black"
    case blackItalic = "BlackItalic"
    case bold = "Bold"
    case boldItalic = "BoldItalic"
    case italic = "Italic"
    case light = "Light"
    case lightItalic = "LightItalic"
    case medium = "Medium"
    case mediumItalic = "MediumItalic"
    case regular = "Regular"
    case thin = "Thin"
    case thinItalic = "ThinItalic"
    case semiBold = "SemiBold"
    case extraLight = "ExtraLight"
    case extraBold = "ExtraBold"
    case book = "Book"
    case hairLine = "Hairline"
    
}
