import Models

extension ArrivalPrediction {
    
    func toArrivalsBoardCellItem(withArrivalNumber arrivalNumber: Int) -> ArrivalsBoardCellItem? {
        guard let id, let lineID else {
            return nil
        }
        
        let cellID = "\(id)-\(arrivalNumber)"
        
        var bottomLeadingTextItem: ArrivalsBoardTextItem?
        if let currentLocation {
            bottomLeadingTextItem = .currentPosition(currentLocation)
        }
        
        return .init(id: cellID,
                     numberLabel: .init(value: arrivalNumber,
                                        backgroundColor: lineID.backgroundColor,
                                        textColor: lineID.textColor,
                                        textShadow: lineID.textShadow),
                     topLeadingTextItem: .destinationType(destinationType),
                     topTrailingTextItem: .countdownSeconds(timeToStation),
                     bottomLeadingTextItem: bottomLeadingTextItem,
                     bottomTrailingTextItem: nil)

    }
    
    private var terminatesHere: Bool {
        guard let naptanID, let destinationNaptanID else {
            return false
        }
        return naptanID == destinationNaptanID
    }
    
    private var destinationType: ArrivalsBoardDestinationType {
        if terminatesHere {
            return .checkFrontOfTrain
        } else if let towards, !towards.isEmpty {
            return .known(towards)
        } else if let destinationName, !destinationName.isEmpty {
            return .known(destinationName)
        } else {
            return .checkFrontOfTrain
        }
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
