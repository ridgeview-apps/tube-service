import Foundation
import Models

public enum JourneyLocationPicker: Sendable {

    public typealias NamedLocationValue = JourneyNamedLocation
    public typealias Value = JourneyLocation

    public struct SectionState: Hashable, Identifiable {
        public enum SectionID: Hashable {
            case suggestions, nearbyStations, searchResults(count: Int)
        }

        public var id: SectionID { sectionID }

        public let sectionID: SectionID
        public let values: [Value]

        public static func suggestions(_ values: [Value]) -> SectionState {
            .init(sectionID: .suggestions, values: values)
        }

        public static func nearbyStations(_ values: [Value]) -> SectionState {
            .init(sectionID: .nearbyStations, values: values)
        }

        public static func searchResults(_ values: [Value]) -> SectionState {
            .init(sectionID: .searchResults(count: values.count), values: values)
        }
    }

    public enum Action: Sendable {
        case searchTermChanged(String)
        case valueSelected(Value)
    }
}

extension JourneyLocation {

    var name: String {
        switch self {
        case .station(let station):
            return station.name
        case .nationalRail(let stopPoint):
            return stopPoint.commonName ?? ""
        case .namedLocation(let location):
            if location.isCurrentLocation {
                return location.name?.formattedSingleLineTitle ?? String(localized: .journeyPlannerLocationValueCurrentLocation)
            } else {
                return location.name?.formattedSingleLineTitle ?? ""
            }
        }
    }
}


extension LocationName {
    var formattedSingleLineTitle: String {
        [title, subtitle]
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
}

private extension JourneyLocation {

    typealias SortProperties = (sortValue: Int, name: String)

    var sortProperties: SortProperties {
        switch self {
        case .station(let station):
            return (1, station.name)
        case .nationalRail(let stopPoint):
            return (1, stopPoint.commonName ?? "")
        case .namedLocation(let location):
            if location.isCurrentLocation {
                return (0, location.name?.title ?? "")
            } else {
                return (1, location.name?.title ?? "")
            }
        }
    }
}

private let timestampFormatter: DateFormatter = Formatter.relative(
    dateStyle: .medium,
    timeStyle: .short,
    context: .middleOfSentence
)

public typealias JourneyTimePickerSelection = JourneyTimeSelection

extension JourneyTimeSelection.Option {
    var title: LocalizedStringResource {
        switch self {
        case .leaveNow:
            .journeyPlannerTimePickerOptionLeaveNow
        case .leaveAt:
            .journeyPlannerTimePickerOptionLeaveLater
        case .arriveBy:
            .journeyPlannerTimePickerOptionArriveBy
        }
    }
}

extension JourneyTimeSelection {
    var formattedDate: String {
        switch option {
        case .leaveNow:
            timestampFormatter.string(from: .now)
        case .leaveAt, .arriveBy:
            timestampFormatter.string(from: date)
        }
    }
}

public extension Sequence where Element == JourneyLocation {
    func sortedByName() -> [Element] {
        sorted {
            $0.sortProperties < $1.sortProperties
        }
    }
}
