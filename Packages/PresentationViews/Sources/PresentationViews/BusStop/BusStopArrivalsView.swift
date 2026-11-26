import Models
import Shared
import SwiftUI

/// A bus stop's live board, below its direction, the stop opposite and any current notice.
public struct BusStopArrivalsView: View {

    public enum Action {
        case selectedRoute(String?)
        case tappedOpposite(BusStop)
        case tappedNotice
    }

    let stop: BusStop
    let oppositeStop: BusStop?
    let routes: [String]
    /// Nil for all routes.
    let selectedRoute: String?
    let arrivals: LiveArrivals
    /// Nil until they first arrive.
    let notices: [StationNotice]?
    let onRefresh: @Sendable () async -> Void
    let onAction: (Action) -> Void

    @Environment(\.clock) private var clock

    public init(
        stop: BusStop,
        oppositeStop: BusStop?,
        routes: [String],
        selectedRoute: String?,
        arrivals: LiveArrivals,
        notices: [StationNotice]?,
        onRefresh: @escaping @Sendable () async -> Void,
        onAction: @escaping (Action) -> Void
    ) {
        self.stop = stop
        self.oppositeStop = oppositeStop
        self.routes = routes
        self.selectedRoute = selectedRoute
        self.arrivals = arrivals
        self.notices = notices
        self.onRefresh = onRefresh
        self.onAction = onAction
    }

    private var hasChips: Bool { routes.count > 1 }

    private var currentNotice: StationNotice? {
        notices?.first { $0.timing(at: clock.now) == .current }
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Group {
                    header
                    if let oppositeStop {
                        OppositeStopRow(stop: oppositeStop) {
                            onAction(.tappedOpposite(oppositeStop))
                        }
                    }
                    if let currentNotice {
                        BusStopNoticeRow(notice: currentNotice, stopName: stop.name) {
                            onAction(.tappedNotice)
                        }
                    }
                }
                .padding(.horizontal, 16)
                StationBoardsView(arrivals: arrivals, style: .bus)
            }
            .padding(.top, hasChips ? 8 : 16)
            .padding(.bottom, 16)
        }
        // Before the bar, so neither reaches the chips' scroll view, whose refresh inset hides the chips on reopening
        .refreshable(action: onRefresh)
        .safeAreaBar(edge: .top) {
            if hasChips {
                BusRouteChipsView(routes: routes, selectedRoute: selectedRoute) { route in
                    onAction(.selectedRoute(route))
                }
            }
        }
        .defaultMaxWidthWithFullBackground()
    }

    private var header: some View {
        HStack(spacing: 12) {
            BusStopTile(letter: stop.letter)
                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
            if let towards = stop.towards {
                Text(.busStopTowards(towards))
                    .font(.headline)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(headerAccessibilityLabel)
    }

    private var headerAccessibilityLabel: String {
        [stop.letter.map { String(localized: .busStopLetter($0)) }, stop.towards.map { String(localized: .busStopTowards($0)) }]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}

private struct OppositeStopRow: View {
    let stop: BusStop
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                BusStopTile(letter: stop.letter, size: 24)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                VStack(alignment: .leading, spacing: 2) {
                    Text(.busStopOppositeTitle)
                        .foregroundStyle(.primary)
                    if let towards = stop.towards {
                        Text(.busStopTowards(towards))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer(minLength: 0)
                RowChevron()
            }
            .font(.subheadline)
            .banner(tint: .secondary)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}

private struct BusStopNoticeRow: View {
    let notice: StationNotice
    let stopName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: notice.isClosure ? "exclamationmark.triangle.fill" : "info.circle")
                    .foregroundStyle(notice.isClosure ? AnyShapeStyle(.orange) : AnyShapeStyle(.secondary))
                    .accessibilityHidden(true)
                Text(notice.text.removingStationNamePrefix(stopName))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
                RowChevron()
            }
            .font(.subheadline)
            .banner(tint: notice.isClosure ? .orange : .secondary)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}

private struct RowChevron: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.tertiary)
            .accessibilityHidden(true)
    }
}

