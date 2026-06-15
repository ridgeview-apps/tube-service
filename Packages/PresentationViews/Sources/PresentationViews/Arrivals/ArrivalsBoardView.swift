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
        .roundedBorder(
            Color.arrivalsBoardPrimary,
            lineWidth: 4
        )
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
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
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
            cellItems.indices.contains(rotatingCellIndex)
        else {
            return nil
        }
        return cellItems[rotatingCellIndex]
    }

    private func makeCell(with cellItem: ArrivalsBoardCellItem) -> some View {
        ArrivalsBoardCellView(item: cellItem)
            .id(cellItem.id)
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

    init(
        boardState: ArrivalsBoardState,
        isExpanded: Binding<Bool>,
        rotatingCellTimer: ObservableTimer = .repeating(every: 3.0)
    ) {
        self.init(
            platformName: boardState.platformName,
            cellItems: boardState.cellItems,
            isExpanded: isExpanded,
            rotatingCellTimer: rotatingCellTimer
        )
    }
}


// MARK: - Previews

import ModelStubs

private struct WrapperView: View {
    var boardState: ArrivalsBoardState
    @State var isExpanded: Bool = false

    var body: some View {
        ScrollView {
            ArrivalsBoardView(
                boardState: boardState,
                isExpanded: $isExpanded
            )
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
