import Combine
import Foundation

public extension Result {
    
    static func successPublisher(_ successValue: Success) -> AnyPublisher<Success, Failure> {
        Result.success(successValue).publisher.eraseToAnyPublisher()
    }
    
    static func failurePublisher(_ error: Failure) -> AnyPublisher<Success, Failure> {
        Result.failure(error).publisher.eraseToAnyPublisher()
    }
}
