import DataClients
import SwiftUI

@main
struct RootScene: App {
    
    @StateObject private var appModel = makeAppModel()
    
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .environmentObject(appModel)
                .withEnvironmentObjects(lineStatus: appModel.lineStatus,
                                        stations: appModel.stations,
                                        userPreferences: appModel.userPreferences,
                                        location: appModel.location)
        }
    }
    
    private static func makeAppModel() -> AppModel {
#if DEBUG
        if ProcessInfo.isRunningUITests { return .stub() }
#endif
        
        return .real()
    }
}


extension View {
    
    func withEnvironmentObjects(lineStatus: LineStatusModel,
                                stations: StationsModel,
                                userPreferences: UserPreferencesModel,
                                location: LocationModel) -> some View {
        self
            .environmentObject(lineStatus)
            .environmentObject(stations)
            .environmentObject(userPreferences)
            .environmentObject(location)
    }
}
