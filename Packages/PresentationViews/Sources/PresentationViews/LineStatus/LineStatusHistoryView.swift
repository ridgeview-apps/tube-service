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
                lockedView
            case let .unlocked(snapshots, loadingState):
                unlockedView(
                    snapshots: snapshots,
                    loadingState: loadingState
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .defaultMaxWidthWithFullBackground()
        .navigationTitle(.lineStatusHistoryNavigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var lockedView: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(lineID.backgroundColor.opacity(0.15))
                            .frame(width: 88, height: 88)

                        Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundStyle(lineID.backgroundColor)
                    }

                    VStack(spacing: 8) {
                        Text(.lineStatusHistoryLockedTitle)
                            .font(.title2.weight(.bold))
                            .multilineTextAlignment(.center)

                        Text(.lineStatusHistoryLockedDescription(lineID.longName))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }

                VStack(alignment: .leading, spacing: 16) {
                    featureRow(
                        systemImage: "calendar",
                        title: .lineStatusHistoryFeatureTimelineTitle,
                        description: .lineStatusHistoryFeatureTimelineDescription
                    )
                    featureRow(
                        systemImage: "exclamationmark.bubble",
                        title: .lineStatusHistoryFeatureDisruptionsTitle,
                        description: .lineStatusHistoryFeatureDisruptionsDescription
                    )
                    featureRow(
                        systemImage: "arrow.trianglehead.2.clockwise.rotate.90",
                        title: .lineStatusHistoryFeatureRecoveryTitle,
                        description: .lineStatusHistoryFeatureRecoveryDescription
                    )
                }
                .padding(20)
                .cardStyle()

                Button {
                    onAction(.unlockTapped)
                } label: {
                    Label(.lineStatusHistoryUnlockButtonTitle, systemImage: "lock.open.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(lineID.backgroundColor)

                Text(.lineStatusHistoryPurchasePlaceholder)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(20)
            .frame(maxWidth: 560)
            .frame(maxWidth: .infinity)
        }
        .scrollBounceBehavior(.basedOnSize)
    }

    private var emptyView: some View {
        ContentUnavailableView(
            .lineStatusHistoryEmptyTitle,
            systemImage: "clock.badge.questionmark",
            description: Text(.lineStatusHistoryEmptyDescription(lineID.longName))
        )
    }

    private func unlockedView(
        snapshots: [LineStatusSnapshot],
        loadingState: LoadingState
    ) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                if loadingState != .loaded {
                    LoadingStatusView(loadingState: loadingState)
                        .defaultLoadingStatusStyle(verticalPadding: 0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if snapshots.isEmpty {
                    emptyUnlockedContent(loadingState: loadingState)
                } else {
                    historyRows(snapshots)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
        .refreshable {
            onAction(.refreshTapped)
        }
        .scrollBounceBehavior(.always)
    }

    @ViewBuilder
    private func emptyUnlockedContent(loadingState: LoadingState) -> some View {
        switch loadingState {
        case .loading:
            Color.clear
                .frame(height: 1)
        case .loaded:
            emptyView
                .frame(maxWidth: .infinity)
        case .failure:
            Button(.lineStatusHistoryRetryButtonTitle) {
                onAction(.retryTapped)
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
        }
    }

    private func historyRows(_ snapshots: [LineStatusSnapshot]) -> some View {
        ForEach(snapshots.sorted { $0.observedAt > $1.observedAt }, id: \.observedAt) { snapshot in
            historyRow(snapshot)
        }
    }

    private func historyRow(_ snapshot: LineStatusSnapshot) -> some View {
        let line = Line(id: lineID, lineStatuses: snapshot.statuses)

        return HStack(alignment: .top, spacing: 12) {
            timelineMarker(isDisrupted: line.isDisrupted)

            VStack(alignment: .leading, spacing: 8) {
                Text(snapshot.observedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 0) {
                    ForEach(line.mergedLineStatuses) { mergedStatus in
                        if mergedStatus != line.mergedLineStatuses.first {
                            Divider()
                                .padding(.vertical, 12)
                        }

                        HistoricStatusView(mergedStatus: mergedStatus, transition: snapshot.transition)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardStyle()
            }
            .padding(.bottom, 20)
        }
    }

    private func timelineMarker(isDisrupted: Bool) -> some View {
        VStack(spacing: 0) {
            Circle()
                .fill(isDisrupted ? Color.adaptiveRed : Color.green)
                .frame(width: 12, height: 12)
                .overlay {
                    Circle()
                        .stroke(Color.defaultBackground, lineWidth: 3)
                }

            Rectangle()
                .fill(.quaternary)
                .frame(width: 2)
        }
        .frame(width: 20)
    }

    private func featureRow(
        systemImage: String,
        title: LocalizedStringResource,
        description: LocalizedStringResource
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: systemImage)
                .font(.headline)
                .foregroundStyle(lineID.backgroundColor)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct HistoricStatusView: View {
    let mergedStatus: Line.MergedStatus
    let transition: LineStatusTransition

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label {
                Text(titleText)
                    .font(.headline)
            } icon: {
                statusIcon
            }

            if !mergedStatus.reason.isEmpty {
                Text(mergedStatus.reason)
                    .font(.callout)
            }
        }
    }

    private var titleText: String {
        if transition == .serviceResumed {
            return String(localized: .lineStatusHistoryServiceResumed)
        }
        return mergedStatus.severityText.isEmpty
            ? String(localized: .lineStatusHistoryServiceUpdateFallback)
            : mergedStatus.severityText
    }

    @ViewBuilder private var statusIcon: some View {
        if transition == .serviceResumed {
            Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                .foregroundColor(.green)
        } else if mergedStatus.isDisrupted {
            LineStatusAccessoryImageType.disruption.image
        } else {
            LineStatusAccessoryImageType.goodService.image
        }
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
