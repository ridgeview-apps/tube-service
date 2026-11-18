import Models
import Shared
import SwiftUI

/// A quiet line under the chips giving the selected line group's status.
struct StationLineStatusRow: View {
    enum Status: Equatable {
        case disruption(String)
        case goodService(String)
        case loading
        case unavailable

        /// - Parameter lines: The selected line group's lines, empty if their statuses couldn't be loaded.
        init(lines: [Line], isLoading: Bool) {
            if let title = lines.disruptionSummary {
                self = .disruption(title)
            } else if let title = lines.goodServiceSummary {
                self = .goodService(title)
            } else if isLoading {
                self = .loading
            } else {
                self = .unavailable
            }
        }

        var isDisruption: Bool {
            if case .disruption = self { true } else { false }
        }
    }

    let status: Status
    /// Makes the row a button with a chevron; nil for a row that only reads out the status.
    var onTap: (() -> Void)?

    var body: some View {
        switch status {
        case .disruption(let title):
            statusRow(.disruption, title: title)
        case .goodService(let title):
            statusRow(.goodService, title: title)
        case .loading:
            // Holds the row's space so the boards don't move down once the statuses arrive. The text is hidden, so
            // any line's name will do.
            let placeholderTitle = String(localized: .lineGoodServiceSummary(TrainLineID.northern.nameInSentence))
            statusRow(.goodService, title: placeholderTitle)
                .redacted(reason: .placeholder)
        case .unavailable:
            Text(.stationLineStatusUnavailable)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .compactLineLimit()
        }
    }

    @ViewBuilder
    private func statusRow(_ imageType: LineStatusAccessoryImageType, title: String) -> some View {
        if let onTap {
            Button(action: onTap) {
                statusLabel(imageType, title: title, showsChevron: true)
                    .contentShape(.rect)
            }
            .buttonStyle(.plain)
        } else {
            statusLabel(imageType, title: title, showsChevron: false)
        }
    }

    private func statusLabel(_ imageType: LineStatusAccessoryImageType, title: String, showsChevron: Bool) -> some View {
        HStack(spacing: 6) {
            imageType.image
            Text(title)
                .foregroundStyle(.primary)
            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
            Spacer(minLength: 0)
        }
        .font(.subheadline)
        .compactLineLimit()
        .accessibilityElement(children: .combine)
    }
}

private struct CompactLineLimit: ViewModifier {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    func body(content: Content) -> some View {
        content
            // A second line at accessibility sizes keeps the text readable rather than cut off after a word
            .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
            .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }
}

private extension View {
    func compactLineLimit() -> some View {
        modifier(CompactLineLimit())
    }
}

// MARK: - Previews

#Preview("Rows") {
    ScrollView {
        VStack(alignment: .leading, spacing: 12) {
            Text(verbatim: "Disrupted, tappable")
            StationLineStatusRow(status: .disruption("Minor delays on the Northern line"), onTap: {})

            Text(verbatim: "Good service")
            StationLineStatusRow(status: .goodService("Good service on the Northern line"))

            Text(verbatim: "Long title")
            StationLineStatusRow(
                status: .disruption("Minor delays on the Circle, Hammersmith & City and Metropolitan lines"),
                onTap: {}
            )

            Text(verbatim: "Loading")
            StationLineStatusRow(status: .loading)

            Text(verbatim: "Unavailable")
            StationLineStatusRow(status: .unavailable)
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding()
    }
    .background(Color.defaultBackground)
}
