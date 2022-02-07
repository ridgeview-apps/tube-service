import ComposableArchitecture
import AppLibrary
import LineStatusFeature
import LiveArrivalsFeature
import SettingsFeature

typealias RootStore = Store<Root.State, Root.Action>
typealias LineStatusTabStore = Store<LineStatusTab.State, LineStatusTab.Action>
typealias ArrivalsTabStore = Store<ArrivalsTab.State, ArrivalsTab.Action>
typealias SettingsTabStore = Store<SettingsTab.State, SettingsTab.Action>

extension RootStore {
    
    var lineStatusTabStore: LineStatusTabStore {
        self.scope(state: \.lineStatusTabState,
                   action: Root.Action.lineStatusTab)
    }
    
    var arrivalsTabStore: ArrivalsTabStore {
        self.scope(state: \.arrivalsTabState,
                   action: Root.Action.arrivalsTab)
    }
    
    var settingsTabStore: SettingsTabStore {
        self.scope(state: \.settingsTabState,
                   action: Root.Action.settingsTab)
    }
}

extension SettingsTabStore {
    
    var settingsStore: SettingsStore {
        self.scope(state: \.settingsState,
                   action: SettingsTab.Action.settings)
    }

}

extension LineStatusTabStore {
    
    var lineStatusListStore: LineStatusListStore {
        self.scope(state: \.lineStatusListState,
                   action: LineStatusTab.Action.lineStatusList)
    }
}

extension ArrivalsTabStore {
    
    var arrivalsPickerStore: ArrivalsPickerStore {
        self.scope(state: \.arrivalsPickerState,
                   action: ArrivalsTab.Action.arrivalsPicker)
    }
}
