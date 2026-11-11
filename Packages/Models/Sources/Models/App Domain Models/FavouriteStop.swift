import Foundation

/// A stop the user has favourited. Bus stops will become another case.
public enum FavouriteStop: Hashable, Codable, Sendable {
    case station(id: Station.ID)
}
