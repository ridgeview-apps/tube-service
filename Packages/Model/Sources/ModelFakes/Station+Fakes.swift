import Foundation
import Model

public extension Station {
    
    enum FakeType {
        case highBarnet
        case finchleyCentral
        case boundsGreen
        case kingsCross
        case barkingSide
        case kingsbury
        case paddington
    }
    
    static func fake(ofType fakeType: FakeType) -> Self {
        func find(byId id: String) -> Station {
            fakes().first { $0.id == id }!
        }
        
        switch fakeType {
        case .highBarnet:
            return find(byId: "940GZZLUHBT")
        case .finchleyCentral:
            return find(byId: "940GZZLUFYC")
        case .boundsGreen:
            return find(byId: "940GZZLUBDS")
        case .kingsCross:
            return find(byId: "HUBKGX")
        case .barkingSide:
            return find(byId: "940GZZLUBKE")
        case .kingsbury:
            return find(byId: "940GZZLUKBY")
        case .paddington:
            return find(byId: "HUBPAD")
        }
    }
    
    static func fakes() -> [Station] {
        JSONLoader.loadJSON(from: "fake-stations")
    }
}

public extension Sequence where Element == Station {
    
    static func fakes() -> [Station] {
        Station.fakes()
    }
}
