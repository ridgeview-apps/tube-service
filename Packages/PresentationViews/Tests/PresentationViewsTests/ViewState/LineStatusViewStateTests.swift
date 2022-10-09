import Models
import XCTest

@testable import PresentationViews

final class LineStatusViewStateTests: XCTestCase {
    
    func testLineDisruptionStatus() {
        XCTAssertTrue(LineStatus.with(statusSeverity: .specialService).isDisrupted)
        XCTAssertTrue(LineStatus.with(statusSeverity: .closed).isDisrupted)
        XCTAssertTrue(LineStatus.with(statusSeverity: .suspended).isDisrupted)
        XCTAssertTrue(LineStatus.with(statusSeverity: .partSuspended).isDisrupted)
        XCTAssertTrue(LineStatus.with(statusSeverity: .plannedClosure).isDisrupted)
        XCTAssertTrue(LineStatus.with(statusSeverity: .partClosure).isDisrupted)
        XCTAssertTrue(LineStatus.with(statusSeverity: .severeDelays).isDisrupted)
        XCTAssertTrue(LineStatus.with(statusSeverity: .reducedService).isDisrupted)
        XCTAssertTrue(LineStatus.with(statusSeverity: .busService).isDisrupted)
        XCTAssertTrue(LineStatus.with(statusSeverity: .minorDelays).isDisrupted)
        
        XCTAssertFalse(LineStatus.with(statusSeverity: .goodService).isDisrupted)
    }
}


extension LineStatus {
    static func with(statusSeverity: LineStatusSeverity,
                     statusSeverityDescription: String? = nil,
                     reason: String? = nil,
                     disruption: Disruption? = nil) -> LineStatus {
        .init(statusSeverity: statusSeverity,
              statusSeverityDescription: statusSeverityDescription,
              reason: reason,
              disruption: disruption)
    }
}
