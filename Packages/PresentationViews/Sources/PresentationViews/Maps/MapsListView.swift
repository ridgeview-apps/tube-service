import SwiftUI

public struct MapsListView: View {
    
    @ScaledMetric private var dynamicTextScale: CGFloat = 1
    
    @State private var selectedValue: MapLink?
    
    public init() {}
    
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
            selectedValue = mapLink
        } label: {
            Text(mapLink.title)
        }
        .buttonStyle(.primary)
        .sheet(item: $selectedValue) { selectedValue in
            SafariView(url: selectedValue.url)
        }
        
    }
}


private struct MapLink: Identifiable {
    var id: String { url.absoluteString }
    let title: LocalizedStringResource
    let url: URL
    
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
        MapsListView()
            .navigationTitle("Maps")
    }
}
