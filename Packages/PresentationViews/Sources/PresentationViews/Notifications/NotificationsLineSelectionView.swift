import Models
import SwiftUI

public struct NotificationsLineSelectionView: View {

    public enum Mode {
        case onboarding(initialSelection: Set<TrainLineID>)
        case manage(settings: [TrainLineID: LineNotificationSettings])
    }

    public enum Action {
        case `continue`(Set<TrainLineID>)
        case lineSelected(TrainLineID)
    }

    private let mode: Mode
    public let onAction: (Action) -> Void

    @State private var selectedLineIDs: Set<TrainLineID>
    private let allLineIDs = TrainLineID.allCases.sorted(by: { $0.name < $1.name })

    public init(mode: Mode, onAction: @escaping (Action) -> Void) {
        self.mode = mode
        self.onAction = onAction
        if case .onboarding(let initialSelection) = mode {
            _selectedLineIDs = State(initialValue: initialSelection)
        } else {
            _selectedLineIDs = State(initialValue: [])
        }
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if case .onboarding = mode {
                    Text(.notificationsLineSelectionSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 20)
                }

                lineList
                    .padding(.horizontal, 20)
            }
            .padding(.top, 12)
            .padding(.bottom, 20)
        }
        .safeAreaInset(edge: .bottom) {
            if case .onboarding = mode {
                Button {
                    onAction(.continue(selectedLineIDs))
                } label: {
                    Text(.globalContinue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 20)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(selectedLineIDs.isEmpty)
                .padding(20)
                .background(.bar)
            }
        }
        .navigationTitle(Text(.notificationsLineSelectionNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var lineList: some View {
        VStack(spacing: 0) {
            ForEach(allLineIDs.indices, id: \.self) { index in
                lineRow(allLineIDs[index])
                if index < allLineIDs.count - 1 {
                    Divider()
                        .padding(.leading, 6)
                }
            }
        }
        .cardStyle()
    }

    @ViewBuilder
    private func lineRow(_ lineID: TrainLineID) -> some View {
        Button {
            switch mode {
            case .onboarding:
                if selectedLineIDs.contains(lineID) {
                    selectedLineIDs.remove(lineID)
                } else {
                    selectedLineIDs.insert(lineID)
                }
            case .manage:
                onAction(.lineSelected(lineID))
            }
        } label: {
            HStack {
                Text(lineID.name)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Spacer(minLength: 8)
                trailingContent(for: lineID)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(alignment: .leading) {
            lineID.backgroundColor.frame(width: 6)
        }
    }

    @ViewBuilder
    private func trailingContent(for lineID: TrainLineID) -> some View {
        switch mode {
        case .onboarding:
            Image(
                systemName: selectedLineIDs.contains(lineID)
                    ? "checkmark.circle.fill"
                    : "circle"
            )
            .font(.system(size: 20, weight: .regular))
            .foregroundStyle(
                selectedLineIDs.contains(lineID)
                    ? lineID.backgroundColor
                    : Color(.tertiaryLabel)
            )
        case .manage(let settings):
            Text(statusLabel(for: lineID, settings: settings))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func statusLabel(
        for lineID: TrainLineID,
        settings: [TrainLineID: LineNotificationSettings]
    ) -> LocalizedStringResource {
        guard let lineSettings = settings[lineID] else {
            return L10n.notificationsLineStatusNotSetUp
        }
        return lineSettings.isEnabled
            ? L10n.notificationsLineStatusAlertsOn
            : L10n.notificationsLineStatusAlertsOff
    }
}


// MARK: - Previews

#if DEBUG
    #Preview("Onboarding") {
        NavigationStack {
            NotificationsLineSelectionView(
                mode: .onboarding(initialSelection: [.victoria, .jubilee]),
                onAction: { _ in }
            )
        }
    }

    #Preview("Manage") {
        NavigationStack {
            NotificationsLineSelectionView(
                mode: .manage(settings: [
                    .victoria: LineNotificationSettings(isEnabled: true),
                    .jubilee: LineNotificationSettings(isEnabled: false),
                    .central: LineNotificationSettings()
                ]),
                onAction: { _ in }
            )
        }
    }
#endif
