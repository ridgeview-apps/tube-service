import Foundation
import ComposableArchitecture
import DeviceKit
import Model
import ModelFakes
import Shared

#if DEBUG

public extension Settings.State {
    static func fake(contactUs: Settings.State.ContactUs = .empty,
                     appVersionNumber: String = "1.1",
                     submitAppReviewURL: URL = .fakeAppReviewURL) -> Settings.State {
        .init(contactUs: contactUs,
              appVersionNumber: appVersionNumber,
              submitAppReviewUrl: submitAppReviewURL)
    }
}

public extension URL {
    static let fakeAppReviewURL = URL(string: "https://fakeurl.com")!
}

extension Settings.Environment {
    static func fake(
        mainBundle: Bundle = .main,
        currentLocale: Locale = .current,
        currentDevice: Device = .iPhone13Pro,
        featureConfig: FeatureConfig = .fake()
    ) -> Self {
        .init(mainBundle: mainBundle,
              currentLocale: currentLocale,
              currentDevice: currentDevice,
              featureConfig: featureConfig)
    }
}

extension Settings.Environment.FeatureConfig {
    static func fake(contactUsEmail: String = "",
                     appStoreProductURL: URL = .fakeAppReviewURL) -> Self {
        .init(contactUsEmail: contactUsEmail,
              appStoreProductUrl: appStoreProductURL)
    }
}

extension SettingsStore {
    static func fake(state: Settings.State = .fake()) -> SettingsStore {
        .init(initialState: state,
              reducer: Settings.reducer,
              environment: .fake())
    }

}

#endif
