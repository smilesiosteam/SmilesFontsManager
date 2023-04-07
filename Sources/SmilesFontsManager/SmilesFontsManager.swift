
import Foundation
import CoreGraphics
import CoreText

public class SmilesFontsManager {
    
    public static var defaultAppFont: SmilesFonts = SmilesFonts.circular
    
    public static func registerFonts() {
        let fonts = getAvailableFontsList()
        fonts.forEach {
            registerFont(bundle: .module, fontName: $0, fontExtension: "ttf")
        }
    }
    
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
            let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
            let font = CGFont(fontDataProvider) else {
                fatalError("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
        }
        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
        
    }
    
    private static func getAvailableFontsList() -> [String] {
        
        var fonts = [String]()
        let circular: [String] = [SmilesFonts.circular.getFontName(fontStyle: .bold), SmilesFonts.circular.getFontName(fontStyle: .book), SmilesFonts.circular.getFontName(fontStyle: .light), SmilesFonts.circular.getFontName(fontStyle: .medium), SmilesFonts.circular.getFontName(fontStyle: .regular)]
        let lato: [String] = [SmilesFonts.lato.getFontName(fontStyle: .black), SmilesFonts.lato.getFontName(fontStyle: .blackItalic), SmilesFonts.lato.getFontName(fontStyle: .bold), SmilesFonts.lato.getFontName(fontStyle: .boldItalic), SmilesFonts.lato.getFontName(fontStyle: .hairLine), SmilesFonts.lato.getFontName(fontStyle: .italic), SmilesFonts.lato.getFontName(fontStyle: .light), SmilesFonts.lato.getFontName(fontStyle: .lightItalic), SmilesFonts.lato.getFontName(fontStyle: .medium), SmilesFonts.lato.getFontName(fontStyle: .regular), SmilesFonts.lato.getFontName(fontStyle: .semiBold)]
        let montserrat: [String] = [SmilesFonts.montserrat.getFontName(fontStyle: .bold), SmilesFonts.montserrat.getFontName(fontStyle: .extraBold), SmilesFonts.montserrat.getFontName(fontStyle: .medium), SmilesFonts.montserrat.getFontName(fontStyle: .regular), SmilesFonts.montserrat.getFontName(fontStyle: .semiBold)]
        fonts.append(contentsOf: circular)
        fonts.append(contentsOf: lato)
        fonts.append(contentsOf: montserrat)
        return fonts
        
    }
    
}
