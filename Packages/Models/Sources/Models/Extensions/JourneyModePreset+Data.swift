public extension JourneyModePreset {

    var modeIDs: Set<ModeID> {
        switch self {
        case .trainAndBus:
            [.tube, .dlr, .elizabethLine, .overground, .nationalRail, .tram, .bus]
        case .trainOnly:
            [.tube, .dlr, .elizabethLine, .overground, .nationalRail, .tram]
        case .busOnly:
            [.bus]
        case .custom(let modeIDs):
            modeIDs
        }
    }

    var isCustom: Bool {
        if case .custom = self { return true }
        return false
    }
}
