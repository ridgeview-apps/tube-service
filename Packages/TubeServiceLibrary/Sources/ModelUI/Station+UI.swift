import Model

public extension Station  {
    var sortedLines: [TrainLine] {
        Set(arrivalsGroups.flatMap { $0.sortedLineIds }).sortedByName()
    }
}

public extension Station.ArrivalsGroup {
    
    var title: String {
        lineIds.toShortNamesTitle()
    }
    
    var sortedLineIds: [TrainLine] {
        lineIds.sortedByName()
    }
}

public extension Sequence where Element == Station {
    func sortedByName() -> [Station] {
        self.sorted(by: { $0.name < $1.name })
    }
}

public extension Sequence where Element == Station.ArrivalsGroup {
    func sortedByTitle() -> [Station.ArrivalsGroup] {
        sorted(by: { $0.title < $1.title })
    }
}
