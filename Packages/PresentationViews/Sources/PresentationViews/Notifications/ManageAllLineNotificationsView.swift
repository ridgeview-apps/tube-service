import Models
import SwiftUI

public struct ManageAllLineNotificationsView: View {

    public enum Action {
        case cancel
        case tappedOtherLine(TrainLineID)
        case addedLine(TrainLineID)
        case openSettings
        case deleteAllSettings
    }

    private let allSettings: [LineNotificationSettings]
    private let showsPermissionWarning: Bool
    private let savingState: LoadingState
    private let onAction: (Action) -> Void

    @State private var showDeleteAllConfirmation = false
    @State private var removeFeedbackTrigger = false

    public init(
        allSettings: [LineNotificationSettings] = [],
        showsPermissionWarning: Bool = false,
        savingState: LoadingState = .loaded,
        onAction: @escaping (Action) -> Void
    ) {
        self.allSettings = allSettings
        self.showsPermissionWarning = showsPermissionWarning
        self.savingState = savingState
        self.onAction = onAction
    }

    // MARK: - Computed Properties

    private var unconfiguredLineIDs: [TrainLineID] {
        let configuredIDs = Set(allSettings.map(\.lineID))
        return TrainLineID.allCases
            .filter { !configuredIDs.contains($0) }
            .sorted { $0.name < $1.name }
    }

    // MARK: - Body

    public var body: some View {
        List {
            if showsPermissionWarning {
                permissionWarningRow
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 12, leading: 20, bottom: 6, trailing: 20))
            }

            if savingState != .loaded {
                LoadingStatusView(loadingState: savingState)
                    .defaultLoadingStatusStyle()
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 20))
            }

            if !allSettings.isEmpty || !unconfiguredLineIDs.isEmpty {
                allLinesCard
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
            }

            deleteAllSettingsButton
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .navigationTitle(String(localized: .notificationsLineAlertsNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(.warning, trigger: removeFeedbackTrigger)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { cancelButton }
        }
    }

    // MARK: - Permission Warning

    private var permissionWarningRow: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.orange)

                VStack(alignment: .leading, spacing: 4) {
                    Text(.notificationsManagePermissionWarningTitle)
                        .font(.subheadline.weight(.semibold))
                    Text(.notificationsManagePermissionWarningSubtitle)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            Button {
                onAction(.openSettings)
            } label: {
                Text(.notificationsManageOpenSettingsButton)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .controlSize(.regular)
        }
        .padding(16)
        .cardStyle()
    }

    // MARK: - All Lines Card

    private var allLinesCard: some View {
        VStack(spacing: 0) {
            LineNotificationSettingsSummary(
                settings: allSettings,
                onSelect: { onAction(.tappedOtherLine($0)) }
            )
            if !unconfiguredLineIDs.isEmpty {
                if !allSettings.isEmpty {
                    Divider()
                        .padding(.leading, 40)
                }
                addLineMenu
            }
        }
        .cardStyle()
    }

    // MARK: - Delete All Button

    private var deleteAllSettingsButton: some View {
        Button {
            showDeleteAllConfirmation = true
        } label: {
            Label {
                Text(.notificationsManageDeleteAllSettingsButton)
            } icon: {
                Image(systemName: "trash.fill")
            }
            .ctaLabelStyle()
        }
        .buttonStyle(.primary(tint: .red))
        .confirmationDialog(
            Text(.notificationsManageDeleteAllSettingsConfirmationTitle),
            isPresented: $showDeleteAllConfirmation,
            titleVisibility: .visible
        ) {
            Button(String(localized: .notificationsManageDeleteAllSettingsButton), role: .destructive) {
                removeFeedbackTrigger.toggle()
                onAction(.deleteAllSettings)
            }
        } message: {
            Text(.notificationsManageDeleteAllSettingsConfirmationMessage)
        }
    }

    // MARK: - Add Line Menu

    private var addLineMenu: some View {
        AddLineMenu(
            lineIDs: unconfiguredLineIDs,
            label: .notificationsManageAddLineButton,
            onSelect: { onAction(.addedLine($0)) }
        )
    }

    // MARK: - Toolbar

    private var cancelButton: some View {
        Button {
            onAction(.cancel)
        } label: {
            Image(systemName: "xmark")
        }
    }
}

// MARK: - Previews

#if DEBUG
    import ModelStubs

    #Preview("Manage all") {
        NavigationStack {
            ManageAllLineNotificationsView(
                allSettings: [.victoria, .jubilee, .central, .northern].map { .defaultValue(lineID: $0) },
                onAction: { print($0) }
            )
        }
    }
#endif
