import Combine
import ComposableArchitecture
import SwiftUI

extension ViewStore {
  func send(
    _ action: Action,
    while predicate: @escaping (State) -> Bool
  ) async {
    self.send(action)
    await withUnsafeContinuation { (continuation: UnsafeContinuation<Void, Never>) in
      var cancellable: Cancellable?
      cancellable = self.publisher
        .filter { !predicate($0) }
        .prefix(1)
        .sink { _ in
          continuation.resume()
          _ = cancellable
        }
    }
  }
}
