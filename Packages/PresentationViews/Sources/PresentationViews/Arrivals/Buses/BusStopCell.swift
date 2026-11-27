import Models
import SwiftUI

/// A bus stop on its own, away from its place, e.g. in Favourites or Recent.
struct BusStopCell: View {

    let stop: BusStop

    @Environment(\.locale) private var locale

    var body: some View {
        HStack(spacing: 12) {
            BusStopTile(letter: stop.letter)
                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
            VStack(alignment: .leading, spacing: 4) {
                Text(stop.name)
                if let towards = stop.towards {
                    Text(.busStopTowards(towards))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                BusRouteTags(routes: stop.routes)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .contentShape(Rectangle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel([stop.name, stop.accessibilityDescription(locale: locale)].joined(separator: ", "))
    }
}

extension BusStop {
    /// The stop's letter, direction and routes, without its name.
    func accessibilityDescription(locale: Locale) -> String {
        let parts = [
            letter.map { String(localized: .busStopLetter($0)) },
            towards.map { String(localized: .busStopTowards($0)) },
            String(localized: .busStopRoutes(routes.formatted(.list(type: .and).locale(locale))))
        ]
        return parts.compactMap { $0 }.joined(separator: ", ")
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack(alignment: .leading, spacing: 16) {
        ForEach(BusStopDatabase.london.nearbyStops(to: LocationCoordinate(lat: 51.530823, lon: -0.123821), limit: 3), id: \.stop.id) {
            BusStopCell(stop: $0.stop)
        }
    }
    .frame(width: 360)
    .padding()
}
