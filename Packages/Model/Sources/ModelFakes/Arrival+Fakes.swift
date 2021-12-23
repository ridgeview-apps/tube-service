import Foundation
import Model

// MARK: - Arrival
public extension Arrival {
    
    enum FakeType {
        case line(TrainLine, to: FakeValue.DestinationName, arrivingIn: TimeInterval)
    }
    
    enum FakeTypes {
        case multiLine
        case multiLineEastbound
        case multiLineWestbound
        case singleLine
        case singleLineNorthbound
        case singleLineSouthbound
    }
    
    enum FakeValue {
        public enum DestinationName: String {
            case mordenViaBank = "Morden (via Bank)"
            case kenningtonViaCharingX = "Kennington (via Charing X)"
            case highBarnet = "High Barnet"
            case edgware = "Edgware"
        }
        
        public enum PlatformName: String {
            case platform1 = "Platform 1"
            case platform2 = "Platform 2"
        }
    }
    
    static func fake(ofType fakeType: FakeType,
                     on platformName: FakeValue.PlatformName = .platform1) -> Self {
        switch fakeType {
        case let .line(lineId, to: destinationName, arrivingIn: timeToStation):
            return .init(id: "000",
                         lineId: lineId,
                         lineName: lineId.shortName,
                         platformName: platformName.rawValue,
                         towards: nil,
                         destinationName: destinationName.rawValue,
                         currentLocation: nil,
                         timeToStation: Int(timeToStation),
                         destinationNaptanId: nil,
                         naptanId: nil)
        }
    }
    
    
    static func fakes(ofTypes fakeTypes: FakeTypes) -> [Self] {
        func multiLineArrivals() -> [Self] {
            JSONLoader.loadJSON(from: "fake-arrivals-multiline-group")
        }
        
        func singleLineArrivals() -> [Self] {
            JSONLoader.loadJSON(from: "fake-arrivals-singleline-group")
        }
        
        switch fakeTypes {
        case .multiLine:
            return multiLineArrivals()
        case .multiLineEastbound:
            return multiLineArrivals().filter { $0.platformName == "Eastbound - Platform 2" }
        case .multiLineWestbound:
            return multiLineArrivals().filter { $0.platformName == "Westbound - Platform 1" }
        case .singleLine:
            return singleLineArrivals()
        case .singleLineNorthbound:
            return singleLineArrivals().filter { $0.platformName == "Northbound - Platform 7" }
        case .singleLineSouthbound:
            return singleLineArrivals().filter { $0.platformName == "Southbound - Platform 8" }
        }
    }
}

public extension Sequence where Element == Arrival {
    
    static func fakes(ofTypes fakeTypes: Arrival.FakeTypes) -> [Arrival] {
        Arrival.fakes(ofTypes: fakeTypes)
    }
}
