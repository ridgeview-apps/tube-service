import SwiftUI

public struct NotificationsOnboardingPermissionDeniedView: View {

    public enum Action: Sendable {
        case openSettings
        case notNow
    }

    public let onAction: (Action) -> Void

    public init(onAction: @escaping (Action) -> Void) {
        self.onAction = onAction
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.15))
                            .frame(width: 88, height: 88)

                        Image(systemName: "bell.slash.fill")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundStyle(.orange)
                    }

                    VStack(spacing: 8) {
                        Text(.notificationsPermissionDeniedTitle)
                            .font(.title2.weight(.bold))
                            .multilineTextAlignment(.center)

                        Text(.notificationsPermissionDeniedDescription)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }

                Button {
                    onAction(.openSettings)
                } label: {
                    Text(.openAppSettingsButtonTitle)
                        .frame(maxWidth: .infinity)
                        .frame(height: 20)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button {
                    onAction(.notNow)
                } label: {
                    Text(.globalNotNow)
                }
                .foregroundStyle(.secondary)
            }
            .padding(20)
        }
        .navigationTitle(Text(.notificationsPermissionDeniedNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        NavigationStack {
            NotificationsOnboardingPermissionDeniedView(onAction: { _ in })
        }
    }
#endif
