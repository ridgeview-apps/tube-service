import Models
import SwiftUI

public struct LineStatusDetailView: View {

    public enum Action: Sendable {
        case linkTapped(LineStatusXPostLink)
        case statusHistoryTapped
        case notifyMeTapped(LineNotificationsButtonState)
        case setNotificationsPaused(Bool)
        case notificationsErrorDismissed
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
    public let notificationButtonState: LineNotificationsButtonState?
    /// The progress of pausing or resuming from the notifications row; a failure presents an alert.
    public let notificationSavingState: LoadingState

    @Binding public var isFavourite: Bool

    public let onAction: (Action) -> Void

    public init(
        line: Line,
        isFavourite: Binding<Bool>,
        loadingState: LoadingState,
        refreshDate: Date?,
        historyButtonState: LineStatusHistoryButton.ButtonState?,
        statusContext: StatusContext,
        notificationButtonState: LineNotificationsButtonState?,
        notificationSavingState: LoadingState = .loaded,
        onAction: @escaping (Action) -> Void
    ) {
        self.line = line
        self.loadingState = loadingState
        self.refreshDate = refreshDate
        self.historyButtonState = historyButtonState
        self.statusContext = statusContext
        self.notificationButtonState = notificationButtonState
        self.notificationSavingState = notificationSavingState
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
                                onTap: { onAction(.statusHistoryTapped) }
                            )
                        }
                    }
                    if let state = notificationButtonState {
                        Section {
                            LineNotificationsButton(
                                state: state,
                                isSaving: notificationSavingState == .loading,
                                onAction: { handleNotificationsButtonAction($0, state: state) }
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
        .alert(
            Text(notificationErrorTitle),
            isPresented: isShowingNotificationError,
            presenting: notificationErrorMessage
        ) { _ in
            // The row's state only changes once a save succeeds, so it still reflects what was being attempted.
            Button(.globalTryAgain) {
                onAction(.setNotificationsPaused(notificationButtonState == .active))
            }
            Button(.globalOk, role: .cancel) {}
        } message: { message in
            Text(message)
        }
    }


    // MARK: - Notifications

    private func handleNotificationsButtonAction(
        _ action: LineNotificationsButton.Action,
        state: LineNotificationsButtonState
    ) {
        switch action {
        case .tapped:
            onAction(.notifyMeTapped(state))
        case .setPaused(let isPaused):
            onAction(.setNotificationsPaused(isPaused))
        }
    }

    private var notificationErrorMessage: String? {
        guard case .failure(let errorMessage) = notificationSavingState else { return nil }
        return errorMessage
    }

    private var isShowingNotificationError: Binding<Bool> {
        Binding {
            notificationErrorMessage != nil
        } set: { isPresented in
            if !isPresented {
                onAction(.notificationsErrorDismissed)
            }
        }
    }

    private var notificationErrorTitle: LocalizedStringResource {
        notificationButtonState == .paused
            ? .lineStatusNotificationsResumeFailedTitle
            : .lineStatusNotificationsPauseFailedTitle
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
    var historyButtonState: LineStatusHistoryButton.ButtonState? = .locked
    var statusContext = LineStatusDetailView.StatusContext.live
    var notificationButtonState: LineNotificationsButtonState? = nil
    var notificationSavingState: LoadingState = .loaded
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
                notificationSavingState: notificationSavingState,
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
        historyButtonState: .unlocked(.noDisruption)
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

#Preview("Notifications — paused") {
    Previewer(
        line: ModelStubs.lineStatusGoodService,
        notificationButtonState: .paused
    )
}

#Preview("Notifications — active") {
    Previewer(
        line: ModelStubs.lineStatusGoodService,
        notificationButtonState: .active
    )
}

#Preview("Notifications — pause failed") {
    Previewer(
        line: ModelStubs.lineStatusGoodService,
        notificationButtonState: .active,
        notificationSavingState: .failure(errorMessage: "Sorry, couldn't save your changes. Please try again.")
    )
}
