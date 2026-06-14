import Foundation

#if DEBUG

    public extension LineStatusDataStore {

        static func stub(
            tflAPI: TflAPIClientType,
            tubeServiceAPI: TubeServiceAPIClientType = StubTubeServiceAPIClient(),
            now: @escaping () -> Date = { Date() }
        ) -> LineStatusDataStore {
            return .init(tflAPI: tflAPI, tubeServiceAPI: tubeServiceAPI, now: now)
        }
    }

#endif
