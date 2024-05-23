import Models
import SwiftUI

struct LineDiagramItemView: View {
    
    @ScaledMetric var scaleFactor = 1
    
    var containerThickness: CGFloat { 30.0 * scaleFactor }
    var lineThickness: CGFloat { 4.0 * scaleFactor }
    var tubeLineTitleFont: Font { .system(size: 20 * scaleFactor) }
    
    let item: LineDiagramItem
    let animationNamespace: Namespace.ID
    let orientation: LineDiagramItem.Orientation
    
    @Binding var showExpandedStopPoints: Bool
        
    private var stopPointTickLength: CGFloat { lineThickness * 2/3 }
    
    @State private var detailViewHeight: CGFloat = 0
    
    var body: some View {
        switch orientation {
        case .horizontal:
            HStack(spacing: 0) { diagramContent }
        case .vertical:
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    diagramContent
                }
                .frame(height: detailViewHeight, alignment: .top)
                detailView
                    .frame(minHeight: detailViewMinHeight)
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    .readSize {
                        detailViewHeight = $0.height
                    }
            }
        }
    }
    
    private var detailViewMinHeight: CGFloat {
        switch item.style.elementType {
        case .stopPointCircle, .stopPointImage, .straightLine:
            return containerThickness
        case .stopPointTick:
            return 0
        }
    }
    
    @ViewBuilder
    private var diagramContent: some View {
        Group {
            Group {
                switch item.style.elementType {
                case let .stopPointCircle(textOverlay):
                    stopPointCircle(textOverlay: textOverlay)
                case let .stopPointImage(image):
                    stopPointImage(image: image)
                case let .stopPointTick(position):
                    stopPointTick(position: position)
                case .straightLine:
                    straightLine()
                }
            }
            .matchedGeometryEffect(id: "mainItem_\(item.id)", in: animationNamespace)
            if item.style.hasTrailingLine {
                straightLine()
                    .matchedGeometryEffect(id: "trailingLine_\(item.id)", in: animationNamespace)
            }
        }
    }
    
    
    @ViewBuilder
    private func stopPointCircle(textOverlay: LineDiagramItem.Style.CircleTextOverlay) -> some View {
        Circle()
            .fill(item.style.lineStyle.color)
            .frame(width: containerThickness,
                   height: containerThickness)
            .overlay {
                Circle()
                    .stroke(lineWidth: 2.0)
                    .fill(item.style.lineStyle.color)
                    .overlay {
                        Text(textOverlay.text)
                            .font(tubeLineTitleFont)
                            .foregroundStyle(textOverlay.color)
                    }
            }
    }
    
    @ViewBuilder
    private func stopPointImage(image: Image) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(lineWidth: 2.0 * scaleFactor)
            .fill(item.style.lineStyle.color)
            .frame(width: containerThickness,
                   height: containerThickness)
            .overlay {
                image
                    .resizable()
                    .scaledToFit()
                    .padding(4)
                    .foregroundStyle(item.style.lineStyle.color)
                    
            }
    }
    
    @ViewBuilder
    private func stopPointTick(position: LineDiagramItem.Style.TickPosition) -> some View {
        straightLine()
            .overlay(
                alignment: position.alignment(for: orientation)
            ) {
                switch orientation {
                case .horizontal:
                    Rectangle()
                        .fill(item.style.lineStyle.color)
                        .frame(
                            width: stopPointTickLength,
                            height: lineThickness + stopPointTickLength
                        )
                        .offset(y: -stopPointTickLength / 2.0)
                case .vertical:
                    Rectangle()
                        .fill(item.style.lineStyle.color)
                        .frame(
                            width: lineThickness + stopPointTickLength,
                            height: stopPointTickLength
                        )
                        .offset(x: stopPointTickLength / 2.0)
                        .offset(y: (item.detailItemPadding.top - item.detailItemPadding.bottom) / 2.0)
                }
            }
    }
        
    @ViewBuilder
    private func straightLine() -> some View {
        Group {
            switch item.style.lineStyle.fill {
            case .solid:
                filledLine(lineWidth: lineThickness,
                           fill: item.style.lineStyle.color)
            case .double:
                filledLine(lineWidth: lineThickness,
                           fill: item.style.lineStyle.color)
                .overlay {
                    filledLine(lineWidth: lineThickness * 1/3, fill: .white)
                }
            case .dashed:
                filledLine(lineWidth: lineThickness,
                           fill: item.style.lineStyle.color,
                           dash: [2])
            }
        }
        .frame(
            maxWidth: orientation == .vertical ? containerThickness : 16,
            maxHeight: orientation == .horizontal ? containerThickness : .infinity
        )
    }
    
    @ViewBuilder
    private func filledLine(
        lineWidth: CGFloat,
        fill fillColor: Color,
        dash: [CGFloat] = []
    ) -> some View {
        switch orientation {
        case .horizontal:
            HLine()
                .stroke(style: .init(lineWidth: lineWidth, dash: dash))
                .fill(fillColor)
        case .vertical:
            VLine()
                .stroke(style: .init(lineWidth: lineWidth, dash: dash))
                .fill(fillColor)
        }
    }
    
    @ViewBuilder
    private var detailView: some View {
        Group {
            switch item.type {
            case let .departurePoint(name, time),
                let .arrivalPoint(name, time):
                mainStopPointDetailView(name: name, time: time)
            case let .legDetail(detail):
                legDetailView(with: detail)
            case let .stopPointTickItem(name):
                Text(name)
                    .font(.subheadline)
                    .lineLimit(1)
            }
        }
        .padding(.top, item.detailItemPadding.top * scaleFactor)
        .padding(.bottom, item.detailItemPadding.bottom * scaleFactor)
    }
    
    @ViewBuilder
    private func mainStopPointDetailView(name: String, time: Date?) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(name)
                .font(.headline)
            if let time {
                Spacer()
                Text(time.formatted(date: .omitted,
                                    time: .shortened))
                .font(.callout)
            }
        }
        .lineLimit(3)
    }
    
    @ViewBuilder
    private func legDetailView(with detail: LineDiagramItem.LegDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(detail.instructionSummary)
                    .font(.subheadline)
                Spacer()
                if let durationMinutes = detail.durationMinutes {
                    Text(formattedDuration(for: durationMinutes))
                        .font(.caption)
                }
            }
            .foregroundStyle(.secondary)
            
            if detail.shouldShowStopPointsToggle {
                ExpansionInfoButton(style: .pullDown,
                                    title: "journey.planner.stops.count \(detail.stopPointsCount)",
                                    isExpanded: $showExpandedStopPoints)
                .font(.subheadline)
            }
            
        }
    }
    
    private func formattedDuration(for durationMinutes: Int) -> String {
        let rawDuration = Duration.seconds(durationMinutes * 60)
        return rawDuration.formatted(.units(allowed: [.hours, .minutes]))
    }
}


