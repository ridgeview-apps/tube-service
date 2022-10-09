import DataClients
import Foundation
import Models
import Shared

@MainActor
public final class LineStatusModel: ObservableObject {
        
    // MARK: - Properties / outputs
    
    public enum FetchType: Hashable {
        case today
        case range(DateInterval)
    }
    
    struct FetchedData {
        var lines: [Line]
        var fetchedAt: Date?
        var fetchState: DataFetchState
        
        static var firstFetch: FetchedData {
            .init(lines: [], fetchState: .fetching)
        }
    }
    
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
    
    func fetchedData(for fetchType: FetchType) -> FetchedData? {
        let data = self.fetchedData[fetchType]
        return data
    }
        
    // MARK: - Actions / inputs
    
    public func refreshLineStatusesIfStale(for fetchType: FetchType = .today) async {
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
            return try await transportAPI.fetchCurrentLineStatuses().sortedByStatusSeverity()
        case let .range(dateInterval):
            return try await transportAPI.fetchFutureLineStatuses(for: dateInterval).sortedByStatusSeverity()
        }
    }
}
