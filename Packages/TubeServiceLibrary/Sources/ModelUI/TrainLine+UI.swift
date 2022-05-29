import Model
import StyleGuide
import SwiftUI

public extension TrainLine {
    
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
        case .metropolitan:
            return .metropolitanLine
        case .northern:
            return .northernLine
        case .piccadilly:
            return .piccadillyLine
        case .victoria:
            return .victoriaLine
        case .waterlooAndCity:
            return .waterlooAndCityLine
        case .dlr:
            return .dlr
        case .tram:
            return .tram
        case .tflRail:
            return .tflRail
        case .overground:
            return .overground
        }
    }
    
    var textColor: Color {
        switch self {
        case .bakerloo, .central, .district, .elizabeth, .jubilee, .metropolitan, .northern, .piccadilly, .tram, .tflRail:
            return .white
        case .circle, .dlr, .hammersmithAndCity, .victoria, .waterlooAndCity, .overground:
            return .black
        }
    }
}

public extension Sequence where Element == TrainLine {
    func toShortNamesTitle() -> String {
        self.sortedByName().map { $0.shortName }.joined(separator: ", ")
    }
}
