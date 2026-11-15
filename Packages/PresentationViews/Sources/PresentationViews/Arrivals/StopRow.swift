import Models
import SwiftUI

/// A row in a list of places to see arrivals for, so that other kinds of stop can be listed alongside stations.
public struct StopRow: Identifiable, Hashable, Sendable {

    public enum Kind: Hashable, Sendable {
        case station(Station)
    }

    public let id: String
    public let kind: Kind
    public let title: String
    public let lineIDs: [TrainLineID]
    public let distance: Double?

    public init(station: Station, distance: Double? = nil) {
        self.id = "station-\(station.id)"
        self.kind = .station(station)
        self.title = station.name
        self.lineIDs = station.sortedLineIDs
        self.distance = distance
    }

    public init(_ locatedStation: LocatedStation) {
        self.init(station: locatedStation.station, distance: locatedStation.distance)
    }
}

struct StopRowCell: View {

    let row: StopRow

    var body: some View {
        LineGroupCell(
            style: row.distance.map { .distance(metres: $0) } ?? .plain,
            lineIDs: row.lineIDs,
            title: row.title
        )
        .frame(minHeight: 52)
    }
}
