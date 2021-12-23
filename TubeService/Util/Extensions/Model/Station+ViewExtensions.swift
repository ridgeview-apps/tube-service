import ComposableArchitecture
import Model

extension Station  {
    var sortedLines: [TrainLine] {
        Set(arrivalsGroups.flatMap { $0.sortedLineIds }).sortedByName()
    }
    
    var sortedArrivalsGroups: IdentifiedArrayOf<ArrivalsGroup> {
        IdentifiedArrayOf(uniqueElements: arrivalsGroups.sortedByTitle())
    }
    
    func arrivalsBoardsListId(at index: Int) -> ArrivalsBoardsList.Id {
        .init(station: self, arrivalsGroup: arrivalsGroups[index])
    }
}

extension Station.ArrivalsGroup {
    
    var title: String {
        lineIds.toTitle()
    }
    
    var sortedLineIds: [TrainLine] {
        lineIds.sortedByName()
    }
}

extension Sequence where Element == Station {
    func sortedByName() -> [Station] {
        self.sorted(by: { $0.name < $1.name })
    }
}

extension Sequence where Element == TrainLine {
    func toTitle() -> String {
        self.sortedByName().map { $0.shortName }.joined(separator: ", ")
    }
}

extension Sequence where Element == Station.ArrivalsGroup {
    func sortedByTitle() -> [Station.ArrivalsGroup] {
        self.sorted(by: { $0.title < $1.title })
    }
}
