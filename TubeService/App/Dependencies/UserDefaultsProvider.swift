import Foundation

struct UserDefaultsProvider: @unchecked Sendable {
    let value: UserDefaults

    init(_ value: UserDefaults) {
        self.value = value
    }

}
