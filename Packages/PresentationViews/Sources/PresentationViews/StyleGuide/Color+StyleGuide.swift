import SwiftUI
import RidgeviewCore

// MARK: - Train lines
public extension Color {
    
    static let bakerlooLine = Color.rgb(137, 78, 36)
    static let centralLine = Color.rgb(220, 36, 31)
    static let circleLine = Color.rgb(255, 206, 0)
    static let districtLine = Color.rgb(0, 114, 41)
    static let elizabethLine = Color.rgb(105, 80, 161)
    static let hammersmithAndCityLine = Color.rgb(215, 173, 175)
    static let jubileeLine = Color.rgb(143, 134, 152)
    static let metropolitanLine = Color.rgb(117, 16, 86)
    static let northernLine = Color.rgb(0, 0, 0)
    static let piccadillyLine = Color.rgb(0, 25, 168)
    static let victoriaLine = Color.rgb(0, 160, 226)
    static let waterlooAndCityLine = Color.rgb(118, 208, 189)
    static let dlr = Color.rgb(0, 175, 173)
    static let tram = Color.rgb(0, 189, 25)
    static let overground = Color.rgb(239, 123, 16)
}


// MARK: - Color
public extension Color {
    static let lightGrey1 = Color.rgb(251, 251, 251)
    static let lightGrey2 = Color.rgb(242, 242, 242)
    
    static let midGrey1 = Color.rgb(147, 147, 147)
    static let midGrey2 = Color.rgb(108, 108, 108)
    
    static let darkGrey1 = Color.rgb(62, 62, 62)
    static let darkGrey2 = Color.rgb(34, 30, 40)
    
    static let darkRed1 = Color.rgb(235, 77, 61)
    static let midRed1 = Color.rgb(255, 145, 145)
    
    static let adaptiveRed = Color.adaptive(lightMode: .darkRed1,
                                            darkMode: .midRed1)
    
    static let adaptiveMidGrey2 = Color.adaptive(lightMode: .midGrey2,
                                                 darkMode: .lightGrey1)
    
    static let defaultBackground = Color.adaptive(lightMode: .lightGrey2,
                                                  darkMode: .darkGrey2)
    
    static let defaultCellBackground = Color.adaptive(lightMode: .lightGrey1,
                                                      darkMode: .darkGrey1)
}

public extension Color {
    
    static func adaptive(lightMode: Color, darkMode: Color) -> Color {
        let uiColor = UIColor(lightMode: .init(lightMode),
                              darkMode: .init(darkMode))
        return Color(uiColor: uiColor)
    }
}

extension UIColor {
    
    convenience init(lightMode: UIColor,
                     darkMode: UIColor) {
        
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return lightMode
            case .dark:
                return darkMode
            @unknown default:
                return lightMode
            }
        }
    }
}
