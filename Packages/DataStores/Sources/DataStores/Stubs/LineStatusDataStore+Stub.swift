import Foundation
import Models

#if DEBUG

    public extension LineStatusDataStore {

        static func stub(
            tflAPI: TflAPIClientType,
            tubeServiceAPI: TubeServiceAPIClientType = StubTubeServiceAPIClient(),
            now: @escaping () -> Date = { Date() },
            featureFlags: @escaping () -> FeatureFlags = { FeatureFlags(isStatusHistoryEnabled: true) }
        ) -> LineStatusDataStore {
            return .init(tflAPI: tflAPI, tubeServiceAPI: tubeServiceAPI, now: now, featureFlags: featureFlags)
        }
    }

#endif
