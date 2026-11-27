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

    var body: some View {
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
            HStack(spacing: 12) {
                BusStopTile(letter: stop.letter)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                VStack(alignment: .leading, spacing: 4) {
                    if let towards = stop.towards {
                        Text(.busStopTowards(towards))
                            .font(.subheadline)
                    }
                    BusRouteTags(routes: stop.routes)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(stop.accessibilityDescription(locale: locale))
        .accessibilityAddTraits(.isButton)
    }
}
