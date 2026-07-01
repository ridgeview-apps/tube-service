import Models
import SwiftUI

public struct LineStatusDetailView: View {

    public enum Action: Sendable {
        case linkTapped(LineStatusXPostLink)
        case statusHistoryTapped
        case notifyMeTapped
    }

    public enum StatusContext: Sendable {
        case live
        case planned
    }

    public let line: Line
    public let loadingState: LoadingState
    public let refreshDate: Date?
    public let historyButtonState: LineStatusHistoryButton.ButtonState?
    public let statusContext: StatusContext
    public let notificationButtonState: NotificationsButtonState?

    @Binding public var isFavourite: Bool

    public let onAction: (Action) -> Void

    public init(
        line: Line,
        isFavourite: Binding<Bool>,
        loadingState: LoadingState,
        refreshDate: Date?,
        historyButtonState: LineStatusHistoryButton.ButtonState?,
        statusContext: StatusContext,
        notificationButtonState: NotificationsButtonState?,
        onAction: @escaping (Action) -> Void
    ) {
        self.line = line
        self.loadingState = loadingState
        self.refreshDate = refreshDate
        self.historyButtonState = historyButtonState
        self.statusContext = statusContext
        self.notificationButtonState = notificationButtonState
        self._isFavourite = isFavourite
        self.onAction = onAction
    }

    public var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20, pinnedViews: .sectionHeaders) {
                Section {
                    statusHeaderCard
                } header: {
                    loadingStatusView
                }
                if statusContext == .live {
                    if let historyButtonState {
                        Section {
                            LineStatusHistoryButton(
                                buttonState: historyButtonState,
                                lineColor: line.id.backgroundColor,
                                onTap: { onAction(.statusHistoryTapped) }
                            )
                        }
                    }
                    if let state = notificationButtonState {
                        Section {
                            NotificationsButton(
                                state: state,
                                context: .lineStatus(
                                    name: line.id.longName,
                                    color: line.id.backgroundColor
                                ),
                                onTap: { onAction(.notifyMeTapped) }
                            )
                        }
                    }
                    Section {
                        xPostsSection
                    }
                }
                Section {
                    favouritesButton
                        .padding(.bottom, 30)
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
        }
        .scrollBounceBehavior(.basedOnSize)
        .defaultMaxWidthWithFullBackground()
    }


    // MARK: - Layout views

    @ViewBuilder
    private var loadingStatusView: some View {
        if loadingState != .loaded {
            LoadingStatusView(
                loadingState: loadingState,
            )
            .defaultLoadingStatusStyle(verticalPadding: 0)
        }
    }

    private var statusHeaderCard: some View {
        HStack(spacing: 0) {
            statusHeaderLeadingAccentBar
            statusHeaderContent
            Spacer()
        }
        .cardStyle()
    }

    private var statusHeaderLeadingAccentBar: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(line.id.backgroundColor)
            .frame(width: 12)
    }

    private var statusHeaderContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label {
                Text(line.shortStatusText)
                    .font(.title3.weight(.semibold))
            } icon: {
                line.accessoryImageType.image
                    .imageScale(.large)
            }
            .foregroundStyle(
                line.isDisrupted ? .adaptiveRed : .primary
            )

            let mergedStatuses = line.mergedLineStatuses
            ForEach(mergedStatuses) { mergedStatus in
                ServiceDetailTextView(line: line, mergedStatus: mergedStatus, context: statusContext)
                if mergedStatus != mergedStatuses.last {
                    Divider()
                        .padding(.vertical, 4)
                        .foregroundStyle(.tertiary)
                }
            }

            if let refreshDate {
                LastUpatedTimeLabel(date: refreshDate)
                    .defaultLastUpdatedTimeLabelStyle()
            }
        }
        .padding(12)
    }

    private var favouritesButton: some View {
        FavouritesButton(style: .large, isSelected: $isFavourite)
    }

    private var xPostsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(.lineStatusXPostsSectionTitle)
                .secondarySectionHeaderStyle()

            VStack(alignment: .leading, spacing: 0) {
                ForEach(line.xPostLinks) { link in
                    xPostLinkButton(for: link)
                        .padding(.horizontal, 12)

                    if link != line.xPostLinks.last {
                        Divider()
                            .padding(.horizontal, 12)
                    }
                }
            }
            .cardStyle()
        }
    }

    @ViewBuilder private func xPostLinkButton(for link: LineStatusXPostLink) -> some View {
        Button {
            onAction(.linkTapped(link))
        } label: {
            HStack {
                Group {
                    switch link.style {
                    case .tflAllXPosts:
                        Text(.lineStatusTflXPostsTitleAllLines)
                    case let .lineXPosts(line):
                        Text(.lineStatusTflXPostsTitleLine(line.longName))
                    }
                }
                Spacer()
                Image(systemName: "arrow.up.forward.square")
            }
        }
        .buttonStyle(.borderless)
        .frame(minHeight: 44)
    }
}


