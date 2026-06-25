import Models
import SwiftUI

public struct NotificationsOnboardingScheduleView: View {

    public let onDone: ([TrainLineID: NotificationSchedulePreset]) -> Void

    @State private var presets: [TrainLineID: NotificationSchedulePreset]

    private let sortedLineIDs: [TrainLineID]

    public init(
        initialPresets: [TrainLineID: NotificationSchedulePreset],
        onDone: @escaping ([TrainLineID: NotificationSchedulePreset]) -> Void
    ) {
        self.onDone = onDone
        _presets = State(initialValue: initialPresets)
        sortedLineIDs = initialPresets.keys.sorted(by: { $0.name < $1.name })
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(sortedLineIDs, id: \.rawValue) { lineID in
                    lineScheduleCard(for: lineID)
                }
            }
            .padding(20)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                onDone(presets)
            } label: {
                Text(.globalDone)
                    .frame(maxWidth: .infinity)
                    .frame(height: 20)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(20)
            .background(.bar)
        }
        .navigationTitle(Text(.notificationsScheduleNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
    }

    private func preset(for lineID: TrainLineID) -> NotificationSchedulePreset {
        presets[lineID] ?? .weekdayPeak
    }

    private func lineScheduleCard(for lineID: TrainLineID) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(lineID.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)

            Divider()

            HStack {
                Text(L10n.notificationsConfirmationScheduleLabel)
                    .foregroundStyle(.secondary)
                Spacer(minLength: 8)
                Menu {
                    Picker(L10n.notificationsConfirmationScheduleLabel, selection: presetBinding(for: lineID)) {
                        ForEach(NotificationSchedulePreset.allDisplayCases, id: \.self) { p in
                            Text(p.title).tag(p)
                        }
                    }
                    .labelsHidden()
                } label: {
                    HStack(spacing: 4) {
                        Text(preset(for: lineID).title)
                            .multilineTextAlignment(.trailing)
                        Image(systemName: "chevron.up.chevron.down")
                            .imageScale(.small)
                    }
                    .foregroundStyle(.tint)
                }
                .menuOrder(.fixed)
                .buttonStyle(.plain)
            }
            .font(.subheadline)
            .padding(.vertical, 10)

            Text(preset(for: lineID).description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 2)
        }
        .padding(16)
        .background(alignment: .leading) {
            lineID.backgroundColor.frame(width: 6)
        }
        .cardStyle()
    }

    private func presetBinding(for lineID: TrainLineID) -> Binding<NotificationSchedulePreset> {
        Binding(
            get: { preset(for: lineID) },
            set: { presets[lineID] = $0 }
        )
    }
}

// MARK: - Previews

#if DEBUG
    #Preview {
        NavigationStack {
            NotificationsOnboardingScheduleView(
                initialPresets: [
                    .victoria: .weekdayPeak,
                    .jubilee: .anytime,
                    .central: .weekends
                ],
                onDone: { _ in }
            )
        }
    }
#endif
