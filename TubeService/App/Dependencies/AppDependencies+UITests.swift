import CoreLocation
import DataStores
import Foundation
import Models
import Shared

#if DEBUG

    extension AppDependencies {

        /// Stubbed dependencies for a UI test launch, starting from the saved state the test asked for.
        static func uiTests(_ configuration: TubeUITestLaunchConfiguration) -> AppDependencies {
            let scenario = configuration.scenario
            let now = configuration.now

            let userDefaults = UserDefaults.emptiedUITestSuite(named: "UITests")
            scenario.seed.write(to: userDefaults, now: now)
            userDefaults.featureFlags = FeatureFlags(
                isStatusHistoryEnabled: scenario.enablesUnreleasedFeatures,
                isNotificationsEnabled: scenario.enablesUnreleasedFeatures,
                isPaywallBypassed: scenario.hasTubeServicePlus
            )

            let locationManager = StubLocationManager()
            locationManager.locationsToReturnOnRequest = [
                CLLocation(latitude: 51.530823, longitude: -0.123821)  // King's Cross
            ]

            let tflAPI: TflAPIClientType =
                switch scenario.fixtures {
                case .screenshots: ScreenshotTflAPIClient()
                case .functional: StubTflAPIClient()
                }

            return AppDependencies(
                tflAPI: tflAPI,
                tubeServiceAPI: StubTubeServiceAPIClient(),
                notificationsAPI: StubNotificationsAPIClient(),
                systemStatusAPI: StubSystemStatusAPIClient(),
                locationManager: locationManager,
                reverseGeocoder: StubReverseGeocoder(),
                localSearchCompleterClient: StubLocalSearchCompleterClient(),
                userDefaults: UserDefaultsProvider(userDefaults),
                pushNotificationEnvironment: .stub,
                purchaseProductIDs: .stub,
                // Plus comes from the debug paywall bypass, which only applies outside App Store installs.
                readInstallEnvironment: { .xcode },
                now: { now }
            )
        }
    }

    extension UITestScenario.Seed {

        func write(to userDefaults: UserDefaults, now: Date) {
            switch self {
            case .freshInstall:
                break
            case .returningUser:
                userDefaults.userPreferences = UserPreferences(
                    favouriteLineGroupIDs: [
                        Station.LineGroup(atcoCode: "910GABWDXR", lineIds: [.elizabeth]).id,  // Abbey Wood
                        Station.LineGroup(atcoCode: "940GZZLUKSX", lineIds: [.victoria]).id  // King's Cross
                    ],
                    favouriteLineIDs: [.elizabeth, .victoria],
                    journeyModePreset: .trainAndBus,
                    recentlySavedJourneys: [
                        SavedJourney(
                            id: UUID(),
                            fromLocation: .station(id: "HUBKGX"),  // King's Cross & St Pancras International
                            toLocation: .station(id: "HUBWAT"),  // Waterloo
                            viaLocation: nil,
                            lastUsed: now.addingTimeInterval(-24 * 60 * 60)
                        )
                    ],
                    readSystemStatusMessage: nil
                )
            }
        }
    }

#endif
