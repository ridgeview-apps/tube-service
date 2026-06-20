import Foundation
import Models

// MARK: - Tube Service API

public protocol TubeServiceAPIClientType: Sendable {
    func fetchDailyLineTimeline(lineID: TrainLineID, operationalDate: Date?) async throws -> HTTPResponse<DailyLineTimeline>
    func fetchDailyLineDisruptionSummary(operationalDate: Date?) async throws -> HTTPResponse<DailyDisruptionSummary>
}


// MARK: - Notifications API

public protocol NotificationsAPIClientType: Sendable {
    func registerDevice(deviceId: String, pushToken: String, appVersion: String?) async throws -> HTTPResponse<NotificationDevice>
    func deleteDevice(deviceId: String) async throws
    func disableDevice(deviceId: String) async throws -> HTTPResponse<NotificationDevice>
    func fetchPreferences(deviceId: String) async throws -> HTTPResponse<NotificationPreferences>
    func updatePreferences(deviceId: String, update: NotificationPreferencesUpdate) async throws -> HTTPResponse<NotificationPreferences>
}


// MARK: - API Routes

enum TubeServiceAPIRoute {

    // Line status
    case dailyLineTimeline(lineID: TrainLineID, operationalDate: Date?)
    case dailyLineDisruptionSummary(operationalDate: Date?)

    // Notifications
    case registerDevice(deviceId: String, body: Data)
    case deleteDevice(deviceId: String)
    case disableDevice(deviceId: String)
    case fetchPreferences(deviceId: String)
    case updatePreferences(deviceId: String, body: Data)

    func toURL(relativeTo baseURL: URL) throws -> URL {
        guard let url = try toURLComponents(relativeTo: baseURL).url else {
            throw HTTPError.invalidRequestURL
        }
        return url
    }

    func toURLRequest(relativeTo baseURL: URL, apiKey: String) throws -> URLRequest {
        var request = URLRequest(url: try toURL(relativeTo: baseURL))
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        if let body = httpBody {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }

    private var httpMethod: String {
        switch self {
        case .dailyLineTimeline, .dailyLineDisruptionSummary, .fetchPreferences:
            return "GET"
        case .registerDevice, .updatePreferences:
            return "PUT"
        case .disableDevice:
            return "POST"
        case .deleteDevice:
            return "DELETE"
        }
    }

    private var httpBody: Data? {
        switch self {
        case let .registerDevice(_, body), let .updatePreferences(_, body):
            return body
        default:
            return nil
        }
    }

    private var pathComponents: [String] {
        switch self {
        case .dailyLineTimeline:
            return ["v1", "line-status", "timeline"]
        case .dailyLineDisruptionSummary:
            return ["v1", "line-status", "disruption-summary"]
        case let .registerDevice(deviceId, _), let .deleteDevice(deviceId):
            return ["v1", "notification-devices", deviceId]
        case let .disableDevice(deviceId):
            return ["v1", "notification-devices", deviceId, "disable"]
        case let .fetchPreferences(deviceId), let .updatePreferences(deviceId, _):
            return ["v1", "notification-devices", deviceId, "preferences"]
        }
    }

    private var queryItems: [URLQueryItem] {
        switch self {
        case let .dailyLineTimeline(lineID, operationalDate):
            var items = [URLQueryItem(name: "line_id", value: lineID.rawValue)]
            if let operationalDate {
                items.append(URLQueryItem(name: "date", value: operationalDate.toOperationalDateParam()))
            }
            return items
        case let .dailyLineDisruptionSummary(operationalDate):
            guard let operationalDate else { return [] }
            return [URLQueryItem(name: "date", value: operationalDate.toOperationalDateParam())]
        case .registerDevice, .deleteDevice, .disableDevice, .fetchPreferences, .updatePreferences:
            return []
        }
    }

    private func toURLComponents(relativeTo baseURL: URL) throws -> URLComponents {
        try .route(relativeTo: baseURL, pathComponents: pathComponents, queryItems: queryItems)
    }
}


// MARK: - TubeServiceAPIClient

public struct TubeServiceAPIClient: TubeServiceAPIClientType, NotificationsAPIClientType {

    private let baseURL: URL
    private let apiKey: String
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder


    // MARK: - Init

    public init(
        baseURL: URL,
        apiKey: String,
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder = .tubeServiceModelDecoder
    ) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return encoder
        }()
    }


    // MARK: - Tube service data

    public func fetchDailyLineTimeline(lineID: TrainLineID, operationalDate: Date?) async throws -> HTTPResponse<DailyLineTimeline> {
        try await perform(
            for: .dailyLineTimeline(lineID: lineID, operationalDate: operationalDate),
            mappedTo: DailyLineTimeline.self
        )
    }

    public func fetchDailyLineDisruptionSummary(operationalDate: Date?) async throws -> HTTPResponse<DailyDisruptionSummary> {
        try await perform(
            for: .dailyLineDisruptionSummary(operationalDate: operationalDate),
            mappedTo: DailyDisruptionSummary.self
        )
    }


    // MARK: - Notifications

    public func registerDevice(deviceId: String, pushToken: String, appVersion: String?) async throws -> HTTPResponse<NotificationDevice> {
        let body = try jsonEncoder.encode(NotificationDeviceRegistration(platform: "ios", pushToken: pushToken, appVersion: appVersion))
        return try await perform(for: .registerDevice(deviceId: deviceId, body: body), mappedTo: NotificationDevice.self)
    }

    public func deleteDevice(deviceId: String) async throws {
        let request = try TubeServiceAPIRoute.deleteDevice(deviceId: deviceId).toURLRequest(relativeTo: baseURL, apiKey: apiKey)
        try await urlSession.send(request: request, decodedBy: jsonDecoder)
    }

    public func disableDevice(deviceId: String) async throws -> HTTPResponse<NotificationDevice> {
        try await perform(for: .disableDevice(deviceId: deviceId), mappedTo: NotificationDevice.self)
    }

    public func fetchPreferences(deviceId: String) async throws -> HTTPResponse<NotificationPreferences> {
        try await perform(for: .fetchPreferences(deviceId: deviceId), mappedTo: NotificationPreferences.self)
    }

    public func updatePreferences(deviceId: String, update: NotificationPreferencesUpdate) async throws -> HTTPResponse<NotificationPreferences> {
        let body = try jsonEncoder.encode(update)
        return try await perform(for: .updatePreferences(deviceId: deviceId, body: body), mappedTo: NotificationPreferences.self)
    }


    // MARK: - Helpers

    private func perform<T: Decodable>(for route: TubeServiceAPIRoute, mappedTo model: T.Type) async throws -> HTTPResponse<T> {
        let request = try route.toURLRequest(relativeTo: baseURL, apiKey: apiKey)
        return try await urlSession.data(for: request, decodedBy: jsonDecoder, as: model)
    }
}


// MARK: - Private request types

private struct NotificationDeviceRegistration: Encodable {
    let platform: String
    let pushToken: String
    let appVersion: String?
}
