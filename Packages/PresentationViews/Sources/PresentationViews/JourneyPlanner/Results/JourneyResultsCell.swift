import SwiftUI
import Models

public struct JourneyResultsCellItem: Identifiable {
    public var id: LineDiagramItemJourneyID { journeyDiagramID }
    public let journey: Journey
    public let journeyDiagramID: LineDiagramItemJourneyID
    public var isExpanded: Bool
    
    public init(journey: Journey,
                journeyDiagramID: LineDiagramItemJourneyID,
                isExpanded: Bool) {
        self.journey = journey
        self.journeyDiagramID = journeyDiagramID
        self.isExpanded = isExpanded
    }
}

struct JourneyResultsCell: View {
    
    @Binding var cellItem: JourneyResultsCellItem
    
    private var journey: Journey { cellItem.journey }
    private var journeyID: LineDiagramItem.JourneyID { cellItem.journeyDiagramID }
    
    @Namespace private var cellViewNameSpace
    
    @State private var expandedStopJourneyItemIDs: Set<LineDiagramItem.JourneyItemID> = []
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.5)) {
                cellItem.isExpanded.toggle()
            }
        } label: {
            VStack(alignment: .leading, spacing: 16) {
                disruptionsHeader
                journeyTimeInfo
                lineDiagram
            }
            .contentShape(Rectangle())
            .padding()
        }
        .buttonStyle(.plain)
        .cardStyle(cornerRadius: 8)
    }
    
    @ViewBuilder
    private var disruptionsHeader: some View {
        if !journey.realTimeDisruptionMessages.isEmpty {
            VStack {
                DisruptionsCell(
                    disruptionMessages: journey.realTimeDisruptionMessages
                )
                Divider()
            }
            .font(.footnote)
        }
    }
    
    
    private var journeyTimeInfo: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(journey.formattedStartEndTime)
                .font(.headline)
                .accessibilityIdentifier("journey.start.time.info")
            Spacer()
            Text(journey.formattedDuration)
                .font(.subheadline)
        }
    }
    
    private var lineDiagram: some View {
        HStack(alignment: cellItem.isExpanded ? .firstTextBaseline : .center) {
            LineDiagramView(animationNamespace: cellViewNameSpace,
                            orientation: cellItem.isExpanded ? .vertical : .horizontal,
                            journey: journey,
                            journeyID: journeyID,
                            expandedStopJourneyItemIDs: $expandedStopJourneyItemIDs)
            ExpansionInfoButton(style: .list,
                                isExpanded: $cellItem.isExpanded)

        }

    }
}

private extension Journey {
    
    var realTimeDisruptionMessages: [String] {
        (legs ?? [])
            .flatMap { $0.disruptions ?? [] }
            .filter { $0.category == .realTime }
            .removingDuplicates()
            .compactMap { $0.description }
    }
    
    var formattedStartEndTime: String {
        guard let startDateTime, let arrivalDateTime else { return "" }
        return DateIntervalFormatter.timeIntervalStyle.string(from: startDateTime, to: arrivalDateTime)
    }
    
    var formattedDuration: String {
        guard let duration else { return "" }
        let rawDuration = Duration.seconds(duration * 60)
        return rawDuration.formatted(.units(allowed: [.hours, .minutes]))
    }
}


// MARK: - Previews

import ModelStubs

private struct Previewer: View {
    @State var item: JourneyResultsCellItem
    
    init(journey: Journey,
         journeyDiagramID: LineDiagramItem.JourneyID = UUID().uuidString,
         isExpanded: Bool = false) {
        item = .init(journey: journey,
                     journeyDiagramID: journeyDiagramID,
                     isExpanded: isExpanded)
    }
    
    var body: some View {
        JourneyResultsCell(cellItem: $item)
    }
}

#Preview {
    ScrollView {
        LazyVStack(alignment: .leading) {
            Previewer(journey: ModelStubs.journeyByTube)
            Previewer(journey: ModelStubs.journeyByBike)
            Previewer(journey: ModelStubs.journeyByBoat)
            Previewer(journey: ModelStubs.journeyByBusLong)
            Previewer(journey: ModelStubs.journeyByBusShort)
            Previewer(journey: ModelStubs.journeyByCableCar)
            Previewer(journey: ModelStubs.journeyByNationalRail)
            Previewer(journey: ModelStubs.journeyByOverground)
            Previewer(journey: ModelStubs.journeyByWalking)
            Previewer(journey: ModelStubs.journeyWithLongTitleName)
            Previewer(journey: ModelStubs.journeyWithLongDisruptionMessage)
            
        }
        .padding(.horizontal)
    }
}

#Preview("Journey (long title name)") {
    ScrollView {
        LazyVStack(alignment: .leading) {
            Previewer(journey: ModelStubs.journeyWithLongTitleName)
        }
        .padding(.horizontal)
    }
}
