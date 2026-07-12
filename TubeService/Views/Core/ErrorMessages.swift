import Foundation
import DataStores
import PresentationViews

extension Error {

    func toUIErrorMessage() -> String {
        resolvedMessage(default: String(localized: L10n.errorSomethingWentWrong))
    }

    func toSaveErrorMessage() -> String {
        resolvedMessage(default: String(localized: L10n.errorSaveFailed))
    }

    private func resolvedMessage(default fallback: String) -> String {
        if let httpError = self as? HTTPError {
            return httpError.toUIErrorMessage() ?? fallback
        }
        return fallback
    }
}

private extension HTTPError {

    func toUIErrorMessage() -> String? {
        switch self {
        case let .connection(error as NSError) where offlineErrorCodes.contains(error.code):
            return String(localized: L10n.errorNoInternetConnection)
        default:
            return nil
        }
    }
}


private let offlineErrorCodes = [
    NSURLErrorNotConnectedToInternet,
    NSURLErrorDataNotAllowed
]
