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
