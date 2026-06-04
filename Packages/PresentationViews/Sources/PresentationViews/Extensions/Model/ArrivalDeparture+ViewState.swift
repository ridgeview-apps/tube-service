import Foundation
import Models

extension ArrivalDeparture {

    func toArrivalsBoardCellItem(
        withArrivalNumber arrivalNumber: Int,
        lineID: TrainLineID
    ) -> ArrivalsBoardCellItem {

        let cellID = "\(id)-\(arrivalNumber)"

        return .init(
            id: cellID,
            numberLabel: .init(
                value: arrivalNumber,
                backgroundColor: lineID.backgroundColor,
                textColor: lineID.textColor,
                textShadow: lineID.textShadow
            ),
            headerRow: headerRowState,
            footerRow: footerRow
        )
    }

    private var headerRowState: ArrivalsBoardCellItem.HeaderRowState {
        .init(
            style: .scheduledDeparture,
            destination: destinationText,
            countdownText: countdownText,
            needsStrikethrough: isCancelledOrNotStopping
        )
    }

    private var countdownText: ArrivalsBoardCellItem.TextType {
        let secondsToDeparture = parsedSeconds(for: minutesAndSecondsToDeparture) ?? parsedSeconds(for: minutesAndSecondsToArrival)
        return CountdownTextFormatter.formattedText(forSeconds: secondsToDeparture)
    }

    private var destinationText: ArrivalsBoardCellItem.HeaderRowState.DestinationType {
        if terminatesHere {
            return .checkFrontOfTrain
        } else if let sanitizedDestinationName, !sanitizedDestinationName.isEmpty {
            return .towards(sanitizedDestinationName)
        } else {
            return .checkFrontOfTrain
        }
    }

    private var footerRow: ArrivalsBoardCellItem.FooterRowType? {
        let departureStatusText: ArrivalsBoardCellItem.TextType?
        let textStyle: ArrivalsBoardCellItem.DepartureStatusState.Style

        switch departureStatus {
        case .cancelled:
            departureStatusText = .localized(.arrivalsBoardDepartureStatusCancelled)
            textStyle = .warning
        case .notStoppingAtStation:
            departureStatusText = .localized(.arrivalsBoardDepartureStatusNotStopping)
            textStyle = .warning
        case .delayed where isSignificantlyDelayed:
            departureStatusText = .localized(.arrivalsBoardDepartureStatusDelayed)
            textStyle = .warning
        default:
            departureStatusText = .localized(.arrivalsBoardDepartureStatusOnTime)
            textStyle = .info
        }

        return .departureStatus(
            .init(
                scheduledDeparture: scheduledDepartureTimeText,
                estimatedDeparture: estimatedDepartureTimeText,
                statusText: departureStatusText,
                style: textStyle
            )
        )
    }

    private var scheduledDepartureTimeText: ArrivalsBoardCellItem.TextType? {
        guard let scheduledTimeOfDeparture else { return nil }
        return .verbatim(DepartureTimeFormatter.formattedText(for: scheduledTimeOfDeparture))
    }

    private var estimatedDepartureTimeText: ArrivalsBoardCellItem.TextType? {
        guard let estimatedTimeOfDeparture, isSignificantlyDelayed else { return nil }
        let formattedDepartureTime = DepartureTimeFormatter.formattedText(for: estimatedTimeOfDeparture)
        return .localized(.arrivalsBoardDepartureTimeEstimated(formattedDepartureTime))
    }

    private var isCancelledOrNotStopping: Bool {
        departureStatus == .cancelled || departureStatus == .notStoppingAtStation

    }

    private var isSignificantlyDelayed: Bool {
        guard departureStatus == .delayed else {
            return false
        }

        guard let estimatedTimeOfDeparture, let scheduledTimeOfDeparture else {
            return true  // Can't calculate the delay, so assume significantly delayed
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

        return
            arrivalDeparturesPerPlatform
            .map { _, arrivalDepartures in
                singlePlatformBoardState(for: arrivalDepartures, with: lineID)
            }
            .sorted { $0.platformName < $1.platformName }
    }

    private func singlePlatformBoardState(
        for arrivalDepartures: [ArrivalDeparture],
        with lineID: TrainLineID
    ) -> ArrivalsBoardState {
        let sortedArrivalDepartures = arrivalDepartures.sortedByArrivalOrDepartureTime()

        let cellItems =
            sortedArrivalDepartures
            .enumerated()
            .compactMap { idx, element in
                element.toArrivalsBoardCellItem(withArrivalNumber: idx + 1, lineID: lineID)
            }

        let platformName = sortedArrivalDepartures.first?.platformName ?? ""

        return .init(
            platformName: platformName,
            cellItems: cellItems
        )
    }
}
