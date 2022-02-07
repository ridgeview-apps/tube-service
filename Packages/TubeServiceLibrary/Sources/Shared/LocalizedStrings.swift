//import Foundation
//
//public struct LocalizedStrings {
//    public let valueForKey: (String) -> String
//    
//    public init(
//        valueForKey: @escaping (String) -> String
//    ) {
//        self.valueForKey = valueForKey
//    }
//    
//    public subscript(key: String) -> String {
//        valueForKey(key)
//    }
//
//}
//
//public extension LocalizedStrings {
//    
//    static func nsLocalized(in bundle: Bundle) -> LocalizedStrings {
//        .init { key in
//            NSLocalizedString(key, bundle: bundle, comment: "")
//        }
//    }
//}
//
//#if DEBUG
//public extension LocalizedStrings {
//    
//    static let fake = LocalizedStrings { $0 }
//}
//#endif