private extension View {
    func banner(tint: Color) -> some View {
        frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(tint.opacity(0.12), in: .rect(cornerRadius: 12))
            .contentShape(.rect)
    }
}

// MARK: - Previews

import ModelStubs

private struct Previewer: View {
    var stop = BusStopDatabase.london.nearbyStops(to: LocationCoordinate(lat: 51.53047, lon: -0.12169), limit: 1)[0].stop
    var busArrivals: [BusArrival] = ModelStubs.busArrivalsKingsCrossStationR
    var loadingState: LoadingState = .loaded
    var refreshDate: Date? = .now
    var notices: [StationNotice]? = []
    var hasOpposite = true
    @State var selectedRoute: String?
    @State private var shownStop: BusStop?

    private var currentStop: BusStop { shownStop ?? stop }

    var body: some View {
        NavigationStack {
            BusStopArrivalsView(
                stop: currentStop,
                oppositeStop: hasOpposite ? BusStopDatabase.london.oppositeStop(of: currentStop) : nil,
                routes: busArrivals.routes(at: currentStop),
                selectedRoute: selectedRoute,
                arrivals: .init(
                    boardStates: busArrivals.toBoardStates(at: currentStop, route: selectedRoute),
                    refreshDate: refreshDate,
                    loadingState: loadingState
                ),
                notices: notices,
                onRefresh: {},
                onAction: { action in
                    switch action {
                    case .selectedRoute(let route): selectedRoute = route
                    case .tappedOpposite(let opposite): shownStop = opposite
                    case .tappedNotice: break
                    }
                }
            )
            .navigationTitle(currentStop.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview("Loaded with chips") {
    Previewer()
}

#Preview("Opposite stop") {
    Previewer(stop: BusStopDatabase.london.nearbyStops(to: LocationCoordinate(lat: 51.62669, lon: -0.17531), limit: 1)[0].stop)
}

#Preview("Route selected") {
    Previewer(selectedRoute: "73")
}

#Preview("Long destination") {
    Previewer(
        busArrivals: ModelStubs.busArrivalsKingsCrossStationR.map {
            guard $0.lineName == "30" else { return $0 }
            return BusArrival(
                id: $0.id,
                lineName: "326",
                destinationName: "Brent Cross, Shopping Centre",
                towards: nil,
                timeToStation: $0.timeToStation,
                naptanID: nil,
                platformName: nil
            )
        }
    )
}

#Preview("One route") {
    Previewer(
        stop: BusStop(
            id: "490000129X",
            name: "Swan Lane",
            letter: "SL",
            towards: "Whetstone",
            stopAreaID: nil,
            location: LocationCoordinate(lat: 51.63, lon: -0.18),
            routes: ["263"]
        ),
        busArrivals: ModelStubs.busArrivalsKingsCrossStationR.filter { $0.lineName == "73" }.map {
            BusArrival(id: $0.id, lineName: "263", destinationName: "Barnet Hospital", towards: nil, timeToStation: $0.timeToStation, naptanID: nil, platformName: nil)
        },
        hasOpposite: false
    )
}

#Preview("No letter") {
    Previewer(
        stop: BusStop(
            id: "490000129Y",
            name: "Totteridge & Whetstone Station",
            letter: nil,
            towards: "Barnet",
            stopAreaID: nil,
            location: LocationCoordinate(lat: 51.6302, lon: -0.1791),
            routes: ["34", "125", "251"]
        ),
        hasOpposite: false
    )
}

#Preview("Closure") {
    Previewer(
        notices: [
            StationNotice(
                text: "King's Cross Station (R) towards Euston: This stop is closed due to roadworks. Please use the temporary stop 50 metres before it on Euston Road.",
                kind: "Closure"
            )
        ]
    )
}

#Preview("Loading") {
    Previewer(busArrivals: [], loadingState: .loading, refreshDate: nil, notices: nil)
}

#Preview("No arrivals") {
    Previewer(busArrivals: [])
}

#Preview("Failure") {
    Previewer(busArrivals: [], loadingState: .failure(errorMessage: "Loading failure"))
}
