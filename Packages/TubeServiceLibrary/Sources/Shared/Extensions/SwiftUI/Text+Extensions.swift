import SwiftUI

//public enum TextType: Equatable {
//    case localizedStringKey(String)
//    case verbatim(String)
//    
//    public static let empty = TextType.verbatim("")
//}

//public extension Text {
//    
//    init(_ textType: TextType,
//         bundle: Bundle? = nil) {
//        switch textType {
//        case .localizedStringKey(let key):
//            self = .init(LocalizedStringKey(key), bundle: bundle)
//        case .verbatim(let string):
//            self = .init(verbatim: string)
//        }
//    }
//}

//public extension View {

//    func navigationBarTitle(_ textType: TextType, bundle: Bundle? = nil) -> some View {
//        self.navigationBarTitle(Text(textType, bundle: bundle))
//    }
//}
