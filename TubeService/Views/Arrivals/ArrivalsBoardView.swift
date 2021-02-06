import ComposableArchitecture
import SwiftUI
import Combine

struct ArrivalsBoardView: View {
     
    let store: ArrivalsBoardStore

    var body: some View {
        VStack(spacing: 20) {
            WithViewStore(store) { viewStore in
                boardHeader(viewStore: viewStore)
                arrivalRows(viewStore: viewStore)
                expansionButton(viewStore: viewStore)
            }
        }
        .padding(20)
        .background(Color.black)
        .roundedBorder(Color.boardText, cornerRadius: 20, lineWidth: 4)
        .animation(.default)
    }
    
    private func boardHeader(viewStore: ViewStore<ArrivalsBoard.ViewState, ArrivalsBoard.Action>) -> some View {
        VStack(spacing: 4) {
            Text(viewStore.platformTitleText)
                .font(.headline)
            HStack(spacing: 8) {
                if viewStore.animationState == .refreshing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                Text(viewStore.timeText)
                    .font(.subheadline)
            }
        }.foregroundColor(.white)
    }
    
    private func arrivalRows(viewStore: ViewStore<ArrivalsBoard.ViewState, ArrivalsBoard.Action>) -> some View {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(viewStore.fixedRows) { row in
                    ArrivalsBoardRowView(row: row)
                        .animation(nil)
                }
                .transition(viewStore.isExpanded ? .identity : .slide)
                if let rotatingRow = viewStore.rotatingRow {
                    ArrivalsBoardRowView(row: rotatingRow)
                        .transition(.slideUp)
                }
            }
    }
    
    @ViewBuilder private func expansionButton(viewStore: ViewStore<ArrivalsBoard.ViewState, ArrivalsBoard.Action>) -> some View {
            if viewStore.isExpandable {
                ExpansionInfoButton(style: .pullDown,
                                    isExpanded: isExpanded(viewStore: viewStore))
                    .foregroundColor(.white)
            }
    }
    
    private func isExpanded(viewStore: ViewStore<ArrivalsBoard.ViewState, ArrivalsBoard.Action>) -> Binding<Bool> {
        viewStore.binding(
            get: \.isExpanded,
            send: ArrivalsBoard.Action.setExpanded
        )
    }
}


private struct ArrivalsBoardRowView: View {
    
    let row: ArrivalsBoard.ViewState.RowState
    
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
                    Text(row.destinationText)
                        .font(.headline)
                        .foregroundColor(.boardText)
                    Spacer()
                    Text(row.arrivalTimeText)
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
}

// MARK: - Previews
#if DEBUG
struct ArrivalsBoardView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = ArrivalsBoardStore.preview()
        Group {
            WithViewStore(store) { viewStore in
                
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
    }

}
#endif
