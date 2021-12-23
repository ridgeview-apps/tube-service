import Foundation
import ComposableArchitecture
import DataClients
import Model
import RidgeviewCore


// MARK: - Shared.State
extension Global.State {
    static func fake(userPreferences: UserPreferences = .fake()) -> Global.State {
        .init(userPreferences: userPreferences)
    }
}

extension UserPreferences {
    static func fake(favourites: Set<Station.ArrivalsGroup.ID> = [],
                     lastUsedFilterOption: ArrivalsPickerFilterOption = .all,
                     preferredBrowserType: UserPreferences.BrowserType = .inApp) -> UserPreferences {
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
              statuses: IdentifiedArrayOf(uniqueElements: statuses))
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
    static func fake(
        selectedFilterOption: UserPreferences.ArrivalsPickerFilterOption = .all,
        selectableStations: [Station] = .fakes().sortedByName()
    ) -> ArrivalsPicker.ViewState {
        .init(selectedFilterOption: selectedFilterOption,
              selectableStations: IdentifiedArrayOf(uniqueElements: selectableStations))
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
              boards: IdentifiedArrayOf(uniqueElements: boards),
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
