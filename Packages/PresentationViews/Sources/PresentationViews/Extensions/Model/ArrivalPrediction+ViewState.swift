import Models

extension ArrivalPrediction {
    
    func toArrivalsBoardCellItem(withArrivalNumber arrivalNumber: Int) -> ArrivalsBoardCellItem? {
        guard let id, let lineID else {
            return nil
        }
        
        let cellID = "\(id)-\(arrivalNumber)"
        
        let topTrailingTextItem = [countdownTextItem].compactMap { $0 }
        
        return .init(
            id: cellID,
            numberLabel: .init(value: arrivalNumber,
                               backgroundColor: lineID.backgroundColor,
                               textColor: lineID.textColor,
                               textShadow: lineID.textShadow),
            destinationText: destinationTextItem,
            topTrailingTextItems: topTrailingTextItem,
            bottomLeadingTextItem: currentLocationTextItem
        )

    }
    
    private var terminatesHere: Bool {
        guard let naptanID, let destinationNaptanID else {
            return false
        }
        return naptanID == destinationNaptanID
    }
    
    private var destinationTextItem: ArrivalsBoardTextItem {
        let textStyle = ArrivalsBoardTextItem.Style.header()
        let checkFrontOfTrain = ArrivalsBoardTextItem.localizedMessage(.arrivalsCheckFrontOfTrain,
                                                                       style: textStyle)

        
        if terminatesHere {
            return checkFrontOfTrain
        } else if let towards, !towards.isEmpty {
            return .verbatimMessage(towards, style: textStyle)
        } else if let destinationName, !destinationName.isEmpty {
            return .verbatimMessage(destinationName, style: textStyle)
        } else {
            return checkFrontOfTrain
        }
    }
    
    private var currentLocationTextItem: ArrivalsBoardTextItem? {
        guard let currentLocation else { return nil }
        return .verbatimMessage(currentLocation, style: .footerSmall())
    }
    
    private var countdownTextItem: ArrivalsBoardTextItem? {
        return .countdownSeconds(timeToStation, style: .header())
    }
}

extension Sequence where Element == ArrivalPrediction {
    
    func sortedByArrivalTime() -> [Element] {
        sorted {
            $0.timeToStation ?? 0 < $1.timeToStation ?? 0
        }
    }
    
    public func toPlatformBoardStates() -> [ArrivalsBoardState] {
        let arrivalsPerPlatform = Dictionary(grouping: self, by: \.platformName)
        
        return arrivalsPerPlatform
            .map { _, arrivals in
                singlePlatformBoardState(for: arrivals)
            }
            .sorted { $0.platformName < $1.platformName }
    }
    
    private func singlePlatformBoardState(for arrivals: [ArrivalPrediction]) -> ArrivalsBoardState {
        let sortedArrivals = arrivals.sortedByArrivalTime()
        
        let cellItems = sortedArrivals.enumerated().compactMap { idx, element in
            element.toArrivalsBoardCellItem(withArrivalNumber: idx + 1)
        }
        
        let platformName = sortedArrivals.first?.platformName ?? ""
        
        return .init(platformName: platformName,
                     cellItems: cellItems)
    }
}
