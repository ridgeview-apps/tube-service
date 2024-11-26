import SwiftUI
import Models

public extension TrainLineID {
    
    var backgroundColor: Color {
        switch self {
        case .bakerloo:
            return .bakerlooLine
        case .central:
            return .centralLine
        case .circle:
            return .circleLine
        case .district:
            return .districtLine
        case .elizabeth:
            return .elizabethLine
        case .hammersmithAndCity:
            return .hammersmithAndCityLine
        case .jubilee:
            return .jubileeLine
        case .liberty:
            return .libertyLine
        case .lioness:
            return .lionessLine
        case .metropolitan:
            return .metropolitanLine
        case .mildmay:
            return .mildmayLine
        case .northern:
            return .northernLine
        case .piccadilly:
            return .piccadillyLine
        case .suffragette:
            return .suffragetteLine
        case .victoria:
            return .victoriaLine
        case .waterlooAndCity:
            return .waterlooAndCityLine
        case .weaver:
            return .weaverLine
        case .windrush:
            return .windrushLine
        case .dlr:
            return .dlr
        case .tram:
            return .tram
        case .overground:
            return .overground
        }
    }
    
    var textColor: Color {
        switch self {
        case .bakerloo, .central, .district, .elizabeth, .jubilee, .liberty, .metropolitan, .mildmay, .northern, .piccadilly, .tram, .weaver, .windrush:
            return .white
        case .circle, .dlr, .hammersmithAndCity, .lioness, .suffragette, .victoria, .waterlooAndCity, .overground:
            return .black
        }
    }
    
    var textShadow: TextShadowSettings {
        switch self {
        case .bakerloo, .central, .district, .elizabeth, .jubilee, .liberty, .metropolitan, .mildmay, .northern, .piccadilly, .tram, .weaver, .windrush:
            return (color: .clear, radius: 0, x: 0, y: 0)
        case .circle, .dlr, .hammersmithAndCity, .lioness, .suffragette, .victoria, .waterlooAndCity, .overground:
            return (color: .white, radius: 0.5, x: 0, y: 0.5)
        }
    }
        
    var longName: String {
        switch self {
        case .dlr, .overground, .tram:
            return name
        case .bakerloo, .central, .circle, .district, .elizabeth, .hammersmithAndCity, .jubilee, .liberty, .lioness, .metropolitan,
                .mildmay, .northern, .piccadilly, .suffragette, .victoria, .waterlooAndCity, .weaver, .windrush:
            return "\(name) line"
        }
    }
    
    var twitterSearchNameFilter: String? {
        switch self {
        case .bakerloo, .central, .circle, .district, .elizabeth, .hammersmithAndCity, .jubilee, .liberty, .lioness, .metropolitan,
                .mildmay, .northern, .piccadilly, .suffragette, .victoria, .waterlooAndCity, .weaver, .windrush:
            return "\(rawValue) line"
        case .tram, .dlr:
            return rawValue
        case .overground:
            return nil
        }
    }

    var shouldShowFilteredTweets: Bool {
        switch self {
        case .bakerloo, .central, .circle, .district, .elizabeth, .hammersmithAndCity, .jubilee, .liberty, .lioness, .metropolitan,
                .mildmay, .northern, .piccadilly, .suffragette, .victoria, .waterlooAndCity, .weaver, .windrush, .tram, .dlr:
            return true
        case .overground:
            return false
        }
    }
}

public extension Sequence where Element == TrainLineID {
    func sortedByName() -> [TrainLineID] {
        self.sorted(by: { $0.name < $1.name })
    }
}
