import SwiftUI
import ComposableArchitecture

struct RootView: View {
    
    let store: RootStore
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            TabView {
                LineStatusTabView(store: self.store.lineStatusTabStore)
                    .tabItem {
                        VStack {
                            Image(systemName: "exclamationmark.circle")
                                .imageScale(.large)
                            Text("status.tab.title")
                        }
                    }.accessibility(identifier: "status.tab.title")
                
                ArrivalsTabView(store: self.store.arrivalsTabStore)
                    .tabItem {
                        VStack {
                            Image(systemName: "tram.fill")
                                .imageScale(.large)
                            Text("arrivals.tab.title")
                        }
                    }
                    .accessibility(identifier: "arrivals.tab.title")
                
                SettingsTabView(store: self.store.settingsTabStore)
                    .tabItem {
                        VStack {
                            Image(systemName: "gear")
                                .imageScale(.large)
                            Text("settings.tab.title")
                        }
                    }
                    .accessibility(identifier: "settings.tab.title")
                
            }
            .onAppear {
                UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance()
                viewStore.send(.onAppear)
            }
        }
    }
    

}

// MARK: - Previews
#if DEBUG
struct RootViewView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: .preview())
    }
}
#endif
