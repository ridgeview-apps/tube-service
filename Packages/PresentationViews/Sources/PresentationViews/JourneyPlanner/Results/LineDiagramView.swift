import Models
import SwiftUI

struct LineDiagramView: View {

    let animationNamespace: Namespace.ID
    let orientation: LineDiagramItem.Orientation
    let journey: Journey
    let journeyID: LineDiagramItem.JourneyID
    
    @Binding var expandedStopJourneyItemIDs: Set<LineDiagramItem.JourneyItemID>
    
    var body: some View {
        Group {
            switch orientation {
            case .horizontal:
                ScrollView(.horizontal) {
                    HStack(spacing: 0) { mainContent }
                        .padding(2)
                }
                .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
            case .vertical:
                VStack(alignment: .leading, spacing: 0) { mainContent }
            }
        }
        .background(Color.defaultCellBackground)
        .onChange(of: orientation) {
            expandedStopJourneyItemIDs.removeAll()
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        ForEach(lineDiagramItems) { item in
            LineDiagramItemView(
                item: item,
                animationNamespace: animationNamespace,
                orientation: orientation,
                showExpandedStopPoints: showExpandedStopPoints(for: item)
            )
        }
    }
    
    private func showExpandedStopPoints(for item: LineDiagramItem) -> Binding<Bool> {
        return .init {
            expandedStopJourneyItemIDs.contains(item.journeyItemID)
        } set: { isExpanded in
            if isExpanded {
                expandedStopJourneyItemIDs.insert(item.journeyItemID)
            } else {
                expandedStopJourneyItemIDs.remove(item.journeyItemID)
            }
        }
    }
    
    private var lineDiagramItems: [LineDiagramItem] {
        journey.allLegDiagramItems(forJourneyID: journeyID,
                                   orientation: orientation,
                                   expandedStopJourneyItemIDs: expandedStopJourneyItemIDs)
    }
}

private extension Journey {
    
    func allLegDiagramItems(
        forJourneyID journeyID: LineDiagramItem.JourneyID,
        orientation: LineDiagramItem.Orientation,
        expandedStopJourneyItemIDs: Set<LineDiagramItem.JourneyItemID>
    ) -> [LineDiagramItem] {
        (legs ?? [])
            .enumerated()
            .flatMap { legIndex, leg in
                let legID = String(legIndex)
                let isLastLeg = legs?.last == leg

                let verticalItemsConfig = JourneyLeg.VerticalItemsConfig(
                    journeyID: journeyID,
                    legID: legID,
                    isLastLeg: isLastLeg,
                    isShowingAllStops: expandedStopJourneyItemIDs.contains(.init(journeyID: journeyID, legID: legID))
                )
                
                let nextLeg = legIfExists(at: legIndex + 1)
                let isFinalVisibleLeg = nextLeg == legs?.last && nextLeg?.isWalkToEntranceOrExit == true

                let horizontalItemsConfig = JourneyLeg.HorizontalItemsConfig(
                    journeyID: journeyID,
                    legID: legID,
                    isLastLeg: isLastLeg,
                    isFirstLeg: legs?.first == leg,
                    isFinalVisibleLeg: isFinalVisibleLeg
                )
                
                
                return leg.diagramItems(forOrientation: orientation,
                                        verticalItemsConfig: verticalItemsConfig,
                                        horizontalItemsConfig: horizontalItemsConfig)
        }
    }
    
    private func legIfExists(at index: Int) -> JourneyLeg? {
        guard let legs, legs.indices.contains(index) else {
            return nil
        }
        return legs[index]
    }
    
}

private extension JourneyLeg {
    
    var isWalkToEntranceOrExit: Bool {
        let isAtSameLocation = departurePoint?.icsCode == arrivalPoint?.icsCode
        return isAtSameLocation && modeID == .walking
    }
    
