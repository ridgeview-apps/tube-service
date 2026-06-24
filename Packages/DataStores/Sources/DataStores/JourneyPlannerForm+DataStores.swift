import Foundation
import Models

extension JourneyPlannerForm {

    func toJourneyRequestParams(withModeIDs modeIDs: Set<ModeID>) throws -> JourneyRequestParams {
        guard let fromParam = from?.toRequestParamsJourneyLocation(),
            let toParam = to?.toRequestParamsJourneyLocation()
        else {
            throw JourneyPlannerError.invalidLocationRequest
        }

        var viaParam: JourneyRequestParams.JourneyLocation?
        if let via = via?.toRequestParamsJourneyLocation() {
            viaParam = .init(via)
        }

        let timeOption: JourneyRequestParams.TimeOptionParam?
        switch timeSelection.option {
        case .leaveNow:
            timeOption = nil
        case .leaveAt:
            timeOption = .departing(at: timeSelection.date)
        case .arriveBy:
            timeOption = .arriving(at: timeSelection.date)
        }

        return .init(
            from: fromParam,
            to: toParam,
            via: viaParam,
            modeIDs: modeIDs,
            timeOption: timeOption
        )
    }

    mutating func updateCurrentLocationInfo(
        name: LocationName?,
        coordinate: LocationCoordinate?,
        updatesAllowed: Bool
    ) {
        if let from, from.isCurrentLocation {
            self.from = updatesAllowed ? .currentLocation(name: name, coordinate: coordinate) : nil
        }
        if let to, to.isCurrentLocation {
            self.to = updatesAllowed ? .currentLocation(name: name, coordinate: coordinate) : nil
        }
        if let via, via.isCurrentLocation {
            self.via = updatesAllowed ? .currentLocation(name: name, coordinate: coordinate) : nil
        }
    }

    mutating func adjustCurrentTimeIfNeeded() {
        if timeSelection.date < .now {
            timeSelection.date = .now
        }
    }
}
