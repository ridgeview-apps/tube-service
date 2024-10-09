import Models
import Testing

@testable import PresentationViews

struct LineStatusViewStateTests {
    
    @Test
    func lineDisruptionStatus() {
        #expect(LineStatus.with(statusSeverity: .specialService).isDisrupted)
        #expect(LineStatus.with(statusSeverity: .closed).isDisrupted)
        #expect(LineStatus.with(statusSeverity: .suspended).isDisrupted)
        #expect(LineStatus.with(statusSeverity: .partSuspended).isDisrupted)
        #expect(LineStatus.with(statusSeverity: .plannedClosure).isDisrupted)
        #expect(LineStatus.with(statusSeverity: .partClosure).isDisrupted)
        #expect(LineStatus.with(statusSeverity: .severeDelays).isDisrupted)
        #expect(LineStatus.with(statusSeverity: .reducedService).isDisrupted)
        #expect(LineStatus.with(statusSeverity: .busService).isDisrupted)
        #expect(LineStatus.with(statusSeverity: .minorDelays).isDisrupted)
        
        #expect(!LineStatus.with(statusSeverity: .goodService).isDisrupted)
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
