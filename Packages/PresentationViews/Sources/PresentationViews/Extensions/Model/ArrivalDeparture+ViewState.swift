import Foundation
import Models

extension ArrivalDeparture {
    
    func toArrivalsBoardCellItem(withArrivalNumber arrivalNumber: Int,
                                 lineID: TrainLineID) -> ArrivalsBoardCellItem {
        
        let cellID = "\(id)-\(arrivalNumber)"
        
        let bottomLeadingTextItem: ArrivalsBoardTextItem?
        switch departureStatus {
        case .onTime:
            bottomLeadingTextItem = .departureStatus(.onTime)
        case .cancelled:
            bottomLeadingTextItem = .departureStatus(.cancelled)
        case .delayed:
            bottomLeadingTextItem = .departureStatus(.delayed)
        case .notStoppingHere:
            bottomLeadingTextItem = .departureStatus(.notStopping)
        case nil:
            bottomLeadingTextItem = nil
        }
        
        var bottomTrailingTextItem: ArrivalsBoardTextItem?
        if let scheduledTimeOfDeparture {
            bottomTrailingTextItem = .scheduledDepartureTime(ukDateFormatter.string(from: scheduledTimeOfDeparture))
        }
        
        let secondsToDeparture = parsedSeconds(for: minutesAndSecondsToDeparture) ?? parsedSeconds(for: minutesAndSecondsToArrival)
        
        return .init(id: cellID,
                     numberLabel: .init(value: arrivalNumber,
                                        backgroundColor: lineID.backgroundColor,
                                        textColor: lineID.textColor,
                                        textShadow: lineID.textShadow),
                     topLeadingTextItem: .destinationType(destinationType),
                     topTrailingTextItem: .countdownSeconds(secondsToDeparture),
                     bottomLeadingTextItem: bottomLeadingTextItem,
                     bottomTrailingTextItem: bottomTrailingTextItem)
    }
    
    private var destinationType: ArrivalsBoardDestinationType {
        if terminatesHere {
            return .checkFrontOfTrain
        } else if let sanitizedDestinationName, !sanitizedDestinationName.isEmpty {
            return .known(sanitizedDestinationName)
        } else {
            return .checkFrontOfTrain
        }
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

private let ukDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = .london
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter
}()

extension Sequence where Element == ArrivalDeparture {
    
    func sortedByArrivalOrDepartureTime() -> [Element] {
        sorted {
            let lhsArrivalOrDepartureTime = $0.scheduledTimeOfArrival ?? $0.scheduledTimeOfDeparture ?? .distantPast
            let rhsArrivalOrDepartureTime = $1.scheduledTimeOfArrival ?? $1.scheduledTimeOfDeparture ?? .distantPast
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
        
        let cellItems = sortedArrivalDepartures.enumerated().compactMap { idx, element in
            element.toArrivalsBoardCellItem(withArrivalNumber: idx + 1, lineID: lineID)
        }
        
        let platformName = sortedArrivalDepartures.first?.platformName ?? ""
        
        return .init(platformName: platformName,
                     cellItems: cellItems)
    }
}
