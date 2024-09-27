import Models
import DataStores
import PresentationViews
import SwiftUI

struct SystemStatusRefreshableModifier: ViewModifier {
    
    @AppStorage(UserDefaults.Keys.userPreferences.rawValue, store: .standard)
    private var userPreferences: UserPreferences = .default
    
    @Environment(SystemStatusDataStore.self) var systemStatus: SystemStatusDataStore    
    @State private var showBanner = false
    @State private var showMoreInfo = false
    
    func body(content: Content) -> some View {
        content
            .onSceneDidBecomeActive {
                Task {
                    await systemStatus.fetchSystemStatusIfStale()
                }
            }
            .onChange(of: systemStatus.currentStatus) {
                if let currentStatus = systemStatus.currentStatus, !userPreferences.hasReadSystemStatusMessage(id: currentStatus.id) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation { showBanner = true }
                    }
                }
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
            .sheet(isPresented: $showMoreInfo) {
                moreInfoSheet
            }
    }
    
    private func handleBannerAction(_ action: SystemStatusBannerView.Action) {
        switch action {
        case let .tappedOK(messageID):
            dismissBanner(messageID)
        case let .tappedMoreInfo(messageID):
            dismissBanner(messageID, moreInfo: true)
        }
    }
    
    private func dismissBanner(_ messageID: SystemStatus.ID, moreInfo: Bool = false) {
        showBanner = false
        showMoreInfo = moreInfo
        userPreferences.markAsRead(systemStatusMessageID: messageID)
    }
    
    @ViewBuilder
    private var moreInfoSheet: some View {
        if let currentStatus = systemStatus.currentStatus {
            NavigationStack {
                SystemStatusDetailView(systemStatus: currentStatus)
                    .toolbar {
                        NavigationButton.Close { showMoreInfo = false }
                    }
            }
        }
    }
}

extension View {
    
    func systemStatusRefreshable() -> some View {
        modifier(SystemStatusRefreshableModifier())
    }
}
