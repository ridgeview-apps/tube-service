import Foundation
import Models
import Shared

@MainActor
@Observable
public final class SystemStatusDataStore {

    // MARK: - State

    private let systemStatusAPI: SystemStatusAPIClientType
    private let now: () -> Date
    private let calendar: Calendar

    public private(set) var currentStatus: SystemStatus?
    private(set) var lastFetchedAt: Date = .distantPast
    private(set) var fetchState: DataFetchState?

    public init(
        systemStatusAPI: SystemStatusAPIClientType,
        now: @escaping () -> Date = { .now },
        calendar: Calendar = .london
    ) {
        self.systemStatusAPI = systemStatusAPI
        self.now = now
        self.calendar = calendar
    }

    // MARK: - Refreshing

    /// Refreshes the status unless it was fetched in the last 10 minutes.
    public func refreshSystemStatusIfStale() async {
        let tenMinutes = TimeInterval(10 * 60)
        if lastFetchedAt <= now() - tenMinutes {
            await refreshSystemStatus()
        }
    }

    public func refreshSystemStatus() async {
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
