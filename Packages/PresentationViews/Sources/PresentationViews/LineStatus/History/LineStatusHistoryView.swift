import Models
import SwiftUI

public struct LineStatusHistoryView: View {

    public enum Action: Equatable, Sendable {
        case refreshTapped
        case retryTapped
    }

    public let lineID: TrainLineID
    public let snapshots: [LineStatusSnapshot]
    public let loadingState: LoadingState
    public let onAction: (Action) -> Void

    public init(
        lineID: TrainLineID,
        snapshots: [LineStatusSnapshot],
        loadingState: LoadingState,
        onAction: @escaping (Action) -> Void
    ) {
        self.lineID = lineID
        self.snapshots = snapshots
        self.loadingState = loadingState
        self.onAction = onAction
    }

    public var body: some View {
        LineStatusUnlockedView(
            lineID: lineID,
            snapshots: snapshots,
            loadingState: loadingState,
            onAction: onAction
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .defaultMaxWidthWithFullBackground()
        .navigationTitle(.lineStatusHistoryNavigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Previews

import ModelStubs

private struct LineStatusHistoryPreview: View {
    @State private var snapshots: [LineStatusSnapshot] = Self.allSnapshots
    @State private var loadingState: LoadingState = .loaded

    var body: some View {
        NavigationStack {
            LineStatusHistoryView(
                lineID: .victoria,
                snapshots: snapshots,
                loadingState: loadingState,
                onAction: { _ in }
            )
            .toolbar {
                Menu {
                    Button {
                        snapshots = []
                        loadingState = .loading
                    } label: {
                        Text(verbatim: "Initial loading")
                    }
                    Button {
                        snapshots = Self.allSnapshots
                        loadingState = .loaded
                    } label: {
                        Text(verbatim: "Loaded")
                    }
                    Button {
                        snapshots = Self.allSnapshots
                        loadingState = .loading
                    } label: {
                        Text(verbatim: "Refreshing")
                    }
                    Button {
                        snapshots = []
                        loadingState = .loaded
                    } label: {
                        Text(verbatim: "Empty")
                    }
                    Button {
                        snapshots = []
                        loadingState = .failure(errorMessage: "Status history could not be loaded.")
                    } label: {
                        Text(verbatim: "Error")
                    }
                    Button {
                        snapshots = Self.allSnapshots
                        loadingState = .failure(errorMessage: "Status history could not be refreshed.")
                    } label: {
                        Text(verbatim: "Refresh error")
                    }
                } label: {
                    Text(verbatim: "State")
                }
            }
        }
    }

    fileprivate static let allSnapshots = [
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

#Preview("Loaded") {
    NavigationStack {
        LineStatusHistoryView(
            lineID: .victoria,
            snapshots: LineStatusHistoryPreview.allSnapshots,
            loadingState: .loaded,
            onAction: { _ in }
        )
    }
}

#Preview("Refreshing with entries") {
    NavigationStack {
        LineStatusHistoryView(
            lineID: .victoria,
            snapshots: LineStatusHistoryPreview.allSnapshots,
            loadingState: .loading,
            onAction: { _ in }
        )
    }
}

#Preview("Refresh error with entries") {
    NavigationStack {
        LineStatusHistoryView(
            lineID: .victoria,
            snapshots: LineStatusHistoryPreview.allSnapshots,
            loadingState: .failure(errorMessage: "Status history could not be refreshed."),
            onAction: { _ in }
        )
    }
}
