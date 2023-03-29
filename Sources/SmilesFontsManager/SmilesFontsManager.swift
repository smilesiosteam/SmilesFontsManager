
import Foundation
import CoreGraphics
import CoreText

public class SmilesFontsManager {
    
    public static func registerFonts() {
        let fonts = getAvailableFontsList()
        fonts.forEach {
            registerFont(bundle: .module, fontName: $0.rawValued(), fontExtension: "ttf")
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
    
    private static func getAvailableFontsList() -> [SmilesFonts] {
        
        var fonts = [SmilesFonts]()
        let circular: [SmilesFonts] = [.circular(.bold), .circular(.book), .circular(.light), .circular(.medium), .circular(.regular)]
        let lato: [SmilesFonts] = [.lato(.black), .lato(.blackItalic), .lato(.bold), .lato(.boldItalic), .lato(.hairLine), .lato(.italic), .lato(.light), .lato(.lightItalic), .lato(.medium), .lato(.regular), .lato(.semiBold)]
        let montserrat: [SmilesFonts] = [.montserrat(.bold), .montserrat(.extraBold), .montserrat(.medium), .montserrat(.regular), .montserrat(.semiBold)]
        fonts.append(contentsOf: circular)
        fonts.append(contentsOf: lato)
        fonts.append(contentsOf: montserrat)
        return fonts
        
    }
    
}
