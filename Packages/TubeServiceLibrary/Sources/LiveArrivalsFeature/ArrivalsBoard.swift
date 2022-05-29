import ComposableArchitecture
import Model
import Shared

public enum ArrivalsBoard {
    
    public enum RowType: Equatable, Identifiable {
        
        case prediction(Arrival)
        case arrivalDeparture(ArrivalDeparture, lineId: TrainLine)
        
        public var id: String {
            switch self {
            case let .prediction(arrival):
                return arrival.id
            case let .arrivalDeparture(arrivalDeparture, lineId):
                return "\(lineId.rawValue)-\(arrivalDeparture.id)"
            }
        }
        
        var platformName: String {
            switch self {
            case let .prediction(arrival):
                return arrival.platformName
            case let .arrivalDeparture(arrivalDeparture, _):
                return arrivalDeparture.platformName ?? ""
            }
        }
        
    }
    
    public enum DestinationType: Equatable {
        case destination(String)
        case checkFrontOfTrain
    }
    
    public enum CountdownTime: Equatable {
        case unknown
        case dueIn(seconds: Int)
    }
    
    // State
    public struct State: Equatable, Identifiable {
        
        public enum AnimationState: Equatable {
            case stopped
            case refreshing
            case rotating
        }
        
        public struct RowState: Identifiable, Equatable {
            public var id: String {
                "\(arrivalNumberText)-\(rowType.id)"
            }

            public let rowType: ArrivalsBoard.RowType
            public let lineId: TrainLine
            public let arrivalNumberText: String
            public let destination: ArrivalsBoard.DestinationType
            public let countdownTime: ArrivalsBoard.CountdownTime
            
            public init(station: Station,
                        rowIndex: Int,
                        arrival: Arrival) {
                self = .init(station: station,
                             rowIndex: rowIndex,
                             rowType: .prediction(arrival))
            }
            
            public init(station: Station,
                        rowIndex: Int,
                        rowType: ArrivalsBoard.RowType) {
                self.rowType = rowType
                self.arrivalNumberText = "\(rowIndex + 1)"
                
                switch rowType {
                case .prediction(let arrival):
                    self.destination = arrival.destination
                    self.countdownTime = arrival.countdownTime
                    self.lineId = arrival.lineId
                case let .arrivalDeparture(arrivalDeparture, lineId):
                    self.destination = arrivalDeparture.destination
                    self.countdownTime = arrivalDeparture.countdownTime
                    self.lineId = lineId
                }
            }
        }
        
        public var id: String {
            "\(station.name)-\(platformTitleText)"
        }
        
        public var arrivals: [ArrivalsBoard.RowType]
        public var isExpanded: Bool
        public var collapsedBoardSize: Int
        
        public var platformTitleText: String {
            arrivals.first.map { $0.platformName } ?? ""
        }
        public var timeText: String
        
        public var isExpandable: Bool {
            arrivals.count > collapsedBoardSize
        }

        public var fixedRows: [RowState] = []
        public var rotatingRow: RowState?
        public var rotatingRowIndex: Int
        public var animationState: AnimationState
        public var manualRotationTimer: Bool
        
        public var isCollapsed: Bool {
            isExpandable && !isExpanded
        }
        
        private let station: Station
        
        public init(station: Station,
                    rowTypes: [ArrivalsBoard.RowType],
                    time: Date,
                    rotatingRowIndex: Int? = nil,
                    isExpanded: Bool,
                    animationState: AnimationState = .stopped,
                    manualRotationTimer: Bool = false,
                    timeFormatter: DateFormatter = .shortTimeStyle,
                    collapsedBoardSize: Int = 3) {
            self.station = station
            self.isExpanded = isExpanded
            self.animationState = animationState
            self.manualRotationTimer = manualRotationTimer
            self.arrivals = rowTypes.sortedByArrivalTime
            self.collapsedBoardSize = collapsedBoardSize
            self.rotatingRowIndex = rotatingRowIndex ?? (collapsedBoardSize - 1)
            self.timeText = timeFormatter.string(from: time)
                        
            refresh(rotate: false)
        }
        
