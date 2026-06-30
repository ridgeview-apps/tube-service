import SwiftUI

public enum NavigationButton {

    public struct Settings: View {
        let action: () -> Void

        public init(action: @escaping () -> Void) {
            self.action = action
        }

        public var body: some View {
            Button(action: action) {
                Image(systemName: "gearshape")
            }
        }
    }

    public struct Close: View {
        let action: () -> Void

        public init(action: @escaping () -> Void) {
            self.action = action
        }

        public var body: some View {
            Button(action: action) {
                Image(systemName: "xmark")
            }
        }
    }

}
