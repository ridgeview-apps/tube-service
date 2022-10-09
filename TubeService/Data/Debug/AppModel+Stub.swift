import Foundation

#if DEBUG
extension AppModel {
    static func stub() -> AppModel {
        .init(dataClients: .stub)
    }

}
#endif
