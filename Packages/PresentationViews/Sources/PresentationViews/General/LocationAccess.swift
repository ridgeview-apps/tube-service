import SwiftUI

public struct LocationAccess {
    public enum State: Hashable {
        case notAsked
        case denied
        case allowed(LoadingState)
    }

    public let state: State
    public let onRequestPermissions: () -> Void

    public init(
        state: State,
        onRequestPermissions: @escaping () -> Void
    ) {
        self.state = state
        self.onRequestPermissions = onRequestPermissions
    }

    /// False when a prompt or error stands in for the nearby results.
    var showsResults: Bool {
        switch state {
        case .allowed(.loaded), .allowed(.loading):
            true
        case .notAsked, .denied, .allowed(.failure):
            false
        }
    }

    var loadingState: LoadingState? {
        if case let .allowed(loadingState) = state {
            loadingState
        } else {
            nil
        }
    }
}
