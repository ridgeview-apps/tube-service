import DataStores
import Models
import SwiftUI

enum NotificationsFlowEntry: Hashable {
    case fullOnboarding(preselectedLine: TrainLineID?)
    case manage
}

@MainActor
struct NotificationsFlow: View {

    let entry: NotificationsFlowEntry

    @Environment(\.dismiss) var dismiss
    @Environment(NotificationsDataStore.self) var notifications

    @State private var path: [NotificationsOnboardingContent.Step] = []

    var body: some View {
        NavigationStack(path: $path) {
            content
                .withCloseToolbarButton()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch entry {
        case .fullOnboarding(let preselectedLine):
            NotificationsOnboardingContent(
                preselectedLine: preselectedLine,
                onDismiss: { dismiss() },
                onNavigate: { step in path.append(step) },
                onReplaceStack: { steps in path = steps }
            )
        case .manage:
            if let prefs = notifications.preferences {
                ManageNotificationsScreen(preferences: prefs)
            }
        }
    }
}


// MARK: - Previews

#if DEBUG
    #Preview("Full onboarding") {
        PreviewEnvironment {
            NotificationsFlow(entry: .fullOnboarding(preselectedLine: .victoria))
        }
    }

    #Preview("Manage") {
        PreviewEnvironment {
            NotificationsFlow(entry: .manage)
        }
    }
#endif
