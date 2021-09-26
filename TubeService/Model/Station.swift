import ComposableArchitecture

struct Station: Identifiable, Equatable, Hashable, Codable {
    let id: String
    let name: String
    let arrivalsGroups: IdentifiedArrayOf<ArrivalsGroup>
    
    var sortedLines: [TrainLine] {
        Set(arrivalsGroups).flatMap { $0.sortedLineIds }.sortedByName()
    }
    
    var sortedArrivalsGroups: IdentifiedArrayOf<ArrivalsGroup> {
        IdentifiedArrayOf(uniqueElements: arrivalsGroups.sortedByTitle())
    }
}

extension Station {
    
    struct ArrivalsGroup: Hashable, Identifiable, Equatable, Codable {
        let atcoCode: String
        let lineIds: [TrainLine]
                
        var id: String {
            "\(atcoCode)-\(lineIds.toId())"
        }
        
        var title: String {
            lineIds.toTitle()
        }
        
        var sortedLineIds: [TrainLine] {
            lineIds.sortedByName()
        }
    }
    
    func arrivalsBoardsListId(at index: Int) -> ArrivalsBoardsList.Id {
        .init(station: self, arrivalsGroup: arrivalsGroups[index])
    }
}

extension Sequence where Element == Station {
    func sortedByName() -> [Station] {
        self.sorted(by: { $0.name < $1.name })
    }
}

extension Sequence where Element == TrainLine {
    func sortedByName() -> [TrainLine] {
        self.sorted(by: { $0.shortName < $1.shortName })
    }
    
    func toTitle() -> String {
        self.sortedByName().map { $0.shortName }.joined(separator: ", ")
    }
    
    func toId() -> String {
        self.sortedByName().map { $0.rawValue }.joined(separator: ",")
    }
}

extension Sequence where Element == Station.ArrivalsGroup {
    func sortedByTitle() -> [Station.ArrivalsGroup] {
        self.sorted(by: { $0.title < $1.title })
    }
}
