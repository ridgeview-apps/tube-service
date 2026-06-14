import Foundation
import Models
import Testing

@testable import DataStores

struct TflAPIRouteTests {

    private let baseURL = URL(string: "https://foo.com/")!
    private let appKey = "testAppKey"

    @Test
    func currentLineStatusesEndpoint() throws {
        // Given
        let route: TflAPIRoute = .currentLineStatuses(ModeID.trains)

        // When
        let url = try route.toURL(relativeTo: baseURL, appKey: appKey)

        // Then
        let expectedValue = "https://foo.com/Line/Mode/tube,dlr,overground,tram,elizabeth-line/Status?app_key=testAppKey"
        #expect(url.absoluteString == expectedValue)
    }

    @Test
    func routeBuildsJSONGetRequest() throws {
        let route: TflAPIRoute = .currentLineStatuses(ModeID.trains)

        let request = try route.toURLRequest(relativeTo: baseURL, appKey: appKey)

        #expect(request.httpMethod == "GET")
        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
    }

    @Test
    func getFutureLineStatusesEndpoint() throws {
        // Given
        let startDate = dayMonthYear(1, 2, 2023, in: .london)
        let endDate = dayMonthYear(2, 2, 2023, in: .london)
        let dateInterval = DateInterval(start: startDate, end: endDate)
        let route: TflAPIRoute = .lineStatusesForDateRange(TrainLineID.allCases, dateInterval)

        // When
        let url = try route.toURL(relativeTo: baseURL, appKey: appKey)

        // Then
        let expectedValue =
            "https://foo.com/Line/bakerloo,central,circle,district,dlr,elizabeth,hammersmith-city,jubilee,liberty,lioness,metropolitan,mildmay,northern,piccadilly,suffragette,victoria,waterloo-city,weaver,windrush,tram/Status/2023-02-01/to/2023-02-02?app_key=testAppKey"
        #expect(url.absoluteString == expectedValue)
    }

    @Test
    func arrivalPredictionsEndpoint() throws {
        // Given
        let route: TflAPIRoute = .arrivalPredictions(stationCode: "FAKE_STATION_CODE", [.circle, .hammersmithAndCity, .district, .northern])

        // When
        let url = try route.toURL(relativeTo: baseURL, appKey: appKey)

        // Then
        let expectedValue = "https://foo.com/Line/circle,hammersmith-city,district,northern/Arrivals/FAKE_STATION_CODE?app_key=testAppKey"
        #expect(url.absoluteString == expectedValue)
    }

