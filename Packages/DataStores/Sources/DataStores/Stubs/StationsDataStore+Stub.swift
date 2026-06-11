import Foundation

#if DEBUG

    public extension StationsDataStore {

        static func stub(tflAPI: TflAPIClientType) -> StationsDataStore {
            return .init(tflAPI: tflAPI)
        }
    }

#endif
