import Foundation
import ComposableArchitecture
import DataClients
import DeviceKit
import Shared

@dynamicMemberLookup
struct BaseEnvironment<Environment> {
    var date: () -> Date
    var featureEnvironment: Environment
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
    var mainBundle: Bundle
    var currentLocale: Locale
    var currentDevice: Device
    var appConfig: AppConfig
    var dataClients: DataClients
    
    subscript<Dependency>(
        dynamicMember keyPath: WritableKeyPath<Environment, Dependency>
    ) -> Dependency {
        get { self.featureEnvironment[keyPath: keyPath] }
        set { self.featureEnvironment[keyPath: keyPath] = newValue }
    }
            
    /// Transforms the underlying wrapped environment.
    func map<NewEnvironment>(
        _ transform: @escaping (Environment) -> NewEnvironment
    ) -> BaseEnvironment<NewEnvironment> {
        .init(
            date: self.date,
            featureEnvironment: transform(self.featureEnvironment),
            mainQueue: self.mainQueue,
            uuid: self.uuid,
            mainBundle: self.mainBundle,
            currentLocale: self.currentLocale,
            currentDevice: self.currentDevice,
            appConfig: self.appConfig,
            dataClients: self.dataClients
        )
    }
}

// MARK: - Real instance
extension BaseEnvironment {
    
    static var real: BaseEnvironment<Void> {
        .init(date: Date.init,
              featureEnvironment: (),
              mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
              uuid: UUID.init,
              mainBundle: Bundle.main,
              currentLocale: Locale.current,
              currentDevice: Device.current,
              appConfig: .real,
              dataClients: .real)
    }
}

enum AppLaunchMode: String {
    case normal
    case fake
}

// MARK: - Fake instance(s)
#if DEBUG
extension BaseEnvironment {
    
    static var fake: BaseEnvironment<Void> {
        .init(date: Date.init,
              featureEnvironment: (),
              mainQueue: DispatchQueue.immediate.eraseToAnyScheduler(),
              uuid: UUID.init,
              mainBundle: Bundle.main,
              currentLocale: Locale.current,
              currentDevice: Device.current,
              appConfig: .fake,
              dataClients: .fake)
    }
}
#endif
