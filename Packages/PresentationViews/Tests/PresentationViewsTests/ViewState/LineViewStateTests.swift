import Models
import XCTest

@testable import PresentationViews

final class LineViewStateTests: XCTestCase {
    
    func testLineDisruptionStatusDisruptedLine() {
        let disruptedLine = ModelStubs.lineStatusDisrupted
        let goodServiceLine = ModelStubs.lineStatusGoodService
        
        XCTAssertTrue(disruptedLine.isDisrupted)
        XCTAssertFalse(goodServiceLine.isDisrupted)
    }
    
    func testLineDisruptionStates_mixedGoodAndDisrupted() {
        let lines = [
            Line(id: .bakerloo, lineStatuses: [.goodService]),
            Line(id: .northern, lineStatuses: [.goodService]),
            Line(id: .hammersmithAndCity, lineStatuses: [.with(statusSeverity: .severeDelays)])
        ]
        XCTAssertTrue(lines.hasDisruptions)
        XCTAssertFalse(lines.allAreDisrupted)
        XCTAssertEqual(1, lines.disruptionsOnly().count)

        XCTAssertFalse(lines.allAreGoodService)
        XCTAssertEqual(2, lines.goodServiceOnly().count)
    }
    
    func testLineDisruptionStates_allDisrupted() {
        let lines = [
            Line(id: .bakerloo, lineStatuses: [.with(statusSeverity: .severeDelays)]),
            Line(id: .northern, lineStatuses: [.with(statusSeverity: .minorDelays)]),
            Line(id: .hammersmithAndCity, lineStatuses: [.with(statusSeverity: .partClosed)])
        ]
        XCTAssertTrue(lines.hasDisruptions)
        XCTAssertTrue(lines.allAreDisrupted)
        XCTAssertEqual(3, lines.disruptionsOnly().count)
        
        XCTAssertFalse(lines.allAreGoodService)
        XCTAssertEqual(0, lines.goodServiceOnly().count)
    }

    func testLineDisruptionStates_allGoodService() {
        let lines = [
            Line(id: .bakerloo, lineStatuses: [.goodService]),
            Line(id: .northern, lineStatuses: [.goodService]),
            Line(id: .hammersmithAndCity, lineStatuses: [.goodService])
        ]
        XCTAssertFalse(lines.hasDisruptions)
        XCTAssertFalse(lines.allAreDisrupted)
        XCTAssertEqual(0, lines.disruptionsOnly().count)
        
        XCTAssertTrue(lines.allAreGoodService)
        XCTAssertEqual(3, lines.goodServiceOnly().count)
    }
    
    func testLinesWithFilteredFavourites() {
        let lines = [
            Line(id: .bakerloo, lineStatuses: [.goodService]),
            Line(id: .northern, lineStatuses: [.goodService]),
            Line(id: .hammersmithAndCity, lineStatuses: [.goodService])
        ]
        
        let filteredValues = lines.favouritesOnly(matching: [.bakerloo])
        
        XCTAssertEqual(1, filteredValues.count)
        XCTAssertEqual(.bakerloo, filteredValues.first?.id)
    }
    
    func testLinesWithValuesRemoved() {
        let lines = [
            Line(id: .bakerloo, lineStatuses: [.goodService]),
            Line(id: .northern, lineStatuses: [.goodService]),
            Line(id: .hammersmithAndCity, lineStatuses: [.goodService])
        ]
        
        let filteredValues = lines.removingLineIDs([.bakerloo])
        
        XCTAssertEqual(2, filteredValues.count)
        XCTAssertEqual(.northern, filteredValues[0].id)
        XCTAssertEqual(.hammersmithAndCity, filteredValues[1].id)

    }
    
    func testDisruptedLinesAreSortedFirst() {
        // Given
        let goodServiceBakerloo = Line(id: .bakerloo, lineStatuses: [.with(statusSeverity: .goodService)])
        let goodServiceCircleLine = Line(id: .circle, lineStatuses: [.with(statusSeverity: .goodService)])
        let disruptedNorthernLine = Line(id: .northern, lineStatuses: [.with(statusSeverity: .severeDelays)])
        let disruptedPiccadillyLine = Line(id: .piccadilly, lineStatuses: [.with(statusSeverity: .partSuspended)])
        
        let unsortedValues = [goodServiceBakerloo,
                              goodServiceCircleLine,
                              disruptedNorthernLine,
                              disruptedPiccadillyLine]
        
        // When
        let sortedValues = unsortedValues.sortedByStatusSeverity()
                
        // Then
        XCTAssertEqual(
            [disruptedNorthernLine, disruptedPiccadillyLine, goodServiceBakerloo, goodServiceCircleLine],
            sortedValues
        )
    }
    
    func testServiceDetailTextItems_GoodService() {
        let line = Line(id: .bakerloo,
                        lineStatuses: [.with(statusSeverity: .goodService)])
        
        XCTAssertEqual(
            [.init(messageType: .goodService, additionalInfo: nil)],
            line.serviceDetailTextItems
        )
    }
    
    
    func testServiceDetailTextItems_Disrupted_UniqueValues() {
        let line = Line(id: .bakerloo,
                        lineStatuses: [.with(statusSeverity: .partSuspended, reason: "Suspension reason"),
                                       .with(statusSeverity: .partClosed, reason: "Closure reason")])
        
        XCTAssertEqual(
            [
                .init(messageType: .disrupted(reason: "Suspension reason"), additionalInfo: nil),
                .init(messageType: .disrupted(reason: "Closure reason"), additionalInfo: nil),
            ],
            line.serviceDetailTextItems
        )
    }
    
    func testServiceDetailTextItems_Disrupted_DuplicateValues() {
        let line = Line(id: .bakerloo,
                        lineStatuses: [.with(statusSeverity: .partSuspended, reason: "Suspension reason"),
                                       .with(statusSeverity: .partSuspended, reason: "Suspension reason"),
                                       .with(statusSeverity: .partSuspended, reason: "Suspension reason"),
                                       .with(statusSeverity: .partSuspended, reason: "Suspension reason"),
                                       .with(statusSeverity: .partSuspended, reason: "Suspension reason")])
        
        XCTAssertEqual(
            [
                .init(messageType: .disrupted(reason: "Suspension reason"), additionalInfo: nil), // Duplicates removed
            ],
            line.serviceDetailTextItems
        )
    }
}

