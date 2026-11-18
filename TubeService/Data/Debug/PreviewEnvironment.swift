import SwiftUI

#if DEBUG

    @MainActor
    struct PreviewEnvironment<Content: View>: View {
        private let content: Content
        private let withNavigationHost: Bool
        @State private var appData: AppDataStore
        @State private var appNavigator: AppNavigator

        /// - Parameter withNavigationHost: Shows `content` in a host, for screens that push or present.
        init(
            dependencies: AppDependencies = .stub,
            withNavigationHost: Bool = false,
            @ViewBuilder content: () -> Content
        ) {
            AppDependencies.setPreviewOverride(dependencies)
            let appData = AppDataStore(dependencies: dependencies)
            _appData = State(initialValue: appData)
            _appNavigator = State(initialValue: AppNavigator(purchases: appData.purchases))
            self.withNavigationHost = withNavigationHost
            self.content = content()
        }

        var body: some View {
            Group {
                if withNavigationHost {
                    NavigationHost(navigator: appNavigator.selectedTabNavigator) {
                        content
                    }
                } else {
                    content
                }
            }
            .appEnvironment(dataStore: appData, appNavigator: appNavigator)
        }
    }

#endif
