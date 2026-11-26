import Models
import Shared

extension BusArrival {

    func toArrivalsBoardCellItem(withArrivalNumber arrivalNumber: Int) -> ArrivalsBoardCellItem? {
        guard let id, let lineName else { return nil }
        return .init(
            id: "\(id)-\(arrivalNumber)",
            numberLabel: .init(
                text: lineName,
                width: .route,
                backgroundColor: .bus,
                textColor: .white,
                textShadow: (color: .clear, radius: 0, x: 0, y: 0)
            ),
            headerRow: .init(
                style: .tube,
                destination: .towards(destinationName ?? towards ?? ""),
                countdownText: CountdownTextFormatter.formattedText(forSeconds: timeToStation),
                needsStrikethrough: false
            ),
            footerRow: nil
        )
    }
}

extension Sequence where Element == BusArrival {

    /// One board for the stop, soonest first, or none without arrivals so the board's empty state shows.
    public func toBoardStates(at stop: BusStop, route: String?) -> [ArrivalsBoardState] {
        let cellItems =
            filter { route == nil || $0.lineName == route }
            .sorted { $0.timeToStation ?? 0 < $1.timeToStation ?? 0 }
            .enumerated()
            .compactMap { index, arrival in arrival.toArrivalsBoardCellItem(withArrivalNumber: index + 1) }
        guard !cellItems.isEmpty else { return [] }
        return [ArrivalsBoardState(platformName: stop.boardTitle, cellItems: cellItems, style: .bus)]
    }

    /// The stop's routes, then any others that turn up in the arrivals.
    public func routes(at stop: BusStop) -> [String] {
        let liveRoutes = compactMap(\.lineName).removingDuplicates().sorted { $0.localizedStandardCompare($1) == .orderedAscending }
        return stop.routes + liveRoutes.filter { !stop.routes.contains($0) }
    }
}

extension BusStop {
    var boardTitle: String {
        letter.map { String(localized: .busStopLetter($0)) } ?? name
    }
}
