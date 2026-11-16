import Testing

@testable import SeedDataCore

struct StationNameCleanerTests {

    @Test(arguments: [
        ("Abbey Wood Rail Station", "Abbey Wood"),
        ("North Fambridge Rail Station ", "North Fambridge"),
        ("Coombe Junction Halt (Rail Station)", "Coombe Junction Halt"),
        ("Brent Cross West Station", "Brent Cross West"),
        ("Baker Street Underground Station", "Baker Street"),
        ("Canary Wharf DLR Station", "Canary Wharf"),
        ("Wimbledon Tram Stop", "Wimbledon"),
        ("Adlington (Cheshire)", "Adlington (Cheshire)"),
        ("Farringdon", "Farringdon")
    ])
    func cleansName(name: String, expected: String) {
        #expect(StationNameCleaner.clean(name) == expected)
    }

    @Test
    func keepsStationThatIsPartOfThePlaceName() {
        #expect(StationNameCleaner.clean("Battersea Power Station Underground Station") == "Battersea Power Station")
    }
}
