import Models
import SwiftUI

struct LineStatusUnlockedView: View {

    let lineID: TrainLineID
    let snapshots: [LineStatusSnapshot]
    let loadingState: LoadingState
    let onAction: (LineStatusHistoryView.Action) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                if loadingState != .loaded {
                    LoadingStatusView(loadingState: loadingState)
                        .defaultLoadingStatusStyle(verticalPadding: 0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if snapshots.isEmpty {
                    emptyContent
                } else {
                    historyRows
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
    private var emptyContent: some View {
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

    private var emptyView: some View {
        ContentUnavailableView(
            .lineStatusHistoryEmptyTitle,
            systemImage: "clock.badge.questionmark",
            description: Text(.lineStatusHistoryEmptyDescription(lineID.longName))
        )
    }

    private var historyRows: some View {
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