        mutating func refresh(rotate: Bool) {
            if isCollapsed {
                let firstRotatingArrivalIndex = collapsedBoardSize - 1
                let fixedArrivals = arrivals[..<firstRotatingArrivalIndex]
                fixedRows = fixedArrivals.enumerated().map { idx, arrival in
                    RowState(station: station,
                             rowIndex: idx,
                             rowType: arrival)
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
                                       rowType: rotatingArrival)
            } else {
                fixedRows = arrivals.enumerated().map { idx, arrival in
                    RowState(station: station,
                             rowIndex: idx,
                             rowType: arrival)
                }
                rotatingRow = nil
            }
        }
    }
    
    // Action
    public enum Action: Equatable {
        case setAnimationState(to: State.AnimationState)
        case rotateNextArrival
        case setExpanded(Bool)
    }
    
    // Environment
    public struct Environment {
        public var mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(mainQueue: AnySchedulerOf<DispatchQueue>) {
            self.mainQueue = mainQueue
        }
    }
    
    public static let reducer = Reducer<State, Action, Environment>.combine(
        
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
                state.refresh(rotate: true)
                return .none
            case let .setExpanded(isExpanded):
                guard state.isExpanded != isExpanded else {
                    return .none
                }
                state.isExpanded = isExpanded
                state.refresh(rotate: false)
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
    
    var destination: ArrivalsBoard.DestinationType {
        
        guard !terminatesHere else {
            return .checkFrontOfTrain
        }
        
        if let towards = towards, !towards.isEmpty {
            return .destination(towards)
        }
        
        if let destinationName = destinationName, !destinationName.isEmpty {
            return .destination(destinationName)
        }
        
        return .checkFrontOfTrain
    }
    
    var countdownTime: ArrivalsBoard.CountdownTime {
        guard let timeToStation = timeToStation else {
            return .unknown
        }
        
        return .dueIn(seconds: timeToStation)
    }
}

extension ArrivalDeparture {
    
    var trimmedDestinationName: String? {
        destinationName?.replacingOccurrences(of: "Rail Station", with: "").trimmed()
    }
    
    var trimmedStationName: String? {
        stationName?.replacingOccurrences(of: "Rail Station", with: "").trimmed()
    }
    
    var isValidDeparture: Bool {
        return trimmedStationName != trimmedDestinationName
    }
}

private extension ArrivalDeparture {
    
    var destination: ArrivalsBoard.DestinationType {
        
        if let destinationName = trimmedDestinationName, !destinationName.isEmpty {
            return .destination(destinationName)
        }
        
        return .checkFrontOfTrain
    }
    
    var secondsToDeparture: Int? {
        guard let minutesAndSecondsToDeparture = minutesAndSecondsToDeparture else {
            return nil
        }
        
        let minuteAndSecondComps = minutesAndSecondsToDeparture.components(separatedBy: ":").compactMap { Int($0) }
        
        guard minuteAndSecondComps.count == 2 else { return nil }
        
        let minutes = minuteAndSecondComps[0]
        let seconds = minuteAndSecondComps[1]
        
        return (minutes * 60) + seconds
        
    }
    
    var countdownTime: ArrivalsBoard.CountdownTime {
        guard let secondsToDeparture = secondsToDeparture else {
            return .unknown
        }

        return .dueIn(seconds: secondsToDeparture)
    }
    
}

extension Sequence where Element == ArrivalsBoard.RowType {
    var sortedByArrivalTime: [Element] {
        sorted { lhs, rhs in
            switch (lhs, rhs) {
            case let (.prediction(lhsArrival), .prediction(rhsArrival)):
                return lhsArrival.timeToStation ?? 0 < rhsArrival.timeToStation ?? 0
            case let (.arrivalDeparture(lhsArrivalDeparture, _), .arrivalDeparture(rhsArrivalDeparture, _)):
                return lhsArrivalDeparture.scheduledTimeOfDeparture ?? .distantPast < rhsArrivalDeparture.scheduledTimeOfDeparture ?? .distantPast
            default:
                return false
            }
        }
    }
}
