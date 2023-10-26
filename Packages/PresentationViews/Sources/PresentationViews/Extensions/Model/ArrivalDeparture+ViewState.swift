import Foundation
import Models

extension ArrivalDeparture {
    
    func toArrivalsBoardCellItem(withArrivalNumber arrivalNumber: Int,
                                 lineID: LineID) -> ArrivalsBoardCellItem {
        
        let cellID = "\(id)-\(arrivalNumber)"
        
        var subtitleType: ArrivalsBoardSubtitleType?
        if let scheduledTimeOfDeparture {
            subtitleType = .depatureTime(ukDateFormatter.string(from: scheduledTimeOfDeparture))
        }
        
        let secondsToDeparture = parsedSeconds(for: minutesAndSecondsToDeparture) ?? parsedSeconds(for: minutesAndSecondsToArrival)
        
        return .init(id: cellID,
                     numberLabel: .init(value: arrivalNumber,
                                        backgroundColor: lineID.backgroundColor,
                                        textColor: lineID.textColor,
                                        textShadow: lineID.textShadow),
                     destinationType: destinationType,
                     secondsToArrival: secondsToDeparture,
                     subtitleType: subtitleType)
    }
    
    private var destinationType: ArrivalsBoardDestinationType {
        if terminatesHere {
            return .checkFrontOfTrain
        } else if let sanitizedDestinationName, !sanitizedDestinationName.isEmpty {
            return .destination(sanitizedDestinationName)
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

    public func toPlatformBoardStates(forLineID lineID: LineID) -> [ArrivalsBoardState] {
        let arrivalDeparturesPerPlatform = Dictionary(grouping: self, by: \.platformName)
        
        return arrivalDeparturesPerPlatform
            .map { platformName, arrivalDepartures in
                singlePlatformBoardState(for: arrivalDepartures, with: lineID)
            }
            .sorted { $0.platformName < $1.platformName }
    }
    
    private func singlePlatformBoardState(for arrivalDepartures: [ArrivalDeparture],
                                          with lineID: LineID) -> ArrivalsBoardState {
        let sortedArrivalDepartures = arrivalDepartures.sortedByArrivalOrDepartureTime()
        
        let cellItems = sortedArrivalDepartures.enumerated().compactMap { idx, element in
            element.toArrivalsBoardCellItem(withArrivalNumber: idx + 1, lineID: lineID)
        }
        
        let platformName = sortedArrivalDepartures.first?.platformName ?? ""
        
        return .init(platformName: platformName,
                     cellItems: cellItems)
    }
}
