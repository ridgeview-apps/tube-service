import SwiftUI

#if DEBUG

    @MainActor
    struct PreviewEnvironment<Content: View>: View {
        private let content: Content
        @State private var appData: AppDataStore
        @State private var router = AppRouter()

        init(
            dependencies: AppDependencies = .stub,
            @ViewBuilder content: () -> Content
        ) {
            AppDependencies.setPreviewOverride(dependencies)
            _appData = State(initialValue: AppDataStore(dependencies: dependencies))
            self.content = content()
        }

        var body: some View {
            content
                .withAppEnvironment(dataStore: appData, router: router)
        }
    }

#endif
