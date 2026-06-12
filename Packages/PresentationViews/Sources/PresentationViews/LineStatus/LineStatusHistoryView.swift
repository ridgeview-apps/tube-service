import Models
import SwiftUI

public struct LineStatusHistoryEntry: Hashable, Identifiable, Sendable {
    public var id: Date { date }

    public let date: Date
    public let statuses: [LineStatus]

    public init(date: Date, statuses: [LineStatus]) {
        self.date = date
        self.statuses = statuses
    }
}

public enum LineStatusHistoryState: Hashable, Sendable {
    case locked
    case unlocked(
        entries: [LineStatusHistoryEntry],
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
            case let .unlocked(entries, loadingState):
                unlockedView(
                    entries: entries,
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
        entries: [LineStatusHistoryEntry],
        loadingState: LoadingState
    ) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                if loadingState != .loaded {
                    LoadingStatusView(loadingState: loadingState)
                        .defaultLoadingStatusStyle(verticalPadding: 0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if entries.isEmpty {
                    emptyUnlockedContent(loadingState: loadingState)
                } else {
                    historyRows(entries)
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

    private func historyRows(_ entries: [LineStatusHistoryEntry]) -> some View {
        ForEach(entries.sorted { $0.date > $1.date }) { entry in
            historyRow(entry)
        }
    }

    private func historyRow(_ entry: LineStatusHistoryEntry) -> some View {
        let line = Line(id: lineID, lineStatuses: entry.statuses)

        return HStack(alignment: .top, spacing: 12) {
            timelineMarker(isDisrupted: line.isDisrupted)

            VStack(alignment: .leading, spacing: 8) {
                Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 0) {
                    ForEach(
                        Array(line.lineStatusesSortedBySeverity.enumerated()),
                        id: \.offset
                    ) { index, status in
                        if index > 0 {
                            Divider()
                                .padding(.vertical, 12)
                        }

                        HistoricStatusView(status: status)
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
    let status: LineStatus

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label {
                Text(status.statusSeverityDescription ?? String(localized: .lineStatusHistoryServiceUpdateFallback))
                    .font(.headline)
            } icon: {
                (status.isDisrupted
                    ? LineStatusAccessoryImageType.disruption
                    : LineStatusAccessoryImageType.goodService).image
            }

            if let reason = status.reason?.trimmingCharacters(in: .whitespacesAndNewlines),
                !reason.isEmpty
            {
                Text(reason)
                    .font(.callout)
            }
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
                            entries: Self.entries,
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
                        state = .unlocked(entries: [], loadingState: .loading)
                    } label: {
                        Text(verbatim: "Initial loading")
                    }
                    Button {
                        state = .unlocked(
                            entries: Self.entries,
                            loadingState: .loaded
                        )
                    } label: {
                        Text(verbatim: "Loaded")
                    }
                    Button {
                        state = .unlocked(
                            entries: Self.entries,
                            loadingState: .loading
                        )
                    } label: {
                        Text(verbatim: "Refreshing")
                    }
                    Button {
                        state = .unlocked(entries: [], loadingState: .loaded)
                    } label: {
                        Text(verbatim: "Empty")
                    }
                    Button {
                        state = .unlocked(
                            entries: [],
                            loadingState: .failure(
                                errorMessage: "Status history could not be loaded."
                            )
                        )
                    } label: {
                        Text(verbatim: "Error")
                    }
                    Button {
                        state = .unlocked(
                            entries: Self.entries,
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

    fileprivate static let entries = [
        LineStatusHistoryEntry(
            date: .now.addingTimeInterval(-900),
            statuses: ModelStubs.lineStatusGoodService.lineStatuses ?? []
        ),
        LineStatusHistoryEntry(
            date: .now.addingTimeInterval(-3_600),
            statuses: ModelStubs.lineStatusDisrupted.lineStatuses ?? []
        ),
        LineStatusHistoryEntry(
            date: .now.addingTimeInterval(-10_800),
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
                entries: LineStatusHistoryPreview.entries,
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
                entries: LineStatusHistoryPreview.entries,
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
                entries: LineStatusHistoryPreview.entries,
                loadingState: .failure(
                    errorMessage: "Status history could not be refreshed."
                )
            ),
            onAction: { _ in }
        )
    }
}
