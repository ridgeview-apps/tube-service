import Models
import SwiftUI

@MainActor
struct NotificationsOnboardingFlow: View {

    let preselectedLine: TrainLineID?

    @Environment(\.dismiss) var dismiss

    @State private var path: [NotificationsOnboardingContent.Step] = []

    init(preselectedLine: TrainLineID? = nil) {
        self.preselectedLine = preselectedLine
    }

    var body: some View {
        NavigationStack(path: $path) {
            NotificationsOnboardingContent(
                preselectedLine: preselectedLine,
                onDismiss: { dismiss() },
                onNavigate: { step in path.append(step) },
                onReplaceStack: { steps in path = steps }
            )
            .withCloseToolbarButton()
        }
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            NotificationsOnboardingFlow(preselectedLine: .victoria)
        }
    }
#endif