    struct VerticalItemsConfig {
        let journeyID: LineDiagramItem.JourneyID
        let legID: LineDiagramItem.JourneyLegID
        let isLastLeg: Bool
        let isShowingAllStops: Bool
    }
    
    struct HorizontalItemsConfig {
        let journeyID: LineDiagramItem.JourneyID
        let legID: LineDiagramItem.JourneyLegID
        let isLastLeg: Bool
        let isFirstLeg: Bool
        let isFinalVisibleLeg: Bool
    }
    
    func diagramItems(
        forOrientation orientation: LineDiagramItem.Orientation,
        verticalItemsConfig: VerticalItemsConfig,
        horizontalItemsConfig: HorizontalItemsConfig
    ) -> [LineDiagramItem] {
        switch orientation {
        case .horizontal:
            horizontalDiagramItems(config: horizontalItemsConfig)
        case .vertical:
            verticalDiagramItems(config: verticalItemsConfig)
        }
    }
    
    func verticalDiagramItems(
        config: VerticalItemsConfig
    ) -> [LineDiagramItem] {

        var items = [LineDiagramItem]()
        
        let journeyID = config.journeyID
        let legID = config.legID
        
        items.append(departureStopPointItem(forJourneyID: journeyID, legID: legID, showsTrailingLine: true))

        let legDetailItems = legDetailItems(forJourneyID: journeyID, legID: legID, isShowingAllStops: config.isShowingAllStops)
        items.append(contentsOf: legDetailItems)
            
        if config.isLastLeg {
            items.append(arrivalStopPointItem(forJourneyID: journeyID, legID: legID))
        }
        
        return items
    }
    
    func horizontalDiagramItems(
        config: HorizontalItemsConfig
    ) -> [LineDiagramItem] {
        
        let journeyID = config.journeyID
        let legID = config.legID
        let isFirstLeg = config.isFirstLeg
        let isLastLeg = config.isLastLeg
        let isFinalVisibleLeg = config.isFinalVisibleLeg
        
        let skipThisItem = (isFirstLeg || isLastLeg) && isWalkToEntranceOrExit
        guard !skipThisItem else {
            return []
        }
        
        var items = [LineDiagramItem]()
        
        items.append(departureStopPointItem(forJourneyID: journeyID,
                                            legID: legID,
                                            showsTrailingLine: !isFinalVisibleLeg))
        
        if isLastLeg {
            items.append(arrivalStopPointItem(forJourneyID: journeyID, legID: legID))
        }
        
        return items
    }
    
    func departureStopPointItem(forJourneyID journeyID: LineDiagramItem.JourneyID, 
                                legID: LineDiagramItem.JourneyLegID,
                                showsTrailingLine: Bool) -> LineDiagramItem {
        .init(
            id: .init(type: .departurePoint(name: departurePoint?.sanitizedName ?? "",
                                            time: departureTime),
                      journeyItemID: .init(journeyID: journeyID, legID: legID)),
            style: stopPointCircleOrImage(trailingLine: showsTrailingLine)
        )
    }
    
    func arrivalStopPointItem(forJourneyID journeyID: LineDiagramItem.JourneyID, legID: LineDiagramItem.JourneyLegID) -> LineDiagramItem {
        .init(
            id: .init(type: .arrivalPoint(name: arrivalPoint?.sanitizedName ?? "",
                                          time: arrivalTime),
                      journeyItemID: .init(journeyID: journeyID, legID: legID)),
            style: stopPointCircleOrImage(trailingLine: false)
        )
    }
    
