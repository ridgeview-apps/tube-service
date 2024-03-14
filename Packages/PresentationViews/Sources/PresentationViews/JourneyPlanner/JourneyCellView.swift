import SwiftUI
import Models

struct JourneyCellView: View {
    
    let journey: Journey
    let journeyID: LineDiagramItem.JourneyID
    
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
                HStack {
                    Text(journey.formattedStartEndTime)
                    Spacer()
                    Text(journey.formattedDuration)
                }
                .font(.headline)
                
                LineDiagramView(animationNamespace: cellViewNameSpace,
                                orientation: isExpanded ? .vertical : .horizontal,
                                journey: journey,
                                journeyID: journeyID,
                                expandedStopJourneyItemIDs: $expandedStopJourneyItemIDs)
            }
            .contentShape(Rectangle())
            .padding()
        }
        .buttonStyle(.plain)
        .cardStyle()
    }
}

extension Journey {
    
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
        JourneyCellView(journey: journey, journeyID: journeyID)
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
        }
        .padding(.horizontal)
    }
}
