import SwiftUI

public struct MapsListView: View {
    
    public enum Action: Sendable {
        case tappedLink(MapLink)
    }
    
    @ScaledMetric private var dynamicTextScale: CGFloat = 1
    
    public let onAction: (Action) -> Void
    
    public init(onAction: @escaping (Action) -> Void) {
        self.onAction = onAction
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    link(for: .dayTubeMap)
                    link(for: .nightTubeMap)
                    link(for: .railAndTubeMap)
                    link(for: .elizabethLineMap)
                }
                .padding()
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height)
            }
        }
    }
    
    @ViewBuilder private func link(for mapLink: MapLink) -> some View {
        Button {
            onAction(.tappedLink(mapLink))
        } label: {
            Text(mapLink.title)
        }
        .buttonStyle(.primary)
    }
}


public struct MapLink: Identifiable, Sendable {
    public var id: String { url.absoluteString }
    public let title: LocalizedStringResource
    public let url: URL
    
    static let dayTubeMap = MapLink(
        title: .mapsTubeDayLinkTitle,
        url: URL(string: "https://content.tfl.gov.uk/standard-tube-map.pdf")!
    )
    
    static let nightTubeMap = MapLink(
        title: .mapsTubeNightLinkTitle,
        url: URL(string: "https://content.tfl.gov.uk/standard-night-tube-map.pdf")!
    )
    
    static let railAndTubeMap = MapLink(
        title: .mapsRailAndTubeLinkTitle,
        url: URL(string: "https://content.tfl.gov.uk/london-rail-and-tube-services-map.pdf")!
    )
    
    static let elizabethLineMap = MapLink(
        title: .mapsElizabethLinkTitle,
        url: URL(string: "https://content.tfl.gov.uk/elizabeth-line-map.pdf")!
    )
}

#Preview {
    NavigationStack {
        MapsListView { action in print(action) }
            .navigationTitle("Maps")
    }
}
