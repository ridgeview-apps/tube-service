import Combine
import Shared
import SwiftUI
import Models

struct ArrivalsBoardView: View {
    
    // MARK: Public state
    
    let platformName: String
    let cellItems: [ArrivalsBoardCellItem]
    
    @Binding var isExpanded: Bool
    
    var rotatingCellTimerPublisher: AnyPublisher<Date, Never> = Timer.autoconnectedPublisher(every: 3)
    
    
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
        .background(Color.darkGrey2)
        .roundedBorder(boardTextColor,
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
        VStack(alignment: .leading, spacing: 16) {
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
        .onReceive(rotatingCellTimerPublisher) { _ in
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
            ZStack {
                cellItem.numberLabel.backgroundColor
                    .frame(width: 36, height: 40)
                Text(cellItem.numberLabel.valueText)
                    .foregroundColor(cellItem.numberLabel.textColor)
                    .shadow(color: cellItem.numberLabel.textShadow.color,
                            radius: cellItem.numberLabel.textShadow.radius,
                            x: cellItem.numberLabel.textShadow.x, 
                            y: cellItem.numberLabel.textShadow.y)
            }
            .roundedBorder(.white)
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    destinationText(for: cellItem.destinationType)
                    Spacer()
                    if let secondsToArrival = cellItem.secondsToArrival {
                        arrivalTimeText(for: secondsToArrival)
                    }
                }
                .font(.headline)
                .foregroundColor(boardTextColor)
                if let subtitleType = cellItem.subtitleType {
                    subtitleText(for: subtitleType)
                }
            }
        }
        .id(cellItem.id)
    }
    
    private var boardTextColor: Color { .rgb(198, 188, 61) }
    
    @ViewBuilder private func arrivalTimeText(for secondsRemaining: Int) -> some View {
        if secondsRemaining < 30 {
            Text("arrivals.board.countdown.due", bundle: .module)
        } else if secondsRemaining < 60 {
            Text("arrivals.board.countdown.due.seconds \(secondsRemaining)", bundle: .module)
        } else {
            let minutes = secondsRemaining / 60
            Text("arrivals.board.countdown.due.minutes \(minutes)", bundle: .module)
        }
    }
    
    @ViewBuilder private func destinationText(for destinationType: ArrivalsBoardDestinationType) -> some View {
        switch destinationType {
        case let .destination(name):
            Text(name)
        case .checkFrontOfTrain:
            Text("arrivals.check.front.of.train", bundle: .module)
        }
    }
    
    private func subtitleText(for subtitleType: ArrivalsBoardSubtitleType) -> some View {
        Group {
            switch subtitleType {
            case let .currentLocationName(name):
                Text(name)
            case let .depatureTime(time):
                Text("arrivals.board.departs.at \(time)", bundle: .module)
            }
        }
        .font(.caption2)
        .foregroundColor(.white)
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
         rotatingCellTimerPublisher: AnyPublisher<Date, Never> = Timer.autoconnectedPublisher(every: 3)) {
        self.init(platformName: boardState.platformName,
                  cellItems: boardState.cellItems,
                  isExpanded: isExpanded,
                  rotatingCellTimerPublisher: rotatingCellTimerPublisher)
    }
}


// MARK: - Previews

struct ArrivalsBoardView_Previews: PreviewProvider {
    
    struct WrapperView: View {
        var boardState: ArrivalsBoardState
        @State var isExpanded: Bool = false
        
        var body: some View {
            ArrivalsBoardView(boardState: boardState,
                              isExpanded: $isExpanded)
            .padding(.horizontal)
        }
    }
    
    static var previews: some View {
        WrapperView(boardState: northernLineBoard)
            .previewDisplayName("Northern)")
        WrapperView(boardState: hammersmithDistrictAndCircleBoard)
            .previewDisplayName("Hammersmith, District & Circle")
        WrapperView(boardState: elizabethLineBoard)
            .previewDisplayName("Elizabeth")
    }
    
    static var northernLineBoard: ArrivalsBoardState {
        ModelStubs.northernLineBothPlatforms.toPlatformBoardStates().first!
    }
    
    static var hammersmithDistrictAndCircleBoard: ArrivalsBoardState {
        ModelStubs.hammerDistrictAndCircleBothPlatforms.toPlatformBoardStates().first!
    }
    
    static var elizabethLineBoard: ArrivalsBoardState {
        ModelStubs.elizabethLineBothPlatforms.toPlatformBoardStates(forLineID: .elizabeth).first!
    }
}
