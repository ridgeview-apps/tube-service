import SwiftUI

struct NoFavouritesHintRow: View {

    let subtitle: LocalizedStringResource
    var findButton: (title: LocalizedStringResource, action: () -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "star")
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(.arrivalsNoFavouritesTitle)
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if let findButton {
                Button(findButton.title, action: findButton.action)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .controlSize(.small)
            }
        }
        .frame(minHeight: 52)
    }
}
