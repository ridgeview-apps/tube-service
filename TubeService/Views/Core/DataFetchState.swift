import Foundation
import DataStores

extension Error {
    
    func toUIErrorMessage() -> String {
        let defaultErrorMessage = NSLocalizedString("error.something.went.wrong", comment: "")
        
        switch self {
        case let apiError as TransportAPIError:
            return apiError.toUIErrorMessage() ?? defaultErrorMessage
        default:
            return defaultErrorMessage
        }
    }
}

private extension TransportAPIError {
    
    func toUIErrorMessage() -> String? {
        switch self {
        case let .connection(error as NSError) where offlineErrorCodes.contains(error.code):
            return NSLocalizedString("error.no.internet.connection", comment: "")
        default:
            return nil
        }
    }
}


private let offlineErrorCodes = [NSURLErrorNotConnectedToInternet,
                                 NSURLErrorDataNotAllowed]
