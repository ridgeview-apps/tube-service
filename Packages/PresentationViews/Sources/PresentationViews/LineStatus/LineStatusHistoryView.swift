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
    case loading
    case loaded([LineStatusHistoryEntry])
    case empty
    case failure(message: String)
}

public struct LineStatusHistoryView: View {

    public enum Action: Equatable, Sendable {
        case unlockTapped
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
            case .loading:
                loadingView
            case let .loaded(entries):
                if entries.isEmpty {
                    emptyView
                } else {
                    historyList(entries)
                }
            case .empty:
                emptyView
            case let .failure(message):
                failureView(message: message)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .defaultMaxWidthWithFullBackground()
        .navigationTitle("Status History")
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
                        Text("See how the service has changed")
                            .font(.title2.weight(.bold))
                            .multilineTextAlignment(.center)

                        Text(
                            """
                            Unlock status history to review recent service changes, disruptions and \
                            recovery updates for the \(lineID.longName).
                            """
                        )
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }
                }

                VStack(alignment: .leading, spacing: 16) {
                    featureRow(
                        systemImage: "calendar",
                        title: "Recent status timeline",
                        description: "See when each service update was recorded."
                    )
                    featureRow(
                        systemImage: "exclamationmark.bubble",
                        title: "Disruption summaries",
                        description: "Review the reason recorded for each service update."
                    )
                    featureRow(
                        systemImage: "arrow.trianglehead.2.clockwise.rotate.90",
                        title: "Recovery updates",
                        description: "Follow the service back to normal operation."
                    )
                }
                .padding(20)
                .cardStyle()

                Button {
                    onAction(.unlockTapped)
                } label: {
                    Label("Unlock Status History", systemImage: "lock.open.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(lineID.backgroundColor)

                Text("Purchase and subscription details will appear here once the paywall is connected.")
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

    private var loadingView: some View {
        ContentUnavailableView {
            ProgressView()
                .controlSize(.large)
        } description: {
            Text("Loading status history...")
        }
    }

    private var emptyView: some View {
        ContentUnavailableView(
            "No Status History",
            systemImage: "clock.badge.questionmark",
            description: Text("There are no recorded service updates for the \(lineID.longName) yet.")
        )
    }

    private func failureView(message: String) -> some View {
        ContentUnavailableView {
            Label("Status History Unavailable", systemImage: "exclamationmark.triangle.fill")
        } description: {
            Text(message)
        } actions: {
            Button("Try Again") {
                onAction(.retryTapped)
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func historyList(_ entries: [LineStatusHistoryEntry]) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(entries.sorted { $0.date > $1.date }) { entry in
                    historyRow(entry)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
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
        title: String,
        description: String
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
                Text(status.statusSeverityDescription ?? "Service update")
                    .font(.headline)
            } icon: {
                (status.isDisrupted
                    ? LineStatusAccessoryImageType.disruption
                    : LineStatusAccessoryImageType.goodService
                ).image
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
                        state = .loaded(Self.entries)
                    }
                }
            )
            .toolbar {
                Menu("State") {
                    Button("Locked") { state = .locked }
                    Button("Loading") { state = .loading }
                    Button("Loaded") { state = .loaded(Self.entries) }
                    Button("Empty") { state = .empty }
                    Button("Error") {
                        state = .failure(message: "Status history could not be loaded.")
                    }
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
        ),
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
            state: .loaded(LineStatusHistoryPreview.entries),
            onAction: { _ in }
        )
    }
}
