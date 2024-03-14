import SwiftUI

extension View {

    public func onChange<Value>(
        of value: Value,
        debounceTime: Duration,
        perform action: @escaping (_ newValue: Value) -> Void
    ) -> some View where Value: Equatable {
        self.modifier(DebouncedChangeViewModifier(trigger: value, action: action) {
            try await Task.sleep(for: debounceTime)
        })
    }
}

private struct DebouncedChangeViewModifier<Value>: ViewModifier where Value: Equatable {
    let trigger: Value
    let action: (Value) -> Void
    let sleep: @Sendable () async throws -> Void

    @State private var debouncedTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content.onChange(of: trigger) { value in
            debouncedTask?.cancel()
            debouncedTask = Task {
                do { try await sleep() } catch { return }
                action(value)
            }
        }
    }
}
