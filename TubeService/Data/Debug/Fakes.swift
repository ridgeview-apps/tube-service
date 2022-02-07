import Foundation
import ComposableArchitecture
import DataClients
import Model
import LineStatusFeature
import LiveArrivalsFeature
import SettingsFeature

// MARK: - Root fakes
extension RootStore {
    static func fake() -> RootStore {
        RootStore(initialState: .init(),
                 reducer: Root.reducer,
                 environment: .fake)
    }
}

// MARK: - LineStatusTab fakes
extension LineStatusTab.State {
    static func fake(lineStatusListState: LineStatusList.State = .fake()) -> LineStatusTab.State {
        .init(lineStatusListState: lineStatusListState)
    }
}

extension LineStatusTabStore {
    static func fake() -> LineStatusTabStore {
        .init(initialState: .fake(),
              reducer: LineStatusTab.reducer,
              environment: .fake)
    }
}

// MARK: - ArrivalsTab fakes
extension ArrivalsTab.State {
    static func fake(arrivalsPickerState: ArrivalsPicker.State = .fake()) -> ArrivalsTab.State {
        .init(arrivalsPickerState: arrivalsPickerState)
    }
}

extension ArrivalsTabStore {
    static func fake() -> ArrivalsTabStore {
        .init(initialState: .fake(),
              reducer: ArrivalsTab.reducer,
              environment: .fake)
    }
}

// MARK: - Settings Fakes

extension SettingsTab.State {
    static func fake(settingsState: Settings.State = .fake()) -> SettingsTab.State {
        .init(settingsState: settingsState)
    }
}

extension SettingsTabStore {
    static func fake() -> SettingsTabStore {
        .init(initialState: .fake(),
              reducer: SettingsTab.reducer,
              environment: .fake)
    }
}