private extension LineDiagramItem.Style.TickPosition {
    func alignment(for orientation: LineDiagramItem.Orientation) -> Alignment {
        switch self {
        case .start: (orientation == .horizontal) ? .leading : .top
        case .end: (orientation == .horizontal) ? .trailing : .bottom
        case .center: .center
        }
    }
}

// MARK: - Previews

private struct Previewer: View {
    @State private var showExpandedStopPoints = false
    var orientation: LineDiagramItem.Orientation = .horizontal
    @Namespace private var animationNamespace
    
    var body: some View {
        List {
            Section("Stop point circles") {
                makeItemView(itemType: .departurePoint(name: "Circle example 1", time: .now),
                             style: .stopPointCircle(.bakerloo, hasTrailingLine: true))
                makeItemView(itemType: .arrivalPoint(name: "Circle example 2", time: .now),
                             style: .stopPointCircle(.bakerloo, hasTrailingLine: false))
            }
            Section("Stop point images") {
                makeItemView(itemType: .departurePoint(name: "Image example 1", time: .now),
                             style: .stopPointImage(.bus, hasTrailingLine: true))
                makeItemView(itemType: .arrivalPoint(name: "Image example 2", time: .now),
                             style: .stopPointImage(.bus, hasTrailingLine: false))
                makeItemView(itemType: .departurePoint(name: "Image example 3", time: .now),
                             style: .stopPointImage(.walking, hasTrailingLine: true))
            }
            Section("Stop point ticks") {
                makeItemView(itemType: .stopPointTickItem(name: "Tick example 1"),
                             style: .stopPointTick(.init(trainLineID: .hammersmithAndCity), position: .start))
                makeItemView(itemType: .stopPointTickItem(name: "Tick example 2"),
                             style: .stopPointTick(.init(trainLineID: .hammersmithAndCity), position: .center))
                makeItemView(itemType: .stopPointTickItem(name: "Tick example 3"),
                             style: .stopPointTick(.init(trainLineID: .hammersmithAndCity), position: .end))
                makeItemView(itemType: .stopPointTickItem(name: "Padded tick example"),
                             style: .stopPointTick(.init(trainLineID: .hammersmithAndCity), position: .center),
                             detailItemPadding: .init(top: 30, bottom: 10))
                
            }
            Section("Straight lines") {
                makeItemView(itemType: .legDetail(.init(durationMinutes: 60,
                                                        instructionSummary: "Solid line example",
                                                        stopPointsCount: 4)),
                             style: .straightLine(.init(trainLineID: .district)))
                makeItemView(itemType: .legDetail(.init(durationMinutes: 120,
                                                        instructionSummary: "Double line example",
                                                        stopPointsCount: 4)),
                             style: .straightLine(.init(trainLineID: .overground)))
                makeItemView(itemType: .legDetail(.init(durationMinutes: 120,
                                                        instructionSummary: "Dotted line example",
                                                        stopPointsCount: 0)),
                             style: .straightLine(.init(modeID: .walking)))
            }
        }
    }
    
    private func makeItemView(itemType: LineDiagramItem.ItemType,
                              style: LineDiagramItem.Style,
                              detailItemPadding: LineDiagramItem.Style.DetailItemPadding = .zero) -> some View {
        LineDiagramItemView(item: .init(id: .init(type: itemType,
                                                  journeyItemID: .init(journeyID: UUID().uuidString,
                                                                       legID: UUID().uuidString)),
                                        style: style,
                                        detailItemPadding: detailItemPadding),
                            animationNamespace: animationNamespace,
                            orientation: orientation,
                            showExpandedStopPoints: $showExpandedStopPoints)
    }
}

#Preview("Horizontal components") {
    Previewer(orientation: .horizontal)
}

#Preview("Vertical components") {
    Previewer(orientation: .vertical)
}
