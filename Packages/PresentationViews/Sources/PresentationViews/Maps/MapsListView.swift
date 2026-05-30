import SwiftUI

public struct MapsListView: View {

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(MapLink.allMaps) { mapLink in
                    mapCard(for: mapLink)
                }
            }
            .withDefaultMaxWidth()
            .padding()
        }
        .background(Color.defaultBackground)
    }

    private func mapCard(for mapLink: MapLink) -> some View {
        NavigationLink(value: mapLink) {
            HStack(spacing: 16) {
                Image(systemName: mapLink.iconName)
                    .font(.title2)
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 32)

                Text(mapLink.title)
                    .font(.body)
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .cardStyle()
        }
        .buttonStyle(.plain)
    }
}


public struct MapLink: Identifiable, Hashable, Sendable {
    public var id: String { url.absoluteString }
    public let title: LocalizedStringResource
    public let iconName: String
    public let url: URL

    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }

    public static func == (lhs: MapLink, rhs: MapLink) -> Bool {
        lhs.url == rhs.url
    }

    static let allMaps: [MapLink] = [dayTubeMap, nightTubeMap, railAndTubeMap, elizabethLineMap]

    static let dayTubeMap = MapLink(
        title: .mapsTubeDayLinkTitle,
        iconName: "map",
        url: URL(string: "https://content.tfl.gov.uk/standard-tube-map.pdf")!
    )

    static let nightTubeMap = MapLink(
        title: .mapsTubeNightLinkTitle,
        iconName: "moon.stars",
        url: URL(string: "https://content.tfl.gov.uk/standard-night-tube-map.pdf")!
    )

    static let railAndTubeMap = MapLink(
        title: .mapsRailAndTubeLinkTitle,
        iconName: "tram.fill",
        url: URL(string: "https://content.tfl.gov.uk/london-rail-and-tube-services-map.pdf")!
    )

    static let elizabethLineMap = MapLink(
        title: .mapsElizabethLinkTitle,
        iconName: "train.side.front.car",
        url: URL(string: "https://content.tfl.gov.uk/elizabeth-line-map.pdf")!
    )
}

#Preview {
    NavigationStack {
        MapsListView()
            .navigationTitle("Maps")
    }
}