// MARK: - Previews

private struct Previewer: View {
    let line: Line
    var loadingState: LoadingState = .loaded
    var refreshDate: Date? = .now
    var historyButtonState: LineStatusHistoryButton.ButtonState? = .locked(nil)
    var statusContext = LineStatusDetailView.StatusContext.live
    var notificationButtonState: NotificationsButtonState? = nil
    @State var isFavourite = false

    var body: some View {
        NavigationStack {
            LineStatusDetailView(
                line: line,
                isFavourite: $isFavourite,
                loadingState: loadingState,
                refreshDate: refreshDate,
                historyButtonState: historyButtonState,
                statusContext: statusContext,
                notificationButtonState: notificationButtonState,
                onAction: { print($0) }
            )
            .navigationTitle("Preview")
        }
    }
}

import ModelStubs

#Preview("Good service state") {
    Previewer(line: ModelStubs.lineStatusGoodService)
}

#Preview("Good service state (planned)") {
    Previewer(
        line: ModelStubs.lineStatusGoodService,
        statusContext: .planned
    )
}

#Preview("Disrupted state") {
    Previewer(
        line: ModelStubs.lineStatusDisrupted,
        historyButtonState: .unlocked(nil)
    )
}

#Preview("Disrupted state (dups. removed)") {
    Previewer(line: ModelStubs.lineStatusDisruptedDuplicates)
}

#Preview("Hidden status history") {
    Previewer(
        line: ModelStubs.lineStatusGoodService,
        historyButtonState: nil
    )
}

#Preview("Earlier disruption (locked)") {
    Previewer(
        line: ModelStubs.lineStatusGoodService,
        historyButtonState: .locked(.resolvedDisruption(at: .now))
    )
}

#Preview("Earlier disruption (unlocked)") {
    Previewer(
        line: ModelStubs.lineStatusGoodService,
        historyButtonState: .unlocked(.resolvedDisruption(at: .now))
    )
}

#Preview("Multiple disruptions (unlocked)") {
    Previewer(
        line: ModelStubs.lineStatusDisrupted,
        historyButtonState: .unlocked(.multipleDisruptions(count: 3, firstAt: .now))
    )
}

#Preview("Loading state") {
    Previewer(line: ModelStubs.lineStatusGoodService, loadingState: .loading)
}

#Preview("Error state") {
    Previewer(line: ModelStubs.lineStatusGoodService, loadingState: .failure(errorMessage: "Oops"))
}

#Preview("Notifications — locked") {
    Previewer(
        line: ModelStubs.lineStatusGoodService,
        notificationButtonState: .locked
    )
}

#Preview("Notifications — not set up") {
    Previewer(
        line: ModelStubs.lineStatusGoodService,
        notificationButtonState: .notSetUp
    )
}

#Preview("Notifications — inactive") {
    Previewer(
        line: ModelStubs.lineStatusGoodService,
        notificationButtonState: .inactive
    )
}

#Preview("Notifications — active") {
    Previewer(
        line: ModelStubs.lineStatusGoodService,
        notificationButtonState: .active
    )
}
