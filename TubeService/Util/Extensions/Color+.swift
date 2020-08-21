import SwiftUI

extension Color {
    static let boardText = Color.rgb(198, 188, 61)
    
    static func rgb(_ red: Double, _ green: Double, _ blue: Double) -> Color {
        Color(red: red / 255.0,
              green: green / 255.0,
              blue: blue / 255.0)
    }
}
