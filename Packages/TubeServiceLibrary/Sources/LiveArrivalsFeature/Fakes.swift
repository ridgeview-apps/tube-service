import Foundation
import ComposableArchitecture
import Model
import ModelFakes
import Shared
import DataClients

// MARK: - ArrivalsBoard.State
public extension ArrivalsBoard.State {
    static func fake(station: Station = .fake(ofType: .kingsCross),
                     arrivals: [Arrival] = .fakes(ofTypes: .singleLineSouthbound),
                     isExpanded: Bool = false,
                     time: Date = .init()) -> Self {
        .init(station: station,
              arrivals: arrivals,
              time: time,
              isExpanded: isExpanded)
    }
}

// MARK: - ArrivalsBoard.Environment
public extension ArrivalsBoard.Environment {
    static func fake(
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.immediate.eraseToAnyScheduler()
    ) -> Self {
        .init(mainQueue: mainQueue)
    }
}

// MARK: - ArrivalsBoardsList.State
public extension ArrivalsBoardsList.State {
    static func fake(station: Station = .fake(ofType: .kingsCross),
                     arrivalsGroupIndex: Int = 0,
                     isFavourite: Bool = false,
                     boards: [ArrivalsBoard.State] = [
                        .fake(arrivals: .fakes(ofTypes: .multiLine))
                     ],
                     errorMessage: String? = nil) -> ArrivalsBoardsList.State {
        .init(id: .init(station: station, arrivalsGroup: station.arrivalsGroups[arrivalsGroupIndex]),
              isFavourite: isFavourite,
              boards: IdentifiedArrayOf(uniqueElements: boards),
              errorMessage: errorMessage)
    }
}

// MARK: - ArrivalsBoardsList.Environment
public extension ArrivalsBoardsList.Environment {
    static func fake(
        transportAPI: TransportAPIClient = .fake,
        now: @escaping () -> Date = Date.init,
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.immediate.eraseToAnyScheduler()
    ) -> Self {
        .init(transportAPI: transportAPI,
              now: now,
              mainQueue: mainQueue)
    }
}


// MARK: - ArrivalsPicker.State
public extension ArrivalsPicker.State {
    static func fake(
        userPreferences: UserPreferences = .fake(),
        selectableStations: [Station] = .fakes().sortedByName()
    ) -> Self {
        return .init(selectableStations: IdentifiedArrayOf(uniqueElements: selectableStations),
                     userPreferences: userPreferences)
    }
}

// MARK: - ArrivalsPicker.Environment
public extension ArrivalsPicker.Environment {
    
    static func fake(
        transportAPI: TransportAPIClient = .fake,
        stationsClient: StationsClient = .fake,
        userPreferencesClient: UserPreferencesClient = .fake,
        now: @escaping () -> Date = Date.init,
        mainQueue: AnySchedulerOf<DispatchQueue> = .immediate.eraseToAnyScheduler()
    ) -> Self {
        .init(transportAPI: transportAPI,
              stationsClient: stationsClient,
              userPreferencesClient: userPreferencesClient,
              now: now,
              mainQueue: mainQueue)
    }
}
