import Foundation
import Testing

@testable import Models
@testable import ModelStubs

struct LineStatusDecoderTests {

    // MARK: - Good service line

    @Test
    func decodedGoodServiceLineID() {
        #expect(ModelStubs.lineStatusGoodService.id == .bakerloo)
    }

    @Test
    func decodedGoodServiceLineStatusCount() {
        #expect(ModelStubs.lineStatusGoodService.lineStatuses?.count == 1)
    }

    @Test
    func decodedGoodServiceStatus() {
        let status = ModelStubs.lineStatusGoodService.lineStatuses?.first
        #expect(status?.statusSeverity == .goodService)
        #expect(status?.statusSeverityDescription == "Good Service")
        #expect(status?.reason == nil)
        #expect(status?.disruption == nil)
    }

    // MARK: - Disrupted line

    @Test
    func decodedDisruptedLineID() {
        #expect(ModelStubs.lineStatusDisrupted.id == .weaver)
    }

    @Test
    func decodedDisruptedLineStatusCount() {
        #expect(ModelStubs.lineStatusDisrupted.lineStatuses?.count == 2)
    }

    @Test
    func decodedDisruptedLineStatus() {
        let status = ModelStubs.lineStatusDisrupted.lineStatuses?.first
        #expect(status?.statusSeverity == .partClosure)
        #expect(status?.statusSeverityDescription == "Part Closure")
        #expect(status?.reason?.hasPrefix("WEAVER:") == true)
    }

    @Test
    func decodedDisruptedLineDisruption() throws {
        let disruption = try #require(ModelStubs.lineStatusDisrupted.lineStatuses?.first?.disruption)
        #expect(disruption.category == .plannedWork)
        #expect(disruption.description?.hasPrefix("WEAVER:") == true)
        #expect(disruption.additionalInfo?.contains("Replacement buses") == true)
    }

    @Test
    func decodedDisruptedLineAllStatusesHaveSameSeverity() {
        let statuses = ModelStubs.lineStatusDisrupted.lineStatuses ?? []
        #expect(statuses.allSatisfy { $0.statusSeverity == .partClosure })
    }

    // MARK: - Today's line statuses

    @Test
    func decodedLineStatusesTodayIsNonEmpty() {
        #expect(!ModelStubs.lineStatusesToday.isEmpty)
    }

    @Test
    func decodedLineStatusesTodayContainsBakerloo() {
        #expect(ModelStubs.lineStatusesToday.contains { $0.id == .bakerloo })
    }

    // MARK: - DisruptedPoint

    @Test
    func decodedDisruptedStationsIsNonEmpty() {
        #expect(!ModelStubs.disruptedStations.isEmpty)
    }

    @Test
    func decodedDisruptedStationKentishTown() throws {
        let station = try #require(ModelStubs.disruptedStations.first { $0.atcoCode == "940GZZLUKSH" })
        #expect(station.appearance == .plannedWork)
        #expect(station.description?.contains("KENTISH TOWN") == true)
    }

    @Test
    func decodedDisruptedStationLondonBridge() throws {
        let station = try #require(ModelStubs.disruptedStations.first { $0.atcoCode == "940GZZLULNB" })
        #expect(station.appearance == .plannedWork)
        #expect(station.description?.contains("LONDON BRIDGE") == true)
    }
}
