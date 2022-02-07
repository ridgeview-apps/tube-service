import ComposableArchitecture
import Model
import Shared

public enum ArrivalsBoard {

    // State
    public struct State: Equatable, Identifiable {
        
        public enum AnimationState: Equatable {
            case stopped
            case refreshing
            case rotating
        }
        
        public struct RowState: Identifiable, Equatable {
            public var id: String {
                "\(arrivalNumberText)-\(arrival.id)"
            }

            public let arrival: Arrival
            public let lineId: TrainLine
            public let arrivalNumberText: String
            public let destination: Arrival.DestinationType
            public let countdownTime: Arrival.CountdownTime
            public let locationText: String?
            
            public init(station: Station,
                        rowIndex: Int,
                        arrival: Arrival) {
                self.arrival = arrival
                self.arrivalNumberText = "\(rowIndex + 1)"
                self.destination = arrival.destination
                self.countdownTime = arrival.countdownTime
                self.locationText = arrival.currentLocation
                self.lineId = arrival.lineId
            }
        }
        
        public var id: String {
            "\(station.name)-\(platformTitleText)"
        }
        
        public var arrivals: [Arrival]
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
                    arrivals: [Arrival],
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
            self.arrivals = arrivals.sortedByArrivalTime
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
                             arrival: arrival)
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
                                       arrival: rotatingArrival)
            } else {
                fixedRows = arrivals.enumerated().map { idx, arrival in
                    RowState(station: station,
                             rowIndex: idx,
                             arrival: arrival)
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

public extension Arrival {
    
    enum DestinationType: Equatable {
        case destination(String)
        case checkFrontOfTrain
    }
    
    enum CountdownTime: Equatable {
        case unknown
        case dueIn(seconds: Int)
    }
}
 
private extension Arrival {
    var terminatesHere: Bool {
        guard let naptanId = naptanId,
              let destinationNaptanId = destinationNaptanId else {
            return false
        }
        return naptanId == destinationNaptanId
    }
    
    var destination: DestinationType {
        
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
    
    var countdownTime: Arrival.CountdownTime {
        guard let timeToStation = timeToStation else {
            return .unknown
        }
        
        return .dueIn(seconds: timeToStation)
    }
}


extension Sequence where Element == Arrival {
    var sortedByArrivalTime: [Element] {
        sorted { $0.timeToStation ?? 0 < $1.timeToStation ?? 0 }
    }
}
