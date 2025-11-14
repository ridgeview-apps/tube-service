import Foundation
import Models

extension ArrivalDeparture {
    
    func toArrivalsBoardCellItem(withArrivalNumber arrivalNumber: Int,
                                 lineID: TrainLineID) -> ArrivalsBoardCellItem {
        
        let cellID = "\(id)-\(arrivalNumber)"
        
        let bottomTextMessage: ArrivalsBoardCellItem.BottomTextMessage = .departureInfo(
            scheduled: scheduledDepartureTextItem,
            estimated: estimatedDepartureTextItem,
            status: departureStatusWarningTextItem
        )
        
        return .init(
            id: cellID,
            numberLabel: .init(value: arrivalNumber,
                               backgroundColor: lineID.backgroundColor,
                               textColor: lineID.textColor,
                               textShadow: lineID.textShadow),
            destinationText: destinationTextItem,
            countdownText: countdownTextItem,
            bottomTextMessage: bottomTextMessage
        )
    }
    
    private var destinationTextItem: ArrivalsBoardTextItem {
        if terminatesHere {
            return .destination(.checkFrontOfTrain)
        } else if let sanitizedDestinationName, !sanitizedDestinationName.isEmpty {
            return .destination(.towards(sanitizedDestinationName))
        } else {
            return .destination(.checkFrontOfTrain)
        }
    }
    
    private var countdownTextItem: ArrivalsBoardTextItem {
        let secondsToDeparture = parsedSeconds(for: minutesAndSecondsToDeparture) ?? parsedSeconds(for: minutesAndSecondsToArrival)
        
        return .countdownSeconds(secondsToDeparture,
                                 isStrikethrough: isCancelledOrNotStopping)
    }
    
    private var scheduledDepartureTextItem: ArrivalsBoardTextItem? {
        guard let scheduledTimeOfDeparture else { return nil }
        return .departureTimeScheduled(departureTime: scheduledTimeOfDeparture)
    }
    
    private var estimatedDepartureTextItem: ArrivalsBoardTextItem? {
        guard let estimatedTimeOfDeparture, isSignificantlyDelayed else { return nil }
        return .departureTimeEstimated(departureTime: estimatedTimeOfDeparture)
    }
    
    private var isCancelledOrNotStopping: Bool {
        departureStatus == .cancelled || departureStatus == .notStoppingHere

    }

    private var departureStatusWarningTextItem: ArrivalsBoardTextItem? {

        switch departureStatus {
        case .cancelled:
            return .departureStatus(.cancelled)
        case .notStoppingHere:
            return .departureStatus(.notStoppingHere)
        case .delayed where isSignificantlyDelayed:
            return .departureStatus(.delayed)
        default:
            return nil
        }
    }
    
    private var isSignificantlyDelayed: Bool {
        guard departureStatus == .delayed else {
            return false
        }
        
        guard let estimatedTimeOfDeparture, let scheduledTimeOfDeparture else {
            return true // Can't calculate the delay, so assume significantly delayed
        }
        
        let secondsDifference = abs(estimatedTimeOfDeparture.timeIntervalSince1970 - scheduledTimeOfDeparture.timeIntervalSince1970)
        
        return secondsDifference > 120
    }
    
    private var terminatesHere: Bool {
        (sanitizedStationName ?? "").contains(sanitizedDestinationName ?? "")
    }
    
    private var sanitizedDestinationName: String? {
        destinationName?.replacingOccurrences(of: "Rail Station", with: "").trimmed()
    }
    
    private var sanitizedStationName: String? {
        stationName?.replacingOccurrences(of: "Rail Station", with: "").trimmed()
    }
       
    private func parsedSeconds(for minutesAndSecondsString: String?) -> Int? {
        guard let minutesAndSecondsString, !minutesAndSecondsString.isEmpty else {
            return nil
        }
        
        let minuteAndSecondComps = minutesAndSecondsString.components(separatedBy: ":").compactMap { Int($0) }
        
        guard minuteAndSecondComps.count == 2 else { return nil }
        
        let minutes = minuteAndSecondComps[0]
        let seconds = minuteAndSecondComps[1]
        
        return (minutes * 60) + seconds

    }
}

extension Sequence where Element == ArrivalDeparture {
    
    func sortedByArrivalOrDepartureTime() -> [Element] {
        sorted {
            let lhsArrivalOrDepartureTime = $0.estimatedTimeOfDeparture ?? $0.scheduledTimeOfDeparture ?? .distantPast
            let rhsArrivalOrDepartureTime = $1.estimatedTimeOfDeparture ?? $1.scheduledTimeOfDeparture ?? .distantPast
            return lhsArrivalOrDepartureTime < rhsArrivalOrDepartureTime
        }
    }

    public func toPlatformBoardStates(forLineID lineID: TrainLineID) -> [ArrivalsBoardState] {
        let arrivalDeparturesPerPlatform = Dictionary(grouping: self, by: \.platformName)
        
        return arrivalDeparturesPerPlatform
            .map { _, arrivalDepartures in
                singlePlatformBoardState(for: arrivalDepartures, with: lineID)
            }
            .sorted { $0.platformName < $1.platformName }
    }
    
    private func singlePlatformBoardState(for arrivalDepartures: [ArrivalDeparture],
                                          with lineID: TrainLineID) -> ArrivalsBoardState {
        let sortedArrivalDepartures = arrivalDepartures.sortedByArrivalOrDepartureTime()
        
        let cellItems = sortedArrivalDepartures
                            .enumerated()
                            .compactMap { idx, element in
                                element.toArrivalsBoardCellItem(withArrivalNumber: idx + 1, lineID: lineID)
                            }
        
        let platformName = sortedArrivalDepartures.first?.platformName ?? ""
        
        return .init(platformName: platformName,
                     cellItems: cellItems)
    }
}
