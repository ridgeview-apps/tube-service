import Foundation
import ComposableArchitecture

private class MocksBundlePin {}

private enum JSONLoader {
    
    private class ThisBundle {}
    
    static func loadJSON<D: Decodable>(from fileName: String) -> D {
        Bundle(for: ThisBundle.self).decodedJSON(from: fileName)!
    }
}

extension Station {
    
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
        let stations: [Station] = JSONLoader.loadJSON(from: "stations")
        return stations.sortedByName()
    }
}

extension Sequence where Element == Station {
    
    static func fakes() -> [Station] {
        Station.fakes()
    }
}

// MARK: - LineStatus
extension LineStatus {
    
    enum FakeType {
        case lineId(TrainLine)
    }
    
    static func fake(ofType fakeType: FakeType = .lineId(.northern),
                     serviceDetails: [LineStatusServiceDetail] = [.fake(ofType: .goodService)]) -> Self {

        switch fakeType {
        case let .lineId(lineId):
            return .init(id: lineId, serviceDetails: serviceDetails)
        }
    }
    
    static func fakes() -> [LineStatus] {
        return JSONLoader.loadJSON(from: "fake-line-statuses")
    }
}

extension Sequence where Element == LineStatus {
    
    static func fakes() -> [LineStatus] {
        LineStatus.fakes()
    }
}

// MARK: - NSError
extension NSError {
    
    enum FakeType {
        case unexpectedError
        case noInternet
    }
    
    static func fake(ofType fakeType: FakeType) -> NSError {
        
        switch fakeType {
        case .unexpectedError:
            return .fake(message: "An unexpected error occurred")
        case .noInternet:
            return .fake(message: "No internet connection")
        }
    }
    
    static func fake(domain: String = "com.fake.error",
                     code: Int = -123,
                     message: String) -> NSError {
        NSError(domain: domain,
                code: code,
                userInfo: [NSLocalizedDescriptionKey: message])
    }
}

// MARK: - LineStatusServiceDetail
extension LineStatusServiceDetail {
    
    enum FakeType {
        case goodService
        case severeDelays
        case plannedClosure
    }
    
    static func fake(ofType fakeType: FakeType) -> LineStatusServiceDetail {
        switch fakeType {
        case .goodService:
            return  .init(statusSeverity: .goodService,
                          statusSeverityDescription: "Good Service",
                          reason: nil)
        case .plannedClosure:
            return .init(statusSeverity: .disrupted,
                         statusSeverityDescription: "Planned closure",
                         reason: "There are planned engineering works on this line.")
        case .severeDelays:
            return .init(statusSeverity: .disrupted,
                         statusSeverityDescription: "Severe delays.",
                         reason: "Severe delays while we try to fix a signal failure. Please use alternative routes where possible. Tickets are being accepted on local buses.")
        }
    }
}

// MARK: - Shared.State
extension Global.State {
    static func fake(userPreferences: UserPreferences = .fake()) -> Global.State {
        .init(userPreferences: userPreferences)
    }
}

extension UserPreferences {
    static func fake(favourites: Set<Station.ArrivalsGroup.ID> = [],
                     lastUsedFilterOption: ArrivalsPicker.ViewState.Filter = .all,
                     preferredBrowserType: Settings.ViewState.BrowserType = .inApp) -> UserPreferences {
        .init(favourites: favourites,
              lastUsedFilterOption: lastUsedFilterOption,
              preferredBrowserType: preferredBrowserType)
    }
}

// MARK: - LineStatusTab.ViewState
extension LineStatusTab.ViewState {
    static func fake(lineStatusListViewState: LineStatusList.ViewState = .fake()) -> LineStatusTab.ViewState {
        .init(lineStatusListViewState: lineStatusListViewState)
    }
}

// MARK: - LineStatusTab.State
extension LineStatusTab.State {
    static func fake(globalState: Global.State = .fake(),
                     viewState: LineStatusTab.ViewState = .fake()) -> LineStatusTab.State {
        .init(globalState: globalState, viewState: viewState)
    }
}

// MARK: - LineStatusList.ViewState
extension LineStatusList.ViewState {
    static func fake(lastRefreshedAt: Date? = nil,
                     isRefreshing: Bool = false,
                     statuses: [LineStatus] = .fakes()) -> LineStatusList.ViewState {
        .init(lastRefreshedAt: lastRefreshedAt,
              isRefreshing: isRefreshing,
              statuses: IdentifiedArrayOf(statuses))
    }
}

// MARK: - LineStatusList.State
extension LineStatusList.State {
    static func fake(globalState: Global.State = .fake(),
                     viewState: LineStatusList.ViewState = .fake()) -> LineStatusList.State {
        .init(globalState: globalState, viewState: viewState)
    }
}

// MARK: - LineStatusDetail.ViewState
extension LineStatusDetail.ViewState {
    static func fake(lineStatus: LineStatus = .fake()) -> LineStatusDetail.ViewState {
        .init(lineStatus: lineStatus)
    }
}

extension LineStatusDetail.ViewState.TwitterLink {
    static func fake(title: String = "FakeLink",
                     url: URL = URL(string: "www.example.com")!) -> Self {
        .init(title: title, url: url)
    }
}

