import Foundation
import DataStores

extension Error {
    
    func toUIErrorMessage() -> String {
        let defaultErrorMessage = NSLocalizedString("error.something.went.wrong", comment: "")
        switch self {
        case let .requestFailure(error as NSError) as TransportAPIError where offlineErrorCodes.contains(error.code):
            return NSLocalizedString("error.no.internet.connection", comment: "")
        default:
            return defaultErrorMessage
        }
    }
}


private let offlineErrorCodes = [NSURLErrorNotConnectedToInternet,
                                 NSURLErrorDataNotAllowed]
