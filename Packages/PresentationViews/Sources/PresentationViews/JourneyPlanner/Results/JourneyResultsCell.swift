import SwiftUI
import Models

public enum JourneyResultsAction {
    case initialFetch
    case refresh
    case earlierJourneys
    case laterJourneys
    case customPresetTapped
}

struct JourneyResultsCell: View {

    let value: JourneyResultsCellItem
    let isExpanded: Bool
    let onToggle: () -> Void

    private var journey: Journey { value.journey }
    private var journeyID: LineDiagramItem.JourneyID { value.journeyDiagramID }

    @Namespace private var cellViewNameSpace

    @State private var expandedStopJourneyItemIDs: Set<LineDiagramItem.JourneyItemID> = []

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.5)) {
                onToggle()
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
        .cardStyle()
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
            startAndEndTime
            Spacer()
            Text(journey.formattedDuration)
                .font(.subheadline)

        }
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("journey.start.time.info")
    }

    private var startAndEndTime: some View {
        HStack(spacing: 8) {
            if let startDateTime = journey.startDateTime {
                Text(startDateTime.formatted(date: .omitted, time: .shortened))
            }
            Image(systemName: "arrow.right")
                .imageScale(.small)
                .foregroundStyle(.secondary)
            if let arrivalDateTime = journey.arrivalDateTime {
                Text(arrivalDateTime.formatted(date: .omitted, time: .shortened))
            }
        }
        .font(.headline)
    }

    private var lineDiagram: some View {
        HStack(alignment: isExpanded ? .firstTextBaseline : .center) {
            LineDiagramView(
                animationNamespace: cellViewNameSpace,
                orientation: isExpanded ? .vertical : .horizontal,
                journey: journey,
                journeyID: journeyID,
                expandedStopJourneyItemIDs: $expandedStopJourneyItemIDs
            )
            .overlay(alignment: .trailing) {
                if !isExpanded {
                    LinearGradient(
                        colors: [.clear, Color.defaultCellBackground],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 44)
                    .allowsHitTesting(false)
                }
            }
            ExpansionInfoButton(
                style: .imageOnly,
                isExpanded: Binding(get: { isExpanded }, set: { _ in onToggle() })
            )
            .buttonStyle(.bordered)
            .controlSize(.small)
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

    var formattedDuration: String {
        guard let duration else { return "" }
        let rawDuration = Duration.seconds(duration * 60)
        return rawDuration.formatted(.units(allowed: [.hours, .minutes]))
    }
}


// MARK: - Previews

import ModelStubs

private struct Previewer: View {
    let journey: Journey
    @State private var isExpanded: Bool = false

    var body: some View {
        JourneyResultsCell(
            value: JourneyResultsCellItem(journey: journey, journeyDiagramID: UUID().uuidString),
            isExpanded: isExpanded,
            onToggle: { isExpanded.toggle() }
        )
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
