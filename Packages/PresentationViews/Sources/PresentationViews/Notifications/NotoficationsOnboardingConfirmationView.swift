import Models
import SwiftUI

public struct NotificationsOnboardingConfirmationView: View {

    public let lineSettings: [LineNotificationSettings]
    public let onDone: () -> Void

    public init(
        lineSettings: [LineNotificationSettings],
        onDone: @escaping () -> Void
    ) {
        self.lineSettings = lineSettings
        self.onDone = onDone
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.15))
                            .frame(width: 88, height: 88)

                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.green)
                    }

                    VStack(spacing: 8) {
                        Text(.notificationsConfirmationTitle)
                            .font(.title2.weight(.bold))
                            .multilineTextAlignment(.center)

                        Text(.notificationsConfirmationDescription)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }

                selectedLinesCard
            }
            .padding(20)
        }
        .navigationTitle(Text(.notificationsConfirmationNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: .globalDone)) {
                    onDone()
                }
            }
        }
    }

    private var selectedLinesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(lineSettings.sorted(by: { $0.lineID.name < $1.lineID.name }), id: \.lineID) { settings in
                HStack(spacing: 10) {
                    Circle()
                        .fill(settings.lineID.backgroundColor)
                        .frame(width: 12, height: 12)
                    Text(settings.lineID.name)
                        .font(.subheadline)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        NavigationStack {
            NotificationsOnboardingConfirmationView(
                lineSettings: [
                    .defaultValue(lineID: .victoria),
                    .defaultValue(lineID: .jubilee),
                    .defaultValue(lineID: .central)
                ],
                onDone: {}
            )
        }
    }
#endif
