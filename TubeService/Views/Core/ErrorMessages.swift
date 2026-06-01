import Foundation
import DataStores

extension Error {
    
    func toUIErrorMessage() -> String {
        let defaultErrorMessage = String(localized: .errorSomethingWentWrong)
        
        switch self {
        case let httpError as HTTPError:
            return httpError.toUIErrorMessage() ?? defaultErrorMessage
        default:
            return defaultErrorMessage
        }
    }
}

private extension HTTPError {
    
    func toUIErrorMessage() -> String? {
        switch self {
        case let .connection(error as NSError) where offlineErrorCodes.contains(error.code):
            return String(localized: .errorNoInternetConnection)
        default:
            return nil
        }
    }
}


private let offlineErrorCodes = [NSURLErrorNotConnectedToInternet,
                                 NSURLErrorDataNotAllowed]
