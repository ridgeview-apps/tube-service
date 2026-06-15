import Models
import SwiftUI

public struct LineStatusDetailView: View {

    public enum Action: Sendable {
        case linkTapped(LineStatusXPostLink)
        case statusHistoryTapped
    }

    public enum StatusHistoryState: Sendable {
        case hidden
        case locked
        case unlocked
    }

    public let line: Line
    public let loadingState: LoadingState
    public let refreshDate: Date?
    public let statusHistoryState: StatusHistoryState

    @Binding public var isFavourite: Bool

    public let onAction: (Action) -> Void

    public init(
        line: Line,
        isFavourite: Binding<Bool>,
        loadingState: LoadingState,
        refreshDate: Date?,
        statusHistoryState: StatusHistoryState,
        onAction: @escaping (Action) -> Void
    ) {
        self.line = line
        self.loadingState = loadingState
        self.refreshDate = refreshDate
        self.statusHistoryState = statusHistoryState
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
                if let buttonAccess = statusHistoryState.buttonAccess {
                    Section {
                        StatusHistoryButton(
                            access: buttonAccess,
                            lineColor: line.id.backgroundColor,
                            onTap: { onAction(.statusHistoryTapped) }
                        )
                    }
                }
                Section {
                    favouritesButton
                }
                Section {
                    xPostsSection
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
                Text(line.shortText)
                    .font(.title3.weight(.semibold))
            } icon: {
                line.accessoryImageType.image
                    .imageScale(.large)
            }
            .foregroundStyle(
                line.isDisrupted ? .adaptiveRed : .primary
            )

            ForEach(line.serviceDetailTextItems) { textItem in
                ServiceDetailTextView(line: line, textItem: textItem)
                if textItem != line.serviceDetailTextItems.last {
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
    var statusHistoryState = LineStatusDetailView.StatusHistoryState.locked
    @State var isFavourite = false

    var body: some View {
        NavigationStack {
            LineStatusDetailView(
                line: line,
                isFavourite: $isFavourite,
                loadingState: loadingState,
                refreshDate: refreshDate,
                statusHistoryState: statusHistoryState,
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

#Preview("Disrupted state") {
    Previewer(
        line: ModelStubs.lineStatusDisrupted,
        statusHistoryState: .unlocked
    )
}

#Preview("Disrupted state (dups. removed)") {
    Previewer(line: ModelStubs.lineStatusDisruptedDuplicates)
}

#Preview("Hidden status history") {
    Previewer(
        line: ModelStubs.lineStatusGoodService,
        statusHistoryState: .hidden
    )
}

#Preview("Loading state") {
    Previewer(line: ModelStubs.lineStatusGoodService, loadingState: .loading)
}

#Preview("Error state") {
    Previewer(line: ModelStubs.lineStatusGoodService, loadingState: .failure(errorMessage: "Oops"))
}
