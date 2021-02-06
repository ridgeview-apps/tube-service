import SwiftUI

@main
struct RootScene: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView(
                store: ProcessInfo.launchMode.rootStore
            )
            .launchModeOverlay()
        }
    }
}

private extension AppLaunchMode {
    
    var rootStore: RootStore {
        let rootEnv: Root.Environment
        
    #if DEBUG
        switch self {
        case .normal:
            rootEnv = .real
        case .preview:
            rootEnv = .preview
        case .unitTest:
            rootEnv = .unitTest
        }
    #else
        rootEnv = .real
    #endif
        
        return RootStore(initialState: .init(),
                         reducer: Root.reducer,
                         environment: rootEnv)
    }
}

private extension View {
    func launchModeOverlay() -> some View {
        #if DEBUG
        if ProcessInfo.launchMode != .normal {
            return self.overlay(
                Text("\(ProcessInfo.launchMode.rawValue.uppercased()) MODE")
                    .font(.title)
            ).eraseToAnyView()
        }
        #endif
        
        return self.eraseToAnyView()
    }
}

// MARK: - AppDelegate
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        startServices()
        
        return true
    }
    
    private func startServices() {
        
    #if ADHOC_BUILD || RELEASE_BUILD
        let config = AppConfig.real
        AppCenter.start(withAppSecret: config.appCenter.appSecret, services: [Analytics.self, Crashes.self])
    #endif
        
    }
    
}