    @Test
    func arrivalPredictionsEncodesStationCodeAsSinglePathComponent() throws {
        let route: TflAPIRoute = .arrivalPredictions(
            stationCode: "station/with ?#%",
            [.northern]
        )

        let url = try route.toURL(relativeTo: baseURL, appKey: appKey)

        #expect(
            url.absoluteString
                == "https://foo.com/Line/northern/Arrivals/station%2Fwith%20%3F%23%25?app_key=testAppKey"
        )
    }

    @Test
    func routePreservesBaseURLPath() throws {
        let baseURL = URL(string: "https://foo.com/proxy/tfl/")!
        let route: TflAPIRoute = .currentLineStatuses([.tube])

        let url = try route.toURL(relativeTo: baseURL, appKey: appKey)

        #expect(
            url.absoluteString
                == "https://foo.com/proxy/tfl/Line/Mode/tube/Status?app_key=testAppKey"
        )
    }

    @Test
    func arrivalDeparturesEndpoint() throws {
        // Given
        let route: TflAPIRoute = .arrivalDepartures(stationCode: "FAKE_STATION_CODE", [.elizabeth])

        // When
        let url = try route.toURL(relativeTo: baseURL, appKey: appKey)

        // Then
        let expectedValue = "https://foo.com/StopPoint/FAKE_STATION_CODE/ArrivalDepartures?app_key=testAppKey&lineIds=elizabeth"
        #expect(url.absoluteString == expectedValue)
    }


    @Test
    func stationDisruptionsEndpoint() throws {
        // Given
        let route: TflAPIRoute = .stationDisruptions(ModeID.trains)

        // When
        let url = try route.toURL(relativeTo: baseURL, appKey: appKey)

        // Then
        let expectedValue = "https://foo.com/StopPoint/Mode/tube,dlr,overground,tram,elizabeth-line/Disruption?app_key=testAppKey"
        #expect(url.absoluteString == expectedValue)
    }

    @Test
    func journeyResultsEndpointIncludesOptionalParameters() throws {
        let params = JourneyRequestParams(
            from: .icsCode("1000266"),
            to: .icsCode("1000254"),
            via: .icsCode("1000174"),
            modeIDs: [.tube, .bus, .cycle],
            timeOption: .departing(queryDate: "20260612", queryTime: "1430"),
            routeBetweenEntrances: true
        )
        let route: TflAPIRoute = .journeyResults(params)

        let url = try route.toURL(relativeTo: baseURL, appKey: appKey)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: true))
        let queryParameters = Dictionary(
            uniqueKeysWithValues: (components.queryItems ?? []).compactMap { item in
                item.value.map { (item.name, $0) }
            }
        )

        #expect(components.path == "/Journey/JourneyResults/1000266/to/1000254")
        #expect(queryParameters["app_key"] == appKey)
        #expect(queryParameters["via"] == "1000174")
        #expect(queryParameters["mode"] == "bus,cycle,tube")
        #expect(queryParameters["alternativeCycle"] == "true")
        #expect(queryParameters["routeBetweenEntrances"] == "true")
        #expect(queryParameters["timeIs"] == "departing")
        #expect(queryParameters["date"] == "20260612")
        #expect(queryParameters["time"] == "1430")
        #expect(
            components.queryItems?.map(\.name)
                == [
                    "app_key",
                    "routeBetweenEntrances",
                    "mode",
                    "alternativeCycle",
                    "via",
                    "timeIs",
                    "date",
                    "time"
                ]
        )
    }

    @Test
    func journeyResultsEndpointSupportsCoordinates() throws {
        let params = JourneyRequestParams(
            from: .coordinate(.init(lat: 51.5308, lon: -0.1238)),
            to: .coordinate(.init(lat: 51.5033, lon: -0.1147)),
            via: nil,
            modeIDs: [.walking],
            timeOption: nil
        )
        let route: TflAPIRoute = .journeyResults(params)

        let url = try route.toURL(relativeTo: baseURL, appKey: appKey)

        #expect(
            url.path
                == "/Journey/JourneyResults/51.5308,-0.1238/to/51.5033,-0.1147"
        )
    }

    @Test
    func modeIDSetURLPathParamIsSorted() {
        // Given
        let modeIDs: Set<ModeID> = [.walking, .bus, .nationalRail, .cycleHire]

        // When
        let value = modeIDs.toURLPathParam()

        // Then
        #expect(value == "bus,cycle-hire,national-rail,walking")
    }

    @Test
    func apiDateUsesLondonTimeZone() throws {
        // Given
        let date = try #require(
            Calendar(identifier: .gregorian).date(
                from: DateComponents(
                    timeZone: .gmt,
                    year: 2026,
                    month: 6,
                    day: 10,
                    hour: 23,
                    minute: 30
                )
            )
        )

        // When
        let value = date.toAPIDateParam()

        // Then
        #expect(value == "2026-06-11")
    }
}


// MARK: - Private helpers

private extension TflAPIRouteTests {


    private func dayMonthYear(_ day: Int, _ month: Int, _ year: Int, in timeZone: TimeZone) -> Date {
        let calendar = Calendar.iso8601(in: timeZone)
        let dateComponents = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            year: year,
            month: month,
            day: day
        )
        return calendar.date(from: dateComponents)!
    }
}
