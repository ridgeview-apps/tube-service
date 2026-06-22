import Models
import SwiftUI

enum NotificationsFlowEntry: Hashable {
    case fullOnboarding(preselectedLine: TrainLineID?)
    case editExisting(preselectedLine: TrainLineID?, selectedLineIDs: Set<TrainLineID>, schedulePreset: NotificationSchedulePreset)
}

@MainActor
struct NotificationsFlow: View {

    let entry: NotificationsFlowEntry

    @Environment(\.dismiss) var dismiss

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
        case .editExisting(let preselectedLine, let selectedLineIDs, let schedulePreset):
            NotificationsOnboardingContent(
                preselectedLine: preselectedLine,
                isEditMode: true,
                initialSelectedLineIDs: selectedLineIDs,
                initialPreset: schedulePreset,
                onDismiss: { dismiss() },
                onNavigate: { step in path.append(step) },
                onReplaceStack: { steps in path = steps }
            )
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

    #Preview("Edit existing") {
        PreviewEnvironment {
            NotificationsFlow(
                entry: .editExisting(
                    preselectedLine: .victoria,
                    selectedLineIDs: [.victoria, .jubilee],
                    schedulePreset: .weekdayPeak
                )
            )
        }
    }
#endif