// MARK: - LineStatusDetail.State
extension LineStatusDetail.State {
    
    enum FakeType {
        case goodService
        case plannedClosure
        case severeDelays
        
        var statusDetails: [LineStatusServiceDetail] {
            switch self {
            case .goodService:
                return [.fake(ofType: .goodService)]
            case .plannedClosure:
                return [.fake(ofType: .plannedClosure)]
            case .severeDelays:
                return [.fake(ofType: .severeDelays)]
            }
        }
    }
    
    static func fake(ofType fakeType: FakeType = .goodService,
                     globalState: Global.State = .fake(),
                     for trainLine: TrainLine = .northern) -> Self {

        return .init(globalState: globalState,
                     viewState: .init(lineStatus: .init(id: trainLine,
                                                         serviceDetails: fakeType.statusDetails)))
    }
}

// MARK: - Arrival
extension Arrival {
    
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
        enum DestinationName: String {
            case mordenViaBank = "Morden (via Bank)"
            case kenningtonViaCharingX = "Kennington (via Charing X)"
            case highBarnet = "High Barnet"
            case edgware = "Edgware"
        }
        
        enum PlatformName: String {
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
                         timeToStation: timeToStation.intValue)
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

extension Sequence where Element == Arrival {
    
    static func fakes(ofTypes fakeTypes: Arrival.FakeTypes) -> [Arrival] {
        Arrival.fakes(ofTypes: fakeTypes)
    }
}

// MARK: - ArrivalsTab.State
extension ArrivalsTab.ViewState {
    static func fake(arrivalsPickerViewState: ArrivalsPicker.ViewState = .fake()) -> ArrivalsTab.ViewState {
        .init(arrivalsPickerViewState: arrivalsPickerViewState)
    }
}

// MARK: - ArrivalsTab.State
extension ArrivalsTab.State {
    static func fake(globalState: Global.State = .fake(),
                     viewState: ArrivalsTab.ViewState = .fake()) -> ArrivalsTab.State {
        .init(globalState: globalState, viewState: viewState)
    }
}

// MARK: - ArrivalsPicker.State
extension ArrivalsPicker.ViewState {
    static func fake(selectedFilterOption: ArrivalsPicker.ViewState.Filter = .all,
                     selectableStations: [Station] = .fakes()) -> ArrivalsPicker.ViewState {
        .init(selectedFilterOption: selectedFilterOption,
              selectableStations: IdentifiedArrayOf(selectableStations))
    }
}

extension ArrivalsPicker.State {
    static func fake(globalState: Global.State = .fake(),
                     viewState: ArrivalsPicker.ViewState = .fake()) -> ArrivalsPicker.State {
        .init(globalState: globalState, viewState: viewState)
    }
}


// MARK: - ArrivalsBoard.State
extension ArrivalsBoard.ViewState {
    static func fake(station: Station = .fake(ofType: .kingsCross),
                     arrivals: [Arrival] = .fakes(ofTypes: .singleLineSouthbound),
                     isExpanded: Bool = false,
                     time: Date = .init(),
                     localizer: StringLocalizer) -> ArrivalsBoard.ViewState {
        .init(station: station,
              arrivals: arrivals,
              time: time,
              localizer: localizer,
              isExpanded: isExpanded)
    }
}

// MARK: - ArrivalsBoardList.State
extension ArrivalsBoardsList.ViewState {
    static func fake(station: Station = .fake(ofType: .kingsCross),
                     arrivalsGroupIndex: Int = 0,
                     boards: [ArrivalsBoard.ViewState] = [
                        .fake(arrivals: .fakes(ofTypes: .multiLine), localizer: .real)
                     ],
                     errorMessage: String? = nil) -> ArrivalsBoardsList.ViewState {
        .init(id: .init(station: station, arrivalsGroup: station.arrivalsGroups[arrivalsGroupIndex]),
              boards: IdentifiedArrayOf(boards),
              errorMessage: errorMessage)
    }
}

extension ArrivalsBoardsList.State {
    static func fake(globalState: Global.State = .fake(),
                     viewState: ArrivalsBoardsList.ViewState = .fake()) -> ArrivalsBoardsList.State {
        .init(globalState: globalState, viewState: viewState)
    }
}

// MARK: - SettingsTab.ViewState
extension SettingsTab.ViewState {
    static func fake(settingsViewState: Settings.ViewState = .fake()) -> SettingsTab.ViewState {
        .init(settingsViewState: settingsViewState)
    }
}

// MARK: - SettingsTab.State
extension SettingsTab.State {
    static func fake(globalState: Global.State = .fake(),
                     viewState: SettingsTab.ViewState = .fake()) -> SettingsTab.State {
        .init(globalState: globalState, viewState: viewState)
    }
}

// MARK: - Settings.State
extension Settings.ViewState {
    static func fake() -> Settings.ViewState {
        .init()
    }
}

extension Settings.State {
    static func fake(globalState: Global.State = .fake(),
                     viewState: Settings.ViewState = .fake()) -> Settings.State {
        .init(globalState: globalState, viewState: viewState)
    }
}
