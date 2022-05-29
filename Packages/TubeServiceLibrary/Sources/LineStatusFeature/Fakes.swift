import Foundation
import ComposableArchitecture
import Model
import ModelFakes
import Shared
import DataClients

#if DEBUG

// MARK: - LineStatusDetail.State
public extension LineStatusDetail.State {
    static func fake(lineStatus: LineStatus = .fake()) -> LineStatusDetail.State {
        .init(lineStatus: lineStatus)
    }

    enum FakeType {
        case goodService
        case plannedClosure
        case severeDelays
        
        var statusDetails: [LineStatusServiceDetail] {
            switch self {
            case .goodService:
                return [.fake(ofType: .goodService)]
            case .plannedClosure:
                return [.fake(ofType: .plannedClosure)]
            case .severeDelays:
                return [.fake(ofType: .severeDelays)]
            }
        }
    }
    
    static func fake(ofType fakeType: FakeType = .goodService,
                     for trainLine: TrainLine = .northern) -> Self {

        return .init(lineStatus: .init(id: trainLine,
                                       serviceDetails: fakeType.statusDetails))
    }
}

public extension LineStatusDetail.TwitterLink {
    static func fake(style: Style = .tflAllTweets,
                     url: URL = URL(string: "www.example.com")!) -> Self {
        .init(style: style, url: url)
    }
}

// MARK: - LineStatusList.State
public extension LineStatusList.State {
    static func fake(lastRefreshedAt: Date? = nil,
                     isRefreshing: Bool = false,
                     statuses: [LineStatus] = .fakes()) -> LineStatusList.State {
        .init(
            lastRefreshedAt: lastRefreshedAt,
            isRefreshing: isRefreshing,
            statuses: IdentifiedArrayOf(uniqueElements: statuses)
        )
    }
}

// MARK: - LineStatusList.Environment
public extension LineStatusList.Environment {
    static func fake(
        transportAPI: TransportAPIClient = .fake,
        now: @escaping () -> Date = Date.init,
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.immediate.eraseToAnyScheduler()
    ) -> Self {
        .init(transportAPI: transportAPI,
              now: now,
              mainQueue: mainQueue)
    }
    
    func withFailedRefresh() -> Self {
        var env = self
        env.transportAPI.lineStatuses = {
            return Result.failurePublisher(
                TransportAPIClient.APIFailure(error: NSError.fake(ofType: .noInternet))
            )
        }
        return env
    }
}


#endif
