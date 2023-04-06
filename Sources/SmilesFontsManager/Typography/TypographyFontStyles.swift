//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 06/04/2023.
//

import Foundation

public enum TypographyFontStyles: String, CaseIterable {
    
    case headline1, headline2, headline3, headline4, headline5
    case title1, title2, title3
    case subtitle1, subtitle2
    case body1, body2, body3
    case label1, label2
    
    func getTypography() -> Typography {
        switch self {
        case .headline1:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .medium), fontSize: 32, letterSpacing: -0.4)
        case .headline2:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .medium), fontSize: 28, letterSpacing: -0.4)
        case .headline3:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .medium), fontSize: 22, letterSpacing: -0.2)
        case .headline4:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .medium), fontSize: 20, letterSpacing: -0.2)
        case .headline5:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .medium), fontSize: 18, letterSpacing: -0.1)
        case .title1:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .medium), fontSize: 16, letterSpacing: -0.1)
        case .title2:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .medium), fontSize: 14, letterSpacing: -0.1)
        case .title3:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .medium), fontSize: 14, letterSpacing: -0.1)
        case .subtitle1:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .book), fontSize: 14, letterSpacing: -0.1)
        case .subtitle2:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .regular), fontSize: 14, letterSpacing: -0.1)
        case .body1:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .book), fontSize: 18, letterSpacing: -0.1)
        case .body2:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .regular), fontSize: 16, letterSpacing: -0.1)
        case .body3:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .regular), fontSize: 14, letterSpacing: -0.1)
        case .label1:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .bold), fontSize: 11, letterSpacing: -0.1)
        case .label2:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .book), fontSize: 12, letterSpacing: -0.1)
        }
    }
    
}
