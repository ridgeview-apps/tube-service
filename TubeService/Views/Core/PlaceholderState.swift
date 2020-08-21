extension Station {
    static let placeholder = Self(id: "", name: "", arrivalsGroups: [])
}

extension Station.ArrivalsGroup {
    static let placeholder = Self(atcoCode: "", lineIds: [])
}

extension ArrivalsBoardsList.ViewState {
    static let placeholder = Self(id: .init(station: .placeholder, arrivalsGroup: .placeholder))
}

extension LineStatus {
    static let placeholder = Self(id: .northern, serviceDetails: [])
}

extension LineStatusDetail.ViewState {
    static let placeholder = Self(lineStatus: .placeholder)
}
