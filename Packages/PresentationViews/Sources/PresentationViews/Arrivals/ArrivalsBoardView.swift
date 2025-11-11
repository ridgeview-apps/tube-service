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
    private let boardPrimaryColor = Color.rgb(198, 188, 61)
    
    // MARK: Body
    
    var body: some View {
        VStack(spacing: 20) {
            boardHeader
            cells
            expansionButton
        }
        .padding()
        .background(Color.darkGrey2)
        .roundedBorder(boardPrimaryColor,
                       cornerRadius: 12,
                       lineWidth: 4)
        .animation(.default, value: isExpanded)
        .shadow(color: .black.opacity(0.14), radius: 4, x: 0, y: 2)
    }
    
    
    // MARK: Layout views
    
    private var boardHeader: some View {
        VStack(spacing: 4) {
            Text(platformName)
                .font(.headline)
            HStack(spacing: 8) {
                clockView
            }
        }
        .foregroundColor(.white)
    }
    
    private var cells: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(fixedCellItems) { cellItem in
                makeCell(with: cellItem)
            }
            if let rotatingCellItem {
                makeCell(with: rotatingCellItem)
                    .transition(.slideUp)
            }
        }
        .animation(.default, value: isExpanded)
        .animation(rotationCellAnimated ? .default : nil, value: rotatingCellIndex)
        .task {
            rotateToNextArrivalIfNeeded(animated: false)
        }
        .onChange(of: rotatingCellTimer.firedAt) {
            rotateToNextArrivalIfNeeded(animated: true)
        }
    }
    
    private var clockView: some View {
        Text(Date(), formatter: .shortTimeStyle)
            .font(.subheadline)
    }
    
    private var isExpandable: Bool {
        cellItems.count > collapsedStateMaxCellCount
    }
    
    @ViewBuilder private var expansionButton: some View {
        if isExpandable {
            ExpansionInfoButton(style: .pullDown,
                                isExpanded: $isExpanded)
                .foregroundColor(.white)
                .padding([.top, .bottom], 4)
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
                topText(for: cellItem)
                bottomText(for: cellItem)
            }
        }
        .id(cellItem.id)
    }
    
    private func numberLabelView(for cellItem: ArrivalsBoardCellItem) -> some View {
        Text(cellItem.numberLabel.valueText)
            .padding(2)
            .minimumScaleFactor(0.4)
            .foregroundColor(cellItem.numberLabel.textColor)
            .shadow(color: cellItem.numberLabel.textShadow.color,
                    radius: cellItem.numberLabel.textShadow.radius,
                    x: cellItem.numberLabel.textShadow.x,
                    y: cellItem.numberLabel.textShadow.y)
            .frame(width: 28, height: 32)
            .background(cellItem.numberLabel.backgroundColor)
            .roundedBorder(.white)
    }
    
    @ViewBuilder
    private func cellTextItem(for textItem: ArrivalsBoardTextItem) -> some View {
        Group {
            switch textItem.messageType {
            case .verbatim(let rawString):
                Text(rawString)
            case .localized(let localizedStringResource):
                Text(localizedStringResource)
            }
        }
        .font(textItem.font)
        .foregroundStyle(textColor(for: textItem))
        .strikethrough(textItem.isStrikethrough)
    }
    
    private func textColor(for textItem: ArrivalsBoardTextItem) -> Color {
        switch textItem.colorStyle {
        case .headerInfo:
            return boardPrimaryColor
        case .footerInfo:
            return .white
        case .footerWarning:
            return .midRed1
        }
    }
    
    private func topText(for cellItem: ArrivalsBoardCellItem) -> some View {
        HStack(alignment: .top) {
            cellTextItem(for: cellItem.destinationText)
            Spacer()
            cellTextItem(for: cellItem.countdownText)
        }
    }
    
    @ViewBuilder
    private func bottomText(for cellItem: ArrivalsBoardCellItem) -> some View {
        if let bottomTextMessage = cellItem.bottomTextMessage {
            switch bottomTextMessage {
            case let .generalInfo(messageTextItem):
                if let messageTextItem {
                    cellTextItem(for: messageTextItem)
                }
            case let .departureInfo(scheduledDepartureItem, estimatedDepartureItem, statusTextItem):
                HStack {
                    if let scheduledDepartureItem {
                        departureTimeText(with: scheduledDepartureItem)
                    }
                    if let estimatedDepartureItem {
                        departureTimeText(with: estimatedDepartureItem)
                    }
                    Spacer()
                    if let statusTextItem {
                        cellTextItem(for: statusTextItem)
                    }
                }
            }
        }
    }
    
    private func departureTimeText(with textItem: ArrivalsBoardTextItem) -> some View {
        cellTextItem(for: textItem)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.darkGrey1)
            .clipShape(.rect(cornerRadius: 4))
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
