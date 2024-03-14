import SwiftUI
import Models

struct JourneyResultsCell: View {
    
    let journey: Journey
    let journeyID: LineDiagramItem.JourneyID
    var isInitiallyExpanded: Bool = false
    
    @Namespace private var cellViewNameSpace
    @ScaledMetric private var dynamicTextScale = 1
    
    @State private var expandedStopJourneyItemIDs: Set<LineDiagramItem.JourneyItemID> = []
    @State private var isExpanded = false
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.5)) {
                isExpanded.toggle()
            }
        } label: {
            VStack(alignment: .leading) {
                disruptionsCell
                HStack {
                    Text(journey.formattedStartEndTime)
                    Spacer()
                    Text(journey.formattedDuration)
                }
                .font(.headline)
                
                HStack(alignment: isExpanded ? .firstTextBaseline : .center) {
                    LineDiagramView(animationNamespace: cellViewNameSpace,
                                    orientation: isExpanded ? .vertical : .horizontal,
                                    journey: journey,
                                    journeyID: journeyID,
                                    expandedStopJourneyItemIDs: $expandedStopJourneyItemIDs)
                }
            }
            .contentShape(Rectangle())
            .padding()
        }
        .buttonStyle(.plain)
        .cardStyle()
        .task {
            if isInitiallyExpanded {
                isExpanded = true
            }
        }
    }
    
    @ViewBuilder
    private var disruptionsCell: some View {
        if !journey.realTimeDisruptionMessages.isEmpty {
            DisruptionsCell(
                disruptionMessages: journey.realTimeDisruptionMessages
            )
            .font(.subheadline)
            .padding(.bottom, 4)
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

private struct Previewer: View {
    let journey: Journey
    var journeyID: LineDiagramItem.JourneyID = UUID().uuidString
    
    var body: some View {
        JourneyResultsCell(journey: journey, journeyID: journeyID)
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
