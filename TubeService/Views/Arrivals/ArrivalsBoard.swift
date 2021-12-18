import ComposableArchitecture
import Model
import RidgeviewCore

enum ArrivalsBoard {

    // State
    struct ViewState: Equatable, Identifiable {
        
        enum AnimationState: Equatable {
            case stopped
            case refreshing
            case rotating
        }
        
        struct RowState: Identifiable, Equatable {
            var id: String {
                "\(arrivalNumberText)-\(destinationText)-\(arrivalTimeText)"
            }
            
            let lineId: TrainLine
            let arrivalNumberText: String
            let destinationText: String
            let arrivalTimeText: String
            let locationText: String?
            
            init(station: Station,
                 rowIndex: Int,
                 arrival: Arrival,
                 localizer: StringLocalizer) {
                self.arrivalNumberText = "\(rowIndex + 1)."
                self.destinationText = arrival.destinationText(localizedBy: localizer,
                                                               stationName: station.name)
                self.arrivalTimeText = arrival.arrivalTimeText(localizedBy: localizer)
                self.locationText = arrival.currentLocation
                self.lineId = arrival.lineId
            }
        }
        
        var id: String {
            "\(station.name)-\(platformTitleText)"
        }
        
        var arrivals: [Arrival]
        var isExpanded: Bool
        var collapsedBoardSize: Int
        
        var platformTitleText: String {
            arrivals.first.map { $0.platformName } ?? ""
        }
        var timeText: String
        
        var isExpandable: Bool {
            arrivals.count > collapsedBoardSize
        }

        var fixedRows: [RowState] = []
        var rotatingRow: RowState?
        var rotatingRowIndex: Int
        var animationState: AnimationState
        var manualRotationTimer: Bool
        
        var isCollapsed: Bool {
            isExpandable && !isExpanded
        }
        
        private let station: Station
        
        init(station: Station,
             arrivals: [Arrival],
             time: Date,
             localizer: StringLocalizer,
             rotatingRowIndex: Int? = nil,
             isExpanded: Bool,
             animationState: AnimationState = .stopped,
             manualRotationTimer: Bool = false,
             timeFormatter: DateFormatter = .shortTime,
             collapsedBoardSize: Int = 3) {
            self.station = station
            self.isExpanded = isExpanded
            self.animationState = animationState
            self.manualRotationTimer = manualRotationTimer
            self.arrivals = arrivals.sortedByArrivalTime
            self.collapsedBoardSize = collapsedBoardSize
            self.rotatingRowIndex = rotatingRowIndex ?? (collapsedBoardSize - 1)
            self.timeText = timeFormatter.string(from: time)
                        
            refresh(localizer: localizer, rotate: false)
        }
        
        mutating func refresh(localizer: StringLocalizer,
                              rotate: Bool) {
            if isCollapsed {
                let firstRotatingArrivalIndex = collapsedBoardSize - 1
                let fixedArrivals = arrivals[..<firstRotatingArrivalIndex]
                fixedRows = fixedArrivals.enumerated().map { idx, arrival in
                    RowState(station: station,
                             rowIndex: idx,
                             arrival: arrival,
                             localizer: localizer)
                }
                
                if rotate {
                    rotatingRowIndex += 1
                }
                
                if !arrivals.indices.contains(rotatingRowIndex) {
                    rotatingRowIndex = firstRotatingArrivalIndex
                }
                
                let rotatingArrival = arrivals[rotatingRowIndex]
                rotatingRow = RowState(station: station,
                                       rowIndex: rotatingRowIndex,
                                       arrival: rotatingArrival,
                                       localizer: localizer)
            } else {
                fixedRows = arrivals.enumerated().map { idx, arrival in
                    RowState(station: station,
                             rowIndex: idx,
                             arrival: arrival,
                             localizer: localizer)
                }
                rotatingRow = nil
            }
        }
    }
    
    typealias State = BaseState<ViewState>

    // Action
    enum Action: Equatable {
        case setAnimationState(to: ViewState.AnimationState)
        case rotateNextArrival
        case setExpanded(Bool)
    }
    
    // Environment
    typealias Environment = Root.Environment
    
    static let reducer = Reducer<ViewState, Action, Environment>.combine(
        
        Reducer { state, action, env in
            switch action {
            case let .setAnimationState(toState):
                guard state.animationState != toState else {
                    return .none
                }
                state.animationState = toState

                guard !state.manualRotationTimer else {
                    return .none
                }
                
                switch state.animationState {
                case .stopped, .refreshing:
                    // print("Cancel timer \(state.id)")
                    return Effect.cancel(id: state.id)
                case .rotating:
                    // print("Start timer \(state.id)")
                    return Effect
                            .timer(id: state.id,
                                   every: 3,
                                   tolerance: .zero,
                                   on: env.mainQueue)
                            .map { _ in .rotateNextArrival }
                }
            case .rotateNextArrival:
                guard state.isCollapsed && state.animationState == .rotating else {
                    return .none
                }
                // print("Board \(state.id) timer triggered (active)")
                state.refresh(localizer: env.stringLocalizer, rotate: true)
                return .none
            case let .setExpanded(isExpanded):
                guard state.isExpanded != isExpanded else {
                    return .none
                }
                state.isExpanded = isExpanded
                state.refresh(localizer: env.stringLocalizer, rotate: false)
                return .none
            }
        }
    )
    
}

private extension Arrival {
    
    var terminatesHere: Bool {
        guard let naptanId = naptanId,
              let destinationNaptanId = destinationNaptanId else {
            return false
        }
        return naptanId == destinationNaptanId
    }
    
    func destinationText(localizedBy localizer: StringLocalizer,
                         stationName: String) -> String {
        
        let checkFrontOfTrain = localizer.localized("arrivals.check.front.of.train")
        
        guard !terminatesHere else {
            return checkFrontOfTrain
        }
        
        if let towards = towards, !towards.isEmpty {
            return towards
        }
        
        if let destinationName = destinationName, !destinationName.isEmpty {
            return destinationName
        }
        
        return checkFrontOfTrain
    }
    
    func arrivalTimeText(localizedBy localizer: StringLocalizer) -> String {
        guard let timeToStation = timeToStation else {
            return localizer.localized("arrivals.time.unknown")
        }
        
        switch timeToStation {
        case _ where timeToStation == 0:
            return localizer.localized("arrivals.time.due")
        case _ where timeToStation < 30:
            let prefix = localizer.localized("arrivals.time.due")
            let suffix = localizer.localized("arrivals.time.seconds.short")
            return "\(prefix) (\(timeToStation)\(suffix))"
        case _ where timeToStation < 60:
            let suffix = localizer.localized("arrivals.time.seconds.medium")
            return "\(timeToStation) \(suffix)"
        default:
            let minutes = timeToStation / 60
            
            let minSuffix = localizer.localized("arrivals.time.seconds.min")
            let minsSuffix = localizer.localized("arrivals.time.seconds.mins")
            
            return "\(minutes) \(minutes == 1 ? minSuffix : minsSuffix)"
        }
    }
}


extension Sequence where Element == Arrival {
    var sortedByArrivalTime: [Element] {
        self.sorted { $0.timeToStation ?? 0 < $1.timeToStation ?? 0 }
    }
}
