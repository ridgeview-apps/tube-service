import Models

extension ArrivalPrediction {
    
    func toArrivalsBoardCellItem(withArrivalNumber arrivalNumber: Int) -> ArrivalsBoardCellItem? {
        guard let id, let lineID else {
            return nil
        }
        
        let cellID = "\(id)-\(arrivalNumber)"
        
        var subtitleType: ArrivalsBoardSubtitleType?
        if let currentLocation {
            subtitleType = .currentLocationName(currentLocation)
        }
        
        return .init(id: cellID,
                     numberLabel: .init(value: arrivalNumber,
                                        backgroundColor: lineID.backgroundColor,
                                        textColor: lineID.textColor,
                                        textShadow: lineID.textShadow),
                     destinationType: destinationType,
                     secondsToArrival: timeToStation,
                     subtitleType: subtitleType)

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
            return .destination(towards)
        } else if let destinationName, !destinationName.isEmpty {
            return .destination(destinationName)
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
            .map { platformName, arrivals in
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