    func legDetailItems(forJourneyID journeyID: LineDiagramItem.JourneyID,
                        legID: LineDiagramItem.JourneyLegID,
                        isShowingAllStops: Bool) -> [LineDiagramItem] {
        var legDetailItems = [LineDiagramItem]()
        
        // Leg detail item
        let mainItem = LineDiagramItem(
            id: .init(
                type: .legDetail(
                    .init(durationMinutes: duration,
                          instructionSummary: instruction?.summary ?? "",
                          stopPointsCount: sanitizedStopPoints.count + 1)
                ),
                journeyItemID: .init(journeyID: journeyID, legID: legID)
            ),
            style: .straightLine(lineStyleForLineOrMode()),
            detailItemPadding: .init(top: 8, bottom: 8)
        )
        legDetailItems.append(mainItem)
        
        // Leg stop point ticks
        if isShowingAllStops {
            let stopPointTickItems = stopPointTickItems(forJourneyID: journeyID, legID: legID)
            legDetailItems.append(contentsOf: stopPointTickItems)
        }
        
        return legDetailItems
    }
        
    func stopPointTickItems(forJourneyID journeyID: LineDiagramItem.JourneyID, 
                            legID: LineDiagramItem.JourneyLegID) -> [LineDiagramItem] {
        let stopPointTickItems = sanitizedStopPoints.map { stopPoint in
            LineDiagramItem(
                id: .init(type: .stopPointTickItem(name: stopPoint.sanitizedStopPointName ?? ""),
                          journeyItemID: .init(journeyID: journeyID,
                                               legID: legID)),
                style: .stopPointTick(lineStyleForLineOrMode(), position: .center),
                detailItemPadding: .init(
                    top: stopPoint == sanitizedStopPoints.first ? 8 : 4,
                    bottom: stopPoint == sanitizedStopPoints.last ? 12 : 4
                )
            )
        }

        return stopPointTickItems
    }
    
    func lineStyleForLineOrMode() -> LineDiagramItem.Style.LineStyle {
        switch (trainLineID, modeID) {
        case (let trainLineID?, _):
            return .init(trainLineID: trainLineID)
        case (_, let modeID?):
            return .init(modeID: modeID)
        default:
            assertionFailure("Unsupported line style for journey leg \(self)")
            return .invisible
        }
    }
    
    func stopPointCircleOrImage(trailingLine: Bool) -> LineDiagramItem.Style {
        switch (trainLineID, modeID) {
        case (let trainLineID?, _):
            return .stopPointCircle(trainLineID, hasTrailingLine: trailingLine)
        case (_, let modeID?):
            return .stopPointImage(modeID, hasTrailingLine: trailingLine)
        default:
            assertionFailure("Unsupported stop point style for journey leg \(self)")
            return .straightLine(.invisible)
        }
    }
    
    var sanitizedStopPoints: [TflIdentifier] {
        stopPoints
            .removingDuplicates()
            .filter { $0 != stopPoints.last && !($0.name ?? "").isEmpty }
    }
}

extension StopPoint {
    var sanitizedName: String? { commonName?.sanitizedStopPointName }
}

private extension TflIdentifier {
    var sanitizedStopPointName: String? { name?.sanitizedStopPointName }
}

private extension String {
    var sanitizedStopPointName: String? {
        self
            .replacingOccurrences(of: "Underground Station", with: "")
            .replacingOccurrences(of: "DLR Station", with: "")
            .replacingOccurrences(of: "Tram Stop", with: "")
            .replacingOccurrences(of: "Rail Station", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}


// MARK: - Previews

import ModelStubs

private struct Previewer: View {
    
    @Namespace private var animationNamespace
    @State var orientation: LineDiagramItem.Orientation = .horizontal
    @State var expandedStopJourneyItemIDs: Set<LineDiagramItem.JourneyItemID> = []
    let journey: Journey
    var journeyID: LineDiagramItem.JourneyID = UUID().uuidString
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.orientation = orientation == .horizontal ? .vertical : .horizontal
            }
        } label: {
            LineDiagramView(
                animationNamespace: animationNamespace,
                orientation: orientation,
                journey: journey,
                journeyID: journeyID,
                expandedStopJourneyItemIDs: $expandedStopJourneyItemIDs
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ScrollView {
        LazyVStack(alignment: .leading, spacing: 20) {
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
    }
}
