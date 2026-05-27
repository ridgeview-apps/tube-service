import Shared
import SwiftUI
import Models

struct ArrivalsBoardView: View {
    
    // MARK: Public state
    
    let platformName: String
    let cellItems: [ArrivalsBoardCellItem]
    
    @Binding var isExpanded: Bool
    
    var rotatingCellTimer = ObservableTimer.repeating(every: 3.0)
    
    
    // MARK: Private state
    
    @State private var rotationCellAnimated = false
    @State private var rotatingCellIndex: Int?
    
    private let collapsedStateMaxCellCount = 3
    
    // MARK: Body
    
    var body: some View {
        VStack(spacing: 20) {
            boardHeader
            cells
            expansionButton
        }
        .padding()
        .background(Color.arrivalsBoardBackground)
        .roundedBorder(Color.arrivalsBoardPrimary,
                       lineWidth: 4)
        .animation(.default, value: isExpanded)
        .shadow(color: .black.opacity(0.14), radius: 4, x: 0, y: 2)
    }
    
    
    // MARK: Layout views
    
    private var boardHeader: some View {
        Text(platformName)
            .font(.headline)
            .foregroundColor(.white)
    }
    
    private var cells: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(fixedCellItems) { cellItem in
                makeCell(with: cellItem)
                    .animation(nil, value: rotatingCellIndex)
            }
            if let rotatingCellItem {
                makeCell(with: rotatingCellItem)
                    .transition(.slideUp)
            }
        }
        .dynamicTypeSize(..<DynamicTypeSize.accessibility1)
        .animation(.default, value: isExpanded)
        .animation(rotationCellAnimated ? .default : nil, value: rotatingCellIndex)
        .task {
            rotateToNextArrivalIfNeeded(animated: false)
        }
        .onChange(of: rotatingCellTimer.firedAt) {
            rotateToNextArrivalIfNeeded(animated: true)
        }
    }
        
    private var isExpandable: Bool {
        cellItems.count > collapsedStateMaxCellCount
    }
    
    @ViewBuilder private var expansionButton: some View {
        if isExpandable {
            ExpansionInfoButton(
                style: .imageOnly,
                isExpanded: $isExpanded
            )
            .tint(.white)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .font(.caption)
        }
    }
    
    private var fixedCellItems: [ArrivalsBoardCellItem] {
        let showAll = !isExpandable || isExpanded
        if showAll {
            return cellItems
        } else {
            return Array(cellItems.prefix(collapsedStateMaxCellCount - 1))
        }
    }
    
    private var rotatingCellItem: ArrivalsBoardCellItem? {
        guard isExpandable && !isExpanded else {
            return nil
        }
        guard let rotatingCellIndex,
              cellItems.indices.contains(rotatingCellIndex) else {
            return nil
        }
        return cellItems[rotatingCellIndex]
    }
    
    private func makeCell(with cellItem: ArrivalsBoardCellItem) -> some View {
        HStack(alignment: .top, spacing: 12) {
            numberLabelView(for: cellItem)
            VStack(alignment: .leading, spacing: 4) {
                cellHeaderRow(with: cellItem.headerRow)
                if let footerRow = cellItem.footerRow {
                    cellFooterRow(with: footerRow)
                }
            }
        }
        .id(cellItem.id)
    }
    
    private func numberLabelView(for cellItem: ArrivalsBoardCellItem) -> some View {
        let label = cellItem.numberLabel
        return Text(label.valueText)
            .padding(2)
            .minimumScaleFactor(0.4)
            .foregroundColor(label.textColor)
            .shadow(color: label.textShadow.color,
                    radius: label.textShadow.radius,
                    x: label.textShadow.x,
                    y: label.textShadow.y)
            .frame(width: 28, height: 32)
            .background(label.backgroundColor)
            .roundedBorder(.white, cornerRadius: 4)
    }
    
    private func cellHeaderRow(with headerRow: ArrivalsBoardCellItem.HeaderRowState) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                switch headerRow.destination {
                case .towards(let towards):
                    cellText(for: .verbatim(towards))
                case .checkFrontOfTrain:
                    cellText(for: .localized(.arrivalsCheckFrontOfTrain))
                }
            }
            .font(.headline)
            
            Spacer()
            
            cellText(for: headerRow.countdownText)
                .font(.callout)
        }
        .strikethrough(headerRow.needsStrikethrough)
        .foregroundStyle(Color.arrivalsBoardPrimary)
    }
    
    @ViewBuilder
    private func cellFooterRow(with footerRow: ArrivalsBoardCellItem.FooterRowType) -> some View {
        switch footerRow {
        case .tubeLiveLocation(let currentLocation):
            tubeLiveLocationText(with: currentLocation)
        case .departureStatus(let departureStatusState):
            departureStatusInfo(with: departureStatusState)
        }
    }
    
    private func tubeLiveLocationText(with currentLocation: String) -> some View {
        HStack {
            cellText(for: .verbatim(currentLocation))
                .foregroundStyle(.white)
                .font(.caption)
        }
    }
    
    private func departureStatusInfo(with departureStatusState: ArrivalsBoardCellItem.DepartureStatusState) -> some View {
        HStack(alignment: .firstTextBaseline) {
            if let scheduledDepartureTime = departureStatusState.scheduledDeparture {
                cellText(for: scheduledDepartureTime)
                    .foregroundStyle(Color.arrivalsBoardPrimary)
            }
            
            if let estimatedDepartureTime = departureStatusState.estimatedDeparture {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Image(systemName: "exclamationmark.triangle")
                        .imageScale(.small)
                    cellText(for: estimatedDepartureTime)
                    
                }
                .foregroundStyle(.midRed1)
                .fontWeight(.semibold)
            }
            
            Spacer()
            
            if let statusText = departureStatusState.statusText {
                cellText(for: statusText)
                    .foregroundStyle(
                        departureStatusState.style == .warning ? .midRed1 : .white
                    )
                    .fontWeight(departureStatusState.style == .warning ? .semibold : .regular)
            }
        }
        .font(.footnote)
        .monospacedDigit()
    }
    
    private func cellText(for textType: ArrivalsBoardCellItem.TextType) -> some View {
        switch textType {
        case .verbatim(let rawString):
            Text(rawString)
        case .localized(let localizedStringResource):
            Text(localizedStringResource)
        }
    }
    
    private func rotateToNextArrivalIfNeeded(animated: Bool) {
        rotationCellAnimated = animated

        let canRotateToNextCell = isExpandable && !isExpanded
        guard canRotateToNextCell else {
            return
        }
        let firstRotatingCellIndex = collapsedStateMaxCellCount - 1

        if let rotatingCellIndex {
            let isLastIndex = rotatingCellIndex == cellItems.count - 1
            if isLastIndex {
                self.rotatingCellIndex = firstRotatingCellIndex
            } else {
                self.rotatingCellIndex = rotatingCellIndex + 1
            }
        } else {
            rotatingCellIndex = firstRotatingCellIndex
        }
    }
}

