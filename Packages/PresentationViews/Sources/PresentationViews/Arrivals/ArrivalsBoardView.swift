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
        
    private var isExpandable: Bool {
        cellItems.count > collapsedStateMaxCellCount
    }
    
    @ViewBuilder private var expansionButton: some View {
        if isExpandable {
            ExpansionInfoButton(
                style: .imageAndText,
                isExpanded: $isExpanded
            )
            .padding(.vertical, 4)
            .foregroundStyle(.white)
            .buttonStyle(.bordered)
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
                topText(for: cellItem)
                bottomText(for: cellItem)
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
        case .boardPrimary:
            return boardPrimaryColor
        case .footerInfo:
            return .white
        case .footerWarning:
            return .midRed1
        }
    }
    
    private func topText(for cellItem: ArrivalsBoardCellItem) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            cellTextItem(for: cellItem.destinationText)
            Spacer()
            cellTextItem(for: cellItem.countdownText)
        }
    }
    
    @ViewBuilder
    private func bottomText(for cellItem: ArrivalsBoardCellItem) -> some View {
        switch cellItem.bottomTextMessage {
        case nil:
            EmptyView()
        case let .generalInfo(messageTextItem):
            if let messageTextItem {
                cellTextItem(for: messageTextItem)
            }
        case let .departureInfo(scheduledDepartureItem, estimatedDepartureItem, statusTextItem):
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                if let scheduledDepartureItem {
                    scheduledDepartureText(with: scheduledDepartureItem)
                }
                if let estimatedDepartureItem {
                    cellTextItem(for: estimatedDepartureItem)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.midRed1.opacity(0.25), in: .rect(cornerRadius: 4))
                }
                Spacer()
                if let statusTextItem {
                    cellTextItem(for: statusTextItem)
                }
            }
        }
    }
    
    private func scheduledDepartureText(with textItem: ArrivalsBoardTextItem) -> some View {
        cellTextItem(for: textItem)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Color.darkGrey1, in: .rect(cornerRadius: 4))
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
