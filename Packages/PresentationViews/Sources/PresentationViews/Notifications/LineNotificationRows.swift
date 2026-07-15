import Models
import SwiftUI

struct LineNotificationRows: View {
    let settings: [LineNotificationSettings]
    var onSelect: ((TrainLineID) -> Void)? = nil

    @Environment(\.lineSelectionZoomNamespace) private var zoomNamespace

    var body: some View {
        VStack(spacing: 0) {
            ForEach(
                Array(settings.sorted { $0.lineID.name < $1.lineID.name }.enumerated()),
                id: \.element.lineID
            ) { index, lineSettings in
                if index > 0 {
                    Divider()
                        .padding(.leading, 40)
                }
                rowView(for: lineSettings)
            }
        }
    }

    @ViewBuilder
    private func rowView(for lineSettings: LineNotificationSettings) -> some View {
        if let onSelect {
            Button {
                onSelect(lineSettings.lineID)
            } label: {
                rowContent(lineSettings, showChevron: true)
            }
            .buttonStyle(.plain)
            .matchedTransitionSourceIfPresent(id: lineSettings.lineID, in: zoomNamespace)
        } else {
            rowContent(lineSettings, showChevron: false)
        }
    }

    private func rowContent(_ lineSettings: LineNotificationSettings, showChevron: Bool) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(lineSettings.lineID.backgroundColor)
                .frame(width: 12, height: 12)
            Text(lineSettings.lineID.name)
                .foregroundStyle(.primary)
            Spacer()
            Text(lineSettings.schedulePreset.title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if showChevron {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
                    .font(.caption.weight(.semibold))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }
}
