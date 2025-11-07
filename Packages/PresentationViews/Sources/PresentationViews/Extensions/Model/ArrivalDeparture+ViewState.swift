import Foundation
import Models

extension ArrivalDeparture {
    
    func toArrivalsBoardCellItem(withArrivalNumber arrivalNumber: Int,
                                 lineID: TrainLineID) -> ArrivalsBoardCellItem {
        
        let cellID = "\(id)-\(arrivalNumber)"
        
        var bottomLeadingTextItems = [ArrivalsBoardTextItem]()
        
        if let scheduledTimeOfDeparture {
            var colorStyle: ArrivalsBoardTextItem.Style.ColorStyle = .secondary
            var isStrikeThrough = false
            
            if isDelayedByMoreThanOneMinute {
                colorStyle = .warning
                isStrikeThrough = estimatedTimeOfDeparture != nil
            } else if departureStatus == .cancelled || departureStatus == .notStoppingHere {
                colorStyle = .warning
                isStrikeThrough = true
            }
            
            let departsAtText = ArrivalsBoardTextItem.localizedMessage(
                .arrivalsBoardDepartsAt,
                style: .footerMedium(
                    colorStyle: colorStyle,
                    isStrikeThrough: departureStatus == .cancelled || departureStatus == .notStoppingHere)
            )
            
            let formattedDepartureText = ArrivalsBoardTextItem.verbatimMessage(
                ukDateFormatter.string(from: scheduledTimeOfDeparture),
                style: .footerMedium(
                    colorStyle: colorStyle,
                    isStrikeThrough: isStrikeThrough,
                )
            )
            bottomLeadingTextItems += [departsAtText,
                                       formattedDepartureText]
        }
        
        if isDelayedByMoreThanOneMinute {
            if let estimatedTimeOfDeparture {
                let estimatedDepartureTextItem = ArrivalsBoardTextItem.verbatimMessage(ukDateFormatter.string(from: estimatedTimeOfDeparture),
                                                                                       style: .footerMedium(colorStyle: .warning))
                bottomLeadingTextItems.append(estimatedDepartureTextItem)
            }
        }
        
        return .init(
            id: cellID,
            numberLabel: .init(value: arrivalNumber,
                               backgroundColor: lineID.backgroundColor,
                               textColor: lineID.textColor,
                               textShadow: lineID.textShadow),
            destinationText: destinationTextItem,
            topTrailingTextItem: countdownTextItem,
            bottomLeadingTextItems: bottomLeadingTextItems,
            bottomTrailingTextItem: departureStatusTextItem
        )
    }
    
    private var destinationTextItem: ArrivalsBoardTextItem {
        let textStyle = ArrivalsBoardTextItem.Style.header()
        let checkFrontOfTrain = ArrivalsBoardTextItem.localizedMessage(.arrivalsCheckFrontOfTrain,
                                                                       style: textStyle)
        
        if terminatesHere {
            return checkFrontOfTrain
        } else if let sanitizedDestinationName, !sanitizedDestinationName.isEmpty {
            return .verbatimMessage(sanitizedDestinationName, style: textStyle)
        } else {
            return checkFrontOfTrain
        }
    }
    
    private var countdownTextItem: ArrivalsBoardTextItem? {
        let secondsToDeparture = parsedSeconds(for: minutesAndSecondsToDeparture) ?? parsedSeconds(for: minutesAndSecondsToArrival)
        return .countdownSeconds(secondsToDeparture, style: .header())
    }
    
    private var departureStatusTextItem: ArrivalsBoardTextItem? {
        let style: ArrivalsBoardTextItem.Style = .footerMedium()
        
        switch departureStatus {
        case .onTime:
            return nil
//            return .localizedMessage(.arrivalsBoardDepartureStatusOnTime, style: style)
        case .cancelled:
            let style: ArrivalsBoardTextItem.Style = .footerMedium(colorStyle: .warning)
            return .localizedMessage(.arrivalsBoardDepartureStatusCancelled, style: style)
        case .delayed:
            if isDelayedByMoreThanOneMinute {
                let style: ArrivalsBoardTextItem.Style = .footerMedium(colorStyle: .warning)
                return .localizedMessage(.arrivalsBoardDepartureStatusDelayed, style: style)
            } else {
                return nil
//                return .localizedMessage(.arrivalsBoardDepartureStatusOnTime, style: style)
            }
        case .notStoppingHere:
            return .localizedMessage(.arrivalsBoardDepartureStatusNotStopping, style: style)
        case nil:
            return nil
        }
    }
    
    private var isDelayedByMoreThanOneMinute: Bool {
        guard departureStatus == .delayed else {
            return false
        }
        
        guard let estimatedTimeOfDeparture, let scheduledTimeOfDeparture else {
            return true
        }
        
        let secondsDifference = abs(estimatedTimeOfDeparture.timeIntervalSince1970 - scheduledTimeOfDeparture.timeIntervalSince1970)
        
        return secondsDifference > 60
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
