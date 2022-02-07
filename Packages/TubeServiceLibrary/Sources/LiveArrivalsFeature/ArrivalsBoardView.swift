import ComposableArchitecture
import Model
import ModelUI
import ModelFakes
import SharedViews
import StyleGuide
import SwiftUI

public typealias ArrivalsBoardStore = Store<ArrivalsBoard.State, ArrivalsBoard.Action>

public struct ArrivalsBoardView: View {
     
    private let store: ArrivalsBoardStore
    @ObservedObject private var viewStore: ViewStore<ArrivalsBoard.State, ArrivalsBoard.Action>
    
    public init(store: ArrivalsBoardStore) {
        self.store = store
        self.viewStore = ViewStore(store)
    }


    public var body: some View {
        VStack(spacing: 20) {
            boardHeader
            arrivalRows
            expansionButton
        }
        .padding()
        .background(Color.darkGrey2)
        .roundedBorder(Color.boardText,
                       cornerRadius: 16,
                       lineWidth: 4)
        .animation(.default, value: viewStore.isExpanded)
        .shadow(color: .black.opacity(0.14), radius: 4, x: 0, y: 2)
        
        
    }
    
    private var boardHeader: some View {
        VStack(spacing: 4) {
            Text(viewStore.platformTitleText)
                .font(.headline)
            HStack(spacing: 8) {
                if viewStore.animationState == .refreshing {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                }
                Text(viewStore.timeText)
                    .font(.subheadline)
            }
        }
        .foregroundColor(.white)
    }
    
    private var arrivalRows: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(viewStore.fixedRows) { row in
                ArrivalsBoardRowView(row: row)
                    .animation(nil, value: row)
            }
            if let rotatingRow = viewStore.rotatingRow {
                ArrivalsBoardRowView(row: rotatingRow)
                    .transition(.slideUp)
            }
        }
        .transition(viewStore.isExpanded ? .identity : .slide)
        .animation(.default, value: viewStore.rotatingRow)
    }
    
    @ViewBuilder private var expansionButton: some View {
        let isExpanded = viewStore.binding(
            get: \.isExpanded,
            send: ArrivalsBoard.Action.setExpanded
        )

        if viewStore.isExpandable {
            ExpansionInfoButton(style: .pullDown,
                                isExpanded: isExpanded)
                .foregroundColor(.white)
        }
    }
}


private struct ArrivalsBoardRowView: View {
    
    let row: ArrivalsBoard.State.RowState
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                row.lineId.backgroundColor
                    .frame(width: 35, height: 35)
                Text(row.arrivalNumberText)
                    .foregroundColor(row.lineId.textColor)
            }
            .border(Color.white)
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    destinationText
                        .font(.headline)
                        .foregroundColor(.boardText)
                    Spacer()
                    countdownText
                        .font(.headline)
                        .foregroundColor(.boardText)
                }
                Text(row.locationText ?? "")
                    .font(.caption2)
                    .foregroundColor(.white)
            }
        }
        .id(row.id)
    }
    
    @ViewBuilder private var destinationText: some View {
        switch row.destination {
        case .destination(let name):
            Text(name)
        case .checkFrontOfTrain:
            Text("arrivals.check.front.of.train", bundle: .module)
        }
    }
    
    @ViewBuilder private var countdownText: some View {
        switch row.countdownTime {
        case .unknown:
            Text("arrivals.board.countdown.unknown", bundle: .module)
        case let .dueIn(seconds) where seconds < 30:
            Text("arrivals.board.countdown.due", bundle: .module)
        case let .dueIn(seconds) where seconds < 60:
            Text("arrivals.board.countdown.due.seconds \(seconds)", bundle: .module)
        case let .dueIn(seconds):
            let minutes = seconds / 60
            Text("arrivals.board.countdown.due.minutes \(minutes)", bundle: .module)
        }
    }
}

// MARK: - Previews
#if DEBUG
struct ArrivalsBoardView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = previewStore()
        let viewStore = ViewStore(store)
        
        Group {
            ArrivalsBoardView(store: store)
                .onAppear {
                    viewStore.send(.setAnimationState(to: .stopped))
                }
            ArrivalsBoardView(store: store)
                .onAppear {
                    viewStore.send(.setAnimationState(to: .refreshing))
                }
            ArrivalsBoardView(store: store)
                .onAppear {
                    viewStore.send(.setAnimationState(to: .rotating))
                }
        }
    }

    static func previewStore(
        initialState: ArrivalsBoard.State = .fake()
    ) -> ArrivalsBoardStore {
        .init(initialState: initialState,
              reducer: ArrivalsBoard.reducer,
              environment: .fake())
    }
}
#endif
