import SwiftUI
import RidgeviewCore

// MARK: - Train lines
public extension Color {
    
    //
    // See: https://content.tfl.gov.uk/tfl-colour-standard.pdf
    // Issue 10 - May 2025
    //
    static let bakerlooLine = Color.rgb(178, 99, 0)
    static let centralLine = Color.rgb(220, 36, 31)
    static let circleLine = Color.rgb(255, 200, 10)
    static let districtLine = Color.rgb(0, 125, 50)
    static let elizabethLine = Color.rgb(96, 57, 158)
    static let hammersmithAndCityLine = Color.rgb(245, 137, 166)
    static let jubileeLine = Color.rgb(131, 141, 147)
    static let libertyLine = Color.rgb(93, 96, 97)
    static let lionessLine = Color.rgb(250, 166, 26)
    static let metropolitanLine = Color.rgb(155, 0, 88)
    static let mildmayLine = Color.rgb(0, 119, 173)
    static let northernLine = Color.rgb(0, 0, 0)
    static let piccadillyLine = Color.rgb(0, 25, 168)
    static let suffragetteLine = Color.rgb(91, 189, 114)
    static let victoriaLine = Color.rgb(3, 155, 229)
    static let waterlooAndCityLine = Color.rgb(118, 208, 189)
    static let dlr = Color.rgb(0, 175, 173)
    static let tram = Color.rgb(95, 181, 38)
    static let weaverLine = Color.rgb(130, 58, 98)
    static let windrushLine = Color.rgb(237, 27, 0)
    static let overground = Color.rgb(250, 123, 5)
    
    // As per "Colour standards": https://tfl.gov.uk/info-for/suppliers-and-contractors/design-standards

    static let bus = Color.adaptive(lightMode: rgb(220, 36, 31),
                                    darkMode: Color.midRed1)
    static let cableCar = Color.rgb(115, 79, 160)
    static let cycleHire = Color.rgb(236, 0, 0)
    static let coach = Color.rgb(255, 166, 0)
    static let nationalRail = Color.rgb(230, 0, 0)
    static let riverBus = Color.rgb(3, 159, 229)
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
    
    static let adaptiveDarkGrey1 = Color.adaptive(lightMode: .darkGrey1,
                                                 darkMode: .lightGrey2)
    
    static let defaultBackground = Color.adaptive(lightMode: .lightGrey2,
                                                  darkMode: .darkGrey2)
    
    static let defaultCellBackground = Color.adaptive(lightMode: .lightGrey1,
                                                      darkMode: .darkGrey1)
    
    static let systemBannerOK = Color.rgb(55, 122, 0)
    static let systemBannerOutage = Color.darkRed1
}

public extension Color {
    
    static func adaptive(lightMode: Color, darkMode: Color) -> Color {
        let uiColor = UIColor(lightMode: .init(lightMode),
                              darkMode: .init(darkMode))
        return Color(uiColor: uiColor)
    }
}

public extension ShapeStyle where Self == Color {
    
    static var bakerlooLine: Color { .bakerlooLine }
    static var centralLine: Color { .centralLine }
    static var circleLine: Color { .circleLine }
    static var districtLine: Color { .districtLine }
    static var elizabethLine: Color { .elizabethLine }
    static var hammersmithAndCityLine: Color { .hammersmithAndCityLine }
    static var jubileeLine: Color { .jubileeLine }
    static var metropolitanLine: Color { .metropolitanLine }
    static var northernLine: Color { .northernLine }
    static var piccadillyLine: Color { .piccadillyLine }
    static var victoriaLine: Color { .victoriaLine }
    static var waterlooAndCityLine: Color { .waterlooAndCityLine }
    static var dlr: Color { .dlr }
    static var tram: Color { .tram }
    static var overground: Color { .overground }
    
    static var bus: Color { .bus }
    static var cableCar: Color { .cableCar }
    static var cycleHire: Color { .cycleHire }
    static var coach: Color { .coach }
    static var nationalRail: Color { .nationalRail }
    static var riverBus: Color { .riverBus }
    
    static var lightGrey1: Color { .lightGrey1 }
    static var lightGrey2: Color { .lightGrey2 }
    
    static var midGrey1: Color { .midGrey1 }
    static var midGrey2: Color { .midGrey2 }
    
    static var darkGrey1: Color { .darkGrey1 }
    static var darkGrey2: Color { .darkGrey2 }
    
    static var darkRed1: Color { .darkRed1 }
    static var midRed1: Color { .midRed1 }
    
    static var adaptiveRed: Color { .adaptiveRed }
    
    static var adaptiveMidGrey2: Color { .adaptiveMidGrey2 }
    
    static var adaptiveDarkGrey1: Color { .adaptiveDarkGrey1 }
    
    static var defaultBackground: Color { .defaultBackground }
    
    static var defaultCellBackground: Color { .defaultCellBackground }
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
