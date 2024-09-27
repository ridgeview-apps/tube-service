import Foundation
import Models
import Shared

@MainActor
@Observable
public final class SystemStatusDataStore {
    
    // MARK: - Properties / outputs

    public let systemStatusAPI: SystemStatusAPIClientType
    public let now: () -> Date
    public let calendar: Calendar
    
    public private(set) var currentStatus: SystemStatus?
    private(set) var lastFetchedAt: Date = .distantPast
    private(set) var fetchState: DataFetchState?
    
    
    // MARK: - Init
    
    public init(systemStatusAPI: SystemStatusAPIClientType,
                now: @escaping () -> Date = { .now },
                calendar: Calendar = .london) {
        self.systemStatusAPI = systemStatusAPI
        self.now = now
        self.calendar = calendar
    }
    
    
    // MARK: - Actions / inputs
    
    public func fetchSystemStatusIfStale() async {
        let tenMinutes = TimeInterval(10 * 60)
        let tenMinutesAgo = now() - tenMinutes
        
        let lastFetchedOver10MinutesAgo = lastFetchedAt <= tenMinutesAgo
        
        if lastFetchedOver10MinutesAgo {
            await fetchSystemStatus()
        }
    }
    
    public func fetchSystemStatus() async {
        if case .fetching = fetchState {
            return
        }
        
        fetchState = .fetching
        
        do {
            let refreshedSystemStatus = try await systemStatusAPI.fetchSystemStatus()
            currentStatus = refreshedSystemStatus.decodedModel
            fetchState = .success
            lastFetchedAt = now()
        } catch {
            fetchState = .failure(error)
        }
    }
}
