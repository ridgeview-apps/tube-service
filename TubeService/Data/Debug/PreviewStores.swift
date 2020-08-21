import ComposableArchitecture

// MARK: - Preview Stores
extension RootStore {
    static func preview() -> RootStore {
        RootStore(initialState: .init(),
                 reducer: Root.reducer,
                 environment: .preview)
    }
}

extension LineStatusTabStore {
    static func preview() -> LineStatusTabStore {
        .init(initialState: .fake(),
              reducer: LineStatusTab.reducer,
              environment: .preview)
    }
}

extension LineStatusListStore {
    static func preview() -> LineStatusListStore {
        .init(initialState: .fake(),
              reducer: LineStatusList.reducer,
              environment: .preview)
    }
}

extension LineStatusDetailStore {
    static func preview(initialState: LineStatusDetail.State = .fake(ofType: .goodService)) -> LineStatusDetailStore {
        .init(initialState: initialState,
              reducer: LineStatusDetail.reducer,
              environment: .preview)
    }
}

extension ArrivalsBoardsListStore {
    static func preview(viewState: ArrivalsBoardsList.ViewState = .fake(),
                        globalState: Global.State = .fake()) -> ArrivalsBoardsListStore {
        .init(initialState: .fake(globalState: globalState, viewState: viewState),
              reducer: ArrivalsBoardsList.reducer,
              environment: .preview)
    }
}

extension ArrivalsTabStore {
    static func preview() -> ArrivalsTabStore {
        .init(initialState: .fake(),
              reducer: ArrivalsTab.reducer,
              environment: .preview)
    }
}

extension ArrivalsPickerStore {
    static func preview() -> ArrivalsPickerStore {
        .init(initialState: .fake(),
              reducer: ArrivalsPicker.reducer,
              environment: .preview)
    }
}

extension ArrivalsBoardStore {
    static func preview(initialState: ArrivalsBoard.ViewState = .fake(localizer: .real)) -> ArrivalsBoardStore {
        .init(initialState: initialState,
              reducer: ArrivalsBoard.reducer,
              environment: .preview)
    }
}

extension SettingsTabStore {
    static func preview() -> SettingsTabStore {
        .init(initialState: .fake(),
              reducer: SettingsTab.reducer,
              environment: .preview)
    }
}

extension SettingsStore {
    static func preview(viewState: Settings.ViewState = .fake(),
                        globalState: Global.State = .fake()) -> SettingsStore {
        .init(initialState: .fake(globalState: globalState, viewState: viewState),
              reducer: Settings.reducer,
              environment: .preview)
    }

}
