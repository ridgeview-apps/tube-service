import Foundation
import ComposableArchitecture
import DataClients
import DeviceKit
import RidgeviewCore

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
    var stringLocalizer: StringLocalizer
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
            stringLocalizer: self.stringLocalizer,
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
              stringLocalizer: .real,
              dataClients: .real)
    }
}

enum AppLaunchMode: String {
    case normal
    case preview
    case unitTest
}

// MARK: - Fake instance(s)
#if DEBUG
extension BaseEnvironment {
    
    static var preview: BaseEnvironment<Void> {
        .init(date: Date.init,
              featureEnvironment: (),
              mainQueue: DispatchQueue.immediate.eraseToAnyScheduler(),
              uuid: UUID.init,
              mainBundle: Bundle.main,
              currentLocale: Locale.current,
              currentDevice: Device.current,
              appConfig: .fake,
              stringLocalizer: .real, // Use NSLocalizedStrings in preview mode...
              dataClients: .fake)
    }
    
    static var unitTest: BaseEnvironment<Void> {
        .init(date: Date.init,
              featureEnvironment: (),
              mainQueue: DispatchQueue.immediate.eraseToAnyScheduler(),
              uuid: UUID.init,
              mainBundle: Bundle.main,
              currentLocale: Locale.current,
              currentDevice: Device.current,
              appConfig: .fake,
              stringLocalizer: .fake,
              dataClients: .fake)
    }
}
#endif
