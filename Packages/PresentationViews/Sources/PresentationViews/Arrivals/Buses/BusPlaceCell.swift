import Models
import SwiftUI

struct BusPlaceCell: View {

    enum Action: Sendable {
        case tappedStop(BusStop)
        case tappedMoreStops
    }

    let place: NearbyBusPlace
    let isExpanded: Bool
    let onAction: (Action) -> Void

    @Environment(\.locale) private var locale
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private static let collapsedStopCount = 2

    private var isCollapsible: Bool { place.stops.count > Self.collapsedStopCount + 1 }

    private var visibleStops: [NearbyBusStop] {
        isCollapsible && !isExpanded ? Array(place.stops.prefix(Self.collapsedStopCount)) : place.stops
    }

    private var hiddenStopCount: Int { place.stops.count - visibleStops.count }

    private var onlyStop: BusStop? { place.stops.count == 1 ? place.stops.first?.stop : nil }

    @ViewBuilder var body: some View {
        if let onlyStop {
            onlyStopButton(for: onlyStop)
        } else {
            stopList
        }
    }

    private func onlyStopButton(for stop: BusStop) -> some View {
        Button {
            onAction(.tappedStop(stop))
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                header
                stopLabel(for: stop)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel([place.name, formattedDistance, stop.accessibilityDescription(locale: locale)].joined(separator: ", "))
        .accessibilityAddTraits(.isButton)
    }

    private var stopList: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            ForEach(visibleStops, id: \.stop.id) { nearbyStop in
                stopButton(for: nearbyStop.stop)
            }
            if hiddenStopCount > 0 {
                Button {
                    withAnimation { onAction(.tappedMoreStops) }
                } label: {
                    Text(.nearbyBusStopsMore(hiddenStopCount))
                        .font(.subheadline)
                        .foregroundStyle(Color.accentColor)
                }
                .buttonStyle(.plain)
            }
        }
    }

    @ViewBuilder private var header: some View {
        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: 2) {
                placeName
                distanceText
            }
        } else {
            HStack {
                placeName
                Spacer()
                distanceText
            }
        }
    }

    private var placeName: some View {
        Text(place.name)
            .font(.headline)
    }

    private var distanceText: some View {
        Text(formattedDistance)
            .font(.subheadline)
            .foregroundStyle(Color.secondary)
    }

    private var formattedDistance: String {
        Measurement(value: place.distance, unit: UnitLength.meters)
            .formatted(.measurement(width: .abbreviated, usage: .road).locale(locale))
    }

    private func stopButton(for stop: BusStop) -> some View {
        Button {
            onAction(.tappedStop(stop))
        } label: {
            stopLabel(for: stop)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(stop.accessibilityDescription(locale: locale))
        .accessibilityAddTraits(.isButton)
    }

    private func stopLabel(for stop: BusStop) -> some View {
        HStack(spacing: 12) {
            BusStopTile(letter: stop.letter)
                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
            VStack(alignment: .leading, spacing: 4) {
                if let towards = stop.towards {
                    Text(.busStopTowards(towards))
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                }
                BusRouteTags(routes: stop.routes)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Previews

private struct Previewer: View {
    let placeID: NearbyBusPlace.ID

    private var place: NearbyBusPlace? {
        BusStopDatabase.london
            .nearbyPlaces(to: LocationCoordinate(lat: 51.6302, lon: -0.1791), within: 500, limit: 30)
            .first { $0.id == placeID }
    }

    var body: some View {
        List {
            if let place {
                BusPlaceCell(place: place, isExpanded: false) { print($0) }
            }
        }
    }
}

#Preview("One stop") {
    Previewer(placeID: "490015488M")
}

#Preview("Two stops") {
    Previewer(placeID: "490014562W")
}