// MARK: - Convenience initializers

extension ArrivalsBoardView {
    
    init(boardState: ArrivalsBoardState,
         isExpanded: Binding<Bool>,
         rotatingCellTimer: ObservableTimer = .repeating(every: 3.0)) {
        self.init(platformName: boardState.platformName,
                  cellItems: boardState.cellItems,
                  isExpanded: isExpanded,
                  rotatingCellTimer: rotatingCellTimer)
    }
}


// MARK: - Previews

import ModelStubs

private struct WrapperView: View {
    var boardState: ArrivalsBoardState
    @State var isExpanded: Bool = false
    
    var body: some View {
        ScrollView {
            ArrivalsBoardView(boardState: boardState,
                              isExpanded: $isExpanded)
            .padding(.horizontal)
        }
    }
}

#Preview("Northern") {
    WrapperView(
        boardState: ModelStubs.northernLineBothPlatforms.toPlatformBoardStates().first!
    )
}

#Preview("Hammersmith, District & Circle") {
    WrapperView(
        boardState: ModelStubs.hammerDistrictAndCircleBothPlatforms.toPlatformBoardStates().first!
    )
}

#Preview("Elizabeth") {
    WrapperView(
        boardState: ModelStubs.elizabethLineArrivalsPlatformA.toPlatformBoardStates(forLineID: .elizabeth).first!
    )
}

#Preview("Mildmay") {
    WrapperView(
        boardState: ModelStubs.mildmayLineArrivalsPlatform2.toPlatformBoardStates(forLineID: .mildmay).first!
    )
}
