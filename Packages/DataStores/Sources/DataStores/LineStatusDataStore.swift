import Foundation
import Models
import Shared

@MainActor
public final class LineStatusDataStore: ObservableObject {
    
    // MARK: - Data types
    
    public enum FetchType: Hashable {
        case today
        case range(DateInterval)
    }
    
    public struct FetchedData {
        public var lines: [Line]
        public var fetchedAt: Date?
        public var fetchState: DataFetchState
        
        static var firstFetch: FetchedData {
            .init(lines: [], fetchState: .fetching)
        }
    }
    
    
    // MARK: - Properties / outputs

    public let transportAPI: TransportAPIClientType
    public let now: () -> Date
    public let calendar: Calendar
    
    @Published private var fetchedData: [FetchType: FetchedData] = [:]
    
    
    // MARK: - Init
    
    public init(transportAPI: TransportAPIClientType,
                now: @escaping () -> Date = { .now },
                calendar: Calendar = .london) {
        self.transportAPI = transportAPI
        self.now = now
        self.calendar = calendar
    }
    
    public func fetchedData(for fetchType: FetchType) -> FetchedData? {
        let data = self.fetchedData[fetchType]
        return data
    }
    
    
    // MARK: - Actions / inputs
    
    public func refreshLineStatusesIfStale(for fetchType: FetchType) async {
        let fiveMinutes = TimeInterval(5 * 60)
        let fiveMinutesAgo = now() - fiveMinutes
        
        let lastFetchedAt = fetchedData[fetchType]?.fetchedAt ?? .distantPast
        let lastFetchedOver5MinutesAgo = lastFetchedAt <= fiveMinutesAgo
        
        if lastFetchedOver5MinutesAgo {
            await refreshLineStatuses(for: fetchType)
        }
    }
    
    public func refreshLineStatuses(for fetchType: FetchType) async {
        if case .fetching = fetchedData[fetchType]?.fetchState {
            return
        }
        
        let currentOrDefaultValue = fetchedData[fetchType, default: .firstFetch]
        fetchedData[fetchType] = currentOrDefaultValue
        fetchedData[fetchType]?.fetchState = .fetching
        
        do {
            let refreshedLines = try await fetchLineStatuses(for: fetchType)
            fetchedData[fetchType]?.lines = refreshedLines
            fetchedData[fetchType]?.fetchState = .success
            fetchedData[fetchType]?.fetchedAt = now()
        } catch {
            fetchedData[fetchType]?.fetchState = .failure(error)
        }
    }
    
    private func fetchLineStatuses(for fetchType: FetchType) async throws -> [Line] {
        switch fetchType {
        case .today:
            return try await transportAPI.fetchCurrentLineStatuses()
        case let .range(dateInterval):
            let lines = try await transportAPI.fetchLineStatuses(for: dateInterval)
            let isFutureDateRange = dateInterval.start > now()
            return isFutureDateRange ? lines.removingRealtimeDisruptionStatuses() : lines
        }
    }
    
    public func liveDisruptions() -> [Line] {
        (fetchedData[.today]?.lines ?? []).filter(\.isDisrupted)
    }
}

private extension Sequence where Element == Line {
    func removingRealtimeDisruptionStatuses() -> [Line] {
        self.map { $0.removingRealtimeDisruption() }
    }
}

private extension Line {
    
    // Workaround for the fact the TFL API sometimes returns "realtime" statuses when querying a future date (i.e. typically
    // when querying tomorrow). For example: it's currently Friday and the Jubilee line has severe delays. If you query for
    // Saturday's status, it will also include Friday's (realtime) delays.
    
    func removingRealtimeDisruption() -> Line {
        var updatedStatuses = lineStatuses?.filter { $0.disruption?.category != .realTime } ?? []
        
        if updatedStatuses.isEmpty {
            updatedStatuses.append(.goodService)
        }
        
        return .init(id: id, lineStatuses: updatedStatuses)
    }
}
