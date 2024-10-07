import Models
import DataStores
import PresentationViews
import SwiftUI

struct SystemStatusRefreshableModifier: ViewModifier {
    
    @AppStorage(UserDefaults.Keys.userPreferences.rawValue, store: .standard)
    private var userPreferences: UserPreferences = .default
    
    @Environment(SystemStatusDataStore.self) var systemStatus: SystemStatusDataStore
    @Environment(\.showSheet) var showSheet
    @State private var showBanner = false
    
    func body(content: Content) -> some View {
        content
            .onSceneDidBecomeActive {
                showSystemStatusBannerIfNeeded()
            }
            .overlay(alignment: .top) {
                if showBanner, let currentStatus = systemStatus.currentStatus {
                    SystemStatusBannerView(
                        systemStatus: currentStatus,
                        isShowing: $showBanner,
                        onAction: handleBannerAction
                    )
                }
            }
    }
    
    private func showSystemStatusBannerIfNeeded() {
        Task {
            await systemStatus.fetchSystemStatusIfStale()
            
            guard let currentStatus = systemStatus.currentStatus, currentStatus.status != .ok else {
                return
            }
            
            let newMessageAvailable = !userPreferences.hasReadSystemStatusMessage(id: currentStatus.id)
            if newMessageAvailable {
                try await Task.sleep(for: .seconds(1.2)) // N.B. Suspends the task without blocking the thread
                withAnimation { showBanner = true }
            }
        }
    }

    private func handleBannerAction(_ action: SystemStatusBannerView.Action) {
        switch action {
        case let .tappedOK(message):
            dismissBanner(message)
        case let .tappedMoreInfo(message):
            dismissBanner(message, moreInfo: true)
        }
    }
    
    private func dismissBanner(_ message: SystemStatus, moreInfo: Bool = false) {
        showBanner = false
        userPreferences.markAsRead(systemStatusMessageID: message.id)
        if moreInfo {
            showSheet(.systemStatusDetail(message))
        }
    }
}

extension View {
    
    func systemStatusRefreshable() -> some View {
        modifier(SystemStatusRefreshableModifier())
    }
}
