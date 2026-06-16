import Models
import SwiftUI

public enum LineStatusHistoryState: Hashable, Sendable {
    case locked
    case unlocked(
        snapshots: [LineStatusSnapshot],
        loadingState: LoadingState
    )
}

public struct LineStatusHistoryView: View {

    public enum Action: Equatable, Sendable {
        case unlockTapped
        case restoreTapped
        case refreshTapped
        case retryTapped
    }

    public let lineID: TrainLineID
    public let state: LineStatusHistoryState
    public let onAction: (Action) -> Void

    public init(
        lineID: TrainLineID,
        state: LineStatusHistoryState,
        onAction: @escaping (Action) -> Void
    ) {
        self.lineID = lineID
        self.state = state
        self.onAction = onAction
    }

    public var body: some View {
        Group {
            switch state {
            case .locked:
                LineStatusLockedView(lineID: lineID, onAction: onAction)
            case let .unlocked(snapshots, loadingState):
                LineStatusUnlockedView(
                    lineID: lineID,
                    snapshots: snapshots,
                    loadingState: loadingState,
                    onAction: onAction
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .defaultMaxWidthWithFullBackground()
        .navigationTitle(.lineStatusHistoryNavigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Previews

import ModelStubs

private struct LineStatusHistoryPreview: View {
    @State private var state = LineStatusHistoryState.locked

    var body: some View {
        NavigationStack {
            LineStatusHistoryView(
                lineID: .victoria,
                state: state,
                onAction: { action in
                    if action == .unlockTapped {
                        state = .unlocked(
                            snapshots: Self.snapshots,
                            loadingState: .loaded
                        )
                    }
                }
            )
            .toolbar {
                Menu {
                    Button {
                        state = .locked
                    } label: {
                        Text(verbatim: "Locked")
                    }
                    Button {
                        state = .unlocked(snapshots: [], loadingState: .loading)
                    } label: {
                        Text(verbatim: "Initial loading")
                    }
                    Button {
                        state = .unlocked(
                            snapshots: Self.snapshots,
                            loadingState: .loaded
                        )
                    } label: {
                        Text(verbatim: "Loaded")
                    }
                    Button {
                        state = .unlocked(
                            snapshots: Self.snapshots,
                            loadingState: .loading
                        )
                    } label: {
                        Text(verbatim: "Refreshing")
                    }
                    Button {
                        state = .unlocked(snapshots: [], loadingState: .loaded)
                    } label: {
                        Text(verbatim: "Empty")
                    }
                    Button {
                        state = .unlocked(
                            snapshots: [],
                            loadingState: .failure(
                                errorMessage: "Status history could not be loaded."
                            )
                        )
                    } label: {
                        Text(verbatim: "Error")
                    }
                    Button {
                        state = .unlocked(
                            snapshots: Self.snapshots,
                            loadingState: .failure(
                                errorMessage: "Status history could not be refreshed."
                            )
                        )
                    } label: {
                        Text(verbatim: "Refresh error")
                    }
                } label: {
                    Text(verbatim: "State")
                }
            }
        }
    }

    fileprivate static let snapshots = [
        LineStatusSnapshot(
            lineId: .victoria,
            observedAt: .now.addingTimeInterval(-900),
            transition: .serviceResumed,
            statuses: ModelStubs.lineStatusGoodService.lineStatuses ?? []
        ),
        LineStatusSnapshot(
            lineId: .victoria,
            observedAt: .now.addingTimeInterval(-3_600),
            transition: .disruptionStarted,
            statuses: ModelStubs.lineStatusDisrupted.lineStatuses ?? []
        ),
        LineStatusSnapshot(
            lineId: .victoria,
            observedAt: .now.addingTimeInterval(-10_800),
            transition: .baseline,
            statuses: ModelStubs.lineStatusDisruptedDuplicates.lineStatuses ?? []
        )
    ]
}

#Preview("Interactive states") {
    LineStatusHistoryPreview()
}

#Preview("Locked") {
    NavigationStack {
        LineStatusHistoryView(lineID: .elizabeth, state: .locked, onAction: { _ in })
    }
}

#Preview("Loaded") {
    NavigationStack {
        LineStatusHistoryView(
            lineID: .victoria,
            state: .unlocked(
                snapshots: LineStatusHistoryPreview.snapshots,
                loadingState: .loaded
            ),
            onAction: { _ in }
        )
    }
}

#Preview("Refreshing with entries") {
    NavigationStack {
        LineStatusHistoryView(
            lineID: .victoria,
            state: .unlocked(
                snapshots: LineStatusHistoryPreview.snapshots,
                loadingState: .loading
            ),
            onAction: { _ in }
        )
    }
}

#Preview("Refresh error with entries") {
    NavigationStack {
        LineStatusHistoryView(
            lineID: .victoria,
            state: .unlocked(
                snapshots: LineStatusHistoryPreview.snapshots,
                loadingState: .failure(
                    errorMessage: "Status history could not be refreshed."
                )
            ),
            onAction: { _ in }
        )
    }
}
