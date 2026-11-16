import Foundation
import Testing

@testable import SeedDataCore

struct SeedOutputTests {

    @Test
    func encodesInTheRepoFileFormat() throws {
        let stopPoint = NationalRailStopPoint(commonName: "Abbey Wood", icsCode: "1001001", lat: 51.491225, lon: 0.12084, naptanId: "910GABWDXR")

        let output = String(decoding: try SeedOutput.encode([stopPoint]), as: UTF8.self)

        #expect(
            output == """
                [
                  {
                    "commonName" : "Abbey Wood",
                    "icsCode" : "1001001",
                    "lat" : 51.491225,
                    "lon" : 0.12084,
                    "naptanId" : "910GABWDXR"
                  }
                ]

                """
        )
    }

    @Test
    func readsNothingWhenTheFileIsMissing() throws {
        let missingURL = URL(filePath: NSTemporaryDirectory()).appending(path: UUID().uuidString)

        #expect(try SeedOutput.read([NationalRailStopPoint].self, from: missingURL) == nil)
    }
}
