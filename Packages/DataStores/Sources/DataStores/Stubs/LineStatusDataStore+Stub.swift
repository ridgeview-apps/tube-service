import Foundation

#if DEBUG

    public extension LineStatusDataStore {

        static func stub(
            tflAPI: TflAPIClientType,
            now: @escaping () -> Date = { Date() }
        ) -> LineStatusDataStore {
            return .init(tflAPI: tflAPI, now: now)
        }
    }

#endif
