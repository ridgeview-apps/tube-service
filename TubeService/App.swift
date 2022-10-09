import DataClients
import SwiftUI

@main
struct RootScene: App {
    
    @StateObject private var appModel = AppModel.real()
    
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .environmentObject(appModel)
                .withEnvironmentObjects(lineStatus: appModel.lineStatus,
                                        stations: appModel.stations,
                                        userPreferences: appModel.userPreferences)
        }
    }
}


extension View {
    
    func withEnvironmentObjects(lineStatus: LineStatusModel,
                                stations: StationsModel,
                                userPreferences: UserPreferencesModel) -> some View {
        self
            .environmentObject(lineStatus)
            .environmentObject(stations)
            .environmentObject(userPreferences)
    }
}
