import Foundation
import Models

extension Sequence where Element == Journey {
    func sanitizedAndSortedByArrivalTime(forModeIDs modeIDs: Set<ModeID>) -> [Journey] {
        filter { $0.isValid(forModeIDs: modeIDs) }
            .sorted { $0.arrivalDateTime ?? .distantPast < $1.arrivalDateTime ?? .distantPast }
    }
}

extension Journey {
    func isValid(forModeIDs modeIDs: Set<ModeID>) -> Bool {
        let isDurationValid = (duration ?? 0) > 0
        guard isDurationValid else { return false }

        // Walking and cycling journeys are returned even when they were not requested.
        let isAllWalking = (legs ?? []).allSatisfy { $0.modeID == .walking }
        if isAllWalking && !modeIDs.contains(.walking) { return false }

        let isAllCycling = (legs ?? []).allSatisfy { $0.modeID == .cycle || $0.modeID == .cycleHire }
        if isAllCycling && !modeIDs.contains(.cycle) { return false }

        return true
    }
}
