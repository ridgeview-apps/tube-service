import Models
import ModelStubs
import Testing

@testable import PresentationViews

struct LineViewStateTests {
    
    @Test
    func lineDisruptionStatusDisruptedLine() {
        let disruptedLine = ModelStubs.lineStatusDisrupted
        let goodServiceLine = ModelStubs.lineStatusGoodService
        
        #expect(disruptedLine.isDisrupted)
        #expect(!goodServiceLine.isDisrupted)
    }
    
    @Test
    func lineDisruptionStates_mixedGoodAndDisrupted() {
        let lines = [
            Line(id: .bakerloo, lineStatuses: [.goodService]),
            Line(id: .northern, lineStatuses: [.goodService]),
            Line(id: .hammersmithAndCity, lineStatuses: [.with(statusSeverity: .severeDelays)])
        ]
        #expect(lines.hasDisruptions)
        #expect(!lines.allAreDisrupted)
        #expect(lines.disruptionsOnly().count == 1)

        #expect(!lines.allAreGoodService)
        #expect(lines.goodServiceOnly().count == 2)
    }
    
    @Test
    func lineDisruptionStates_allDisrupted() {
        let lines = [
            Line(id: .bakerloo, lineStatuses: [.with(statusSeverity: .severeDelays)]),
            Line(id: .northern, lineStatuses: [.with(statusSeverity: .minorDelays)]),
            Line(id: .hammersmithAndCity, lineStatuses: [.with(statusSeverity: .partClosed)])
        ]
        #expect(lines.hasDisruptions)
        #expect(lines.allAreDisrupted)
        #expect(lines.disruptionsOnly().count == 3)
        
        #expect(!lines.allAreGoodService)
        #expect(lines.goodServiceOnly().isEmpty)
    }

    @Test
    func lineDisruptionStates_allGoodService() {
        let lines = [
            Line(id: .bakerloo, lineStatuses: [.goodService]),
            Line(id: .northern, lineStatuses: [.goodService]),
            Line(id: .hammersmithAndCity, lineStatuses: [.goodService])
        ]
        #expect(!lines.hasDisruptions)
        #expect(!lines.allAreDisrupted)
        #expect(lines.disruptionsOnly().isEmpty)
        
        #expect(lines.allAreGoodService)
        #expect(lines.goodServiceOnly().count == 3)
    }
    
    @Test
    func linesWithFilteredFavourites() {
        let lines = [
            Line(id: .bakerloo, lineStatuses: [.goodService]),
            Line(id: .northern, lineStatuses: [.goodService]),
            Line(id: .hammersmithAndCity, lineStatuses: [.goodService])
        ]
        
        let filteredValues = lines.favouritesOnly(matching: [.bakerloo])
        
        #expect(filteredValues.count == 1)
        #expect(filteredValues.first?.id == .bakerloo)
    }
    
    @Test
    func linesWithValuesRemoved() {
        let lines = [
            Line(id: .bakerloo, lineStatuses: [.goodService]),
            Line(id: .northern, lineStatuses: [.goodService]),
            Line(id: .hammersmithAndCity, lineStatuses: [.goodService])
        ]
        
        let filteredValues = lines.removingLineIDs([.bakerloo])
        
        #expect(filteredValues.count == 2)
        #expect(filteredValues[0].id == .northern)
        #expect(filteredValues[1].id == .hammersmithAndCity)

    }
    
    @Test
    func disruptedLinesAreSortedFirst() {
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
        #expect(sortedValues == [disruptedNorthernLine,
                                 disruptedPiccadillyLine,
                                 goodServiceBakerloo,
                                 goodServiceCircleLine])
    }
    
    @Test
    func serviceDetailTextItems_GoodService() {
        let line = Line(id: .bakerloo,
                        lineStatuses: [.with(statusSeverity: .goodService)])
        
        let expectedValues: [Line.ServiceDetailTextItem] = [.init(messageType: .goodService, additionalInfo: nil)]
        #expect(line.serviceDetailTextItems == expectedValues)
    }
    
    @Test
    func serviceDetailTextItems_Disrupted_UniqueValues() {
        let line = Line(id: .bakerloo,
                        lineStatuses: [.with(statusSeverity: .partSuspended, reason: "Suspension reason"),
                                       .with(statusSeverity: .partClosed, reason: "Closure reason")])
        
        let expectedValues: [Line.ServiceDetailTextItem] = [
            .init(messageType: .disrupted(reason: "Suspension reason"), additionalInfo: nil),
            .init(messageType: .disrupted(reason: "Closure reason"), additionalInfo: nil)
        ]
        #expect(line.serviceDetailTextItems == expectedValues)
    }
    
    @Test
    func serviceDetailTextItems_Disrupted_DuplicateValues() {
        let line = Line(id: .bakerloo,
                        lineStatuses: [.with(statusSeverity: .partSuspended, reason: "Suspension reason"),
                                       .with(statusSeverity: .partSuspended, reason: "Suspension reason"),
                                       .with(statusSeverity: .partSuspended, reason: "Suspension reason"),
                                       .with(statusSeverity: .partSuspended, reason: "Suspension reason"),
                                       .with(statusSeverity: .partSuspended, reason: "Suspension reason")])
        
        let expectedValues: [Line.ServiceDetailTextItem] = [
            .init(messageType: .disrupted(reason: "Suspension reason"), additionalInfo: nil), // Duplicates removed
        ]
        #expect(line.serviceDetailTextItems == expectedValues)
    }
}
