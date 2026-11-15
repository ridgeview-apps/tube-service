import Models
import SwiftUI

public struct SearchView: View {

    public enum Content: Sendable {
        case suggestions(nearby: [StopRow], recents: [StopRow])
        case results(searchTerm: String, stops: [StopRow], lines: [TrainLineID])
    }

    public enum Action: Sendable {
        case tappedStation(Station)
        case tappedLine(TrainLineID)
        case tappedRefreshNearby
        case tappedHint
    }

    let content: Content
    let locationAccess: LocationAccess
    let onAction: (Action) -> Void

    public init(
        content: Content,
        locationAccess: LocationAccess,
        onAction: @escaping (Action) -> Void
    ) {
        self.content = content
        self.locationAccess = locationAccess
        self.onAction = onAction
    }


    // MARK: - Layout

    public var body: some View {
        contentView
            .defaultMaxWidthWithFullBackground()
            .frame(maxHeight: .infinity)
            .background(Color.defaultBackground)
    }

    @ViewBuilder private var contentView: some View {
        switch content {
        case .suggestions(let nearby, let recents):
            List {
                LocatedStationsSection(
                    title: .searchNearbySectionTitle,
                    locationAccess: locationAccess,
                    rows: nearby,
                    onAction: handleNearbyAction
                )
                recentsSection(recents)
            }
            .defaultScrollContentBackgroundColor()
        case .results(let searchTerm, let stops, let lines) where stops.isEmpty && lines.isEmpty:
            ContentUnavailableView.search(text: searchTerm)
        case .results(_, let stops, let lines):
            List {
                stopsSection(title: .searchResultsStationsSectionTitle, rows: stops)
                linesSection(lines)
            }
            .defaultScrollContentBackgroundColor()
        }
    }

    @ViewBuilder private func recentsSection(_ recents: [StopRow]) -> some View {
        if recents.isEmpty {
            Section {
                hintRow
            }
            .lineGroupListRowStyle()
        } else {
            stopsSection(title: .searchRecentSectionTitle, rows: recents)
        }
    }

    private var hintRow: some View {
        Button {
            onAction(.tappedHint)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text(.searchHintTitle)
                    Text(.searchHintSubtitle)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(minHeight: 52)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder private func stopsSection(title: LocalizedStringResource, rows: [StopRow]) -> some View {
        if !rows.isEmpty {
            Section {
                ForEach(rows) { row in
                    Button {
                        handleTap(on: row)
                    } label: {
                        StopRowCell(row: row)
                    }
                    .buttonStyle(.plain)
                }
            } header: {
                Text(title)
            }
            .lineGroupListRowStyle()
        }
    }

    @ViewBuilder private func linesSection(_ lines: [TrainLineID]) -> some View {
        if !lines.isEmpty {
            Section {
                ForEach(lines) { lineID in
                    Button {
                        onAction(.tappedLine(lineID))
                    } label: {
                        LineGroupCell(style: .plain, lineIDs: [lineID], title: lineID.name)
                            .frame(minHeight: 52)
                    }
                    .buttonStyle(.plain)
                }
            } header: {
                Text(.searchResultsLinesSectionTitle)
            }
            .lineGroupListRowStyle()
        }
    }

    private func handleTap(on row: StopRow) {
        switch row.kind {
        case .station(let station):
            onAction(.tappedStation(station))
        }
    }

    private func handleNearbyAction(_ action: LocatedStationsSection.Action) {
        switch action {
        case .tappedRefresh:
            onAction(.tappedRefreshNearby)
        case .tappedStation(let station):
            onAction(.tappedStation(station))
        }
    }
}


// MARK: - Previews

import ModelStubs

private struct Previewer: View {
    var content: SearchView.Content
    var locationAccessState: LocationAccess.State = .allowed(.loaded)

    var body: some View {
        NavigationStack {
            SearchView(
                content: content,
                locationAccess: .init(state: locationAccessState) {
                    print("Permissions requested")
                },
                onAction: { print($0) }
            )
            .navigationTitle("Search")
        }
    }
}

private let previewNearby = [
    ModelStubs.locatedStationWoodsidePark,
    ModelStubs.locatedStationWestFinchley,
    ModelStubs.locatedStationTotteridgeAndWhetstone
].map(StopRow.init)

private let previewRecents = [
    ModelStubs.kingsCrossStation,
    ModelStubs.eastFinchleyStation
].map { StopRow(station: $0) }

#Preview("Suggestions") {
    Previewer(content: .suggestions(nearby: previewNearby, recents: previewRecents))
}

#Preview("Suggestions - no recents, location off") {
    Previewer(content: .suggestions(nearby: [], recents: []), locationAccessState: .denied)
}

#Preview("Results") {
    Previewer(
        content: .results(
            searchTerm: "vic",
            stops: previewRecents,
            lines: [.victoria]
        )
    )
}

#Preview("No results") {
    Previewer(content: .results(searchTerm: "xyz", stops: [], lines: []))
}
