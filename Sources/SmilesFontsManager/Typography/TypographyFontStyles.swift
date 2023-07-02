//
//  File.swift
//
//
//  Created by Abdul Rehman Amjad on 06/04/2023.
//

import Foundation

public enum TypographyFontStyles: String, CaseIterable {
    
    case smilesHeadline1, smilesHeadline2, smilesHeadline3, smilesHeadline4, smilesHeadline5
    case smilesTitle1, smilesTitle2, smilesTitle3
    case smilesBody1, smilesBody2, smilesBody3, smilesBody4
    case smilesLabel1, smilesLabel2, smilesLabel3
    
    func getTypography() -> Typography {
        switch self {
        case .smilesHeadline1:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .medium), fontSize: 32, letterSpacing: -1, lineHeight: 36)
        case .smilesHeadline2:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .medium), fontSize: 24, letterSpacing: -1, lineHeight: 32)
        case .smilesHeadline3:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .medium), fontSize: 18, letterSpacing: -0.5, lineHeight: 24)
        case .smilesHeadline4:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .medium), fontSize: 16, letterSpacing: -0.5, lineHeight: 24)
        case .smilesHeadline5:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .medium), fontSize: 14, letterSpacing: 0, lineHeight: 20)
        case .smilesTitle1:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .medium), fontSize: 16, letterSpacing: 0, lineHeight: 18)
        case .smilesTitle2:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .medium), fontSize: 14, letterSpacing: 0, lineHeight: 16)
        case .smilesTitle3:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .medium), fontSize: 12, letterSpacing: 0, lineHeight: 14)
        case .smilesBody1:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .regular), fontSize: 18, letterSpacing: 0, lineHeight: 22)
        case .smilesBody2:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .regular), fontSize: 16, letterSpacing: 0, lineHeight: 20)
        case .smilesBody3:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .book), fontSize: 14, letterSpacing: 0, lineHeight: 18)
        case .smilesBody4:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .book), fontSize: 12, letterSpacing: 0, lineHeight: 16)
        case .smilesLabel1:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .book), fontSize: 11, letterSpacing: 8, lineHeight: 14)
        case .smilesLabel2:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .book), fontSize: 12, letterSpacing: 8, lineHeight: 16)
        case .smilesLabel3:
            return Typography(name: self.rawValue, fontName: SmilesFontsManager.defaultAppFont.getFontName(fontStyle: .book), fontSize: 8, letterSpacing: 8, lineHeight: 14)
        }
    }
    
}
