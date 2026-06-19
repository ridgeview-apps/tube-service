import Models
import PresentationViews
import SwiftUI

@MainActor
struct NotificationsScheduleScreen: View {

    @Binding var selectedPreset: NotificationSchedulePreset
    let onContinue: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(presets, id: \.preset) { item in
                    scheduleCard(item)
                }
            }
            .padding(20)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                onContinue()
            } label: {
                Text(L10n.globalContinue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 20)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(20)
            .background(.bar)
        }
        .navigationTitle(Text(L10n.notificationsScheduleNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
    }

    private struct PresetItem: Identifiable {
        let preset: NotificationSchedulePreset
        let title: LocalizedStringResource
        let description: LocalizedStringResource
        let systemImage: String

        var id: NotificationSchedulePreset { preset }
    }

    private let presets: [PresetItem] = [
        .init(
            preset: .weekdayPeak,
            title: L10n.notificationsScheduleWeekdayPeakTitle,
            description: L10n.notificationsScheduleWeekdayPeakDescription,
            systemImage: "person.2.wave.2"
        ),
        .init(
            preset: .weekdayAllDay,
            title: L10n.notificationsScheduleWeekdayAllDayTitle,
            description: L10n.notificationsScheduleWeekdayAllDayDescription,
            systemImage: "sun.max"
        ),
        .init(
            preset: .weekends,
            title: L10n.notificationsScheduleWeekendsTitle,
            description: L10n.notificationsScheduleWeekendsDescription,
            systemImage: "calendar"
        ),
        .init(
            preset: .anytime,
            title: L10n.notificationsScheduleAnytimeTitle,
            description: L10n.notificationsScheduleAnytimeDescription,
            systemImage: "bell.fill"
        ),
    ]

    private func scheduleCard(_ item: PresetItem) -> some View {
        let isSelected = selectedPreset == item.preset
        return Button {
            selectedPreset = item.preset
        } label: {
            HStack(spacing: 12) {
                Image(systemName: item.systemImage)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 36)

                VStack(alignment: .leading, spacing: 3) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 8)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
            }
            .padding(16)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .cardStyle()
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            NavigationStack {
                NotificationsScheduleScreen(
                    selectedPreset: .constant(.weekdayPeak),
                    onContinue: {}
                )
            }
        }
    }
#endif
