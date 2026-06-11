import Models
import SwiftUI

public struct LineStatusDetailView: View {

    public enum Action: Sendable {
        case linkTapped(LineStatusXPostLink)
        case statusHistoryTapped
    }

    public enum StatusHistoryAccess: Sendable {
        case locked
        case unlocked
    }

    public let line: Line
    public let loadingState: LoadingState
    public let refreshDate: Date?
    public let statusHistoryAccess: StatusHistoryAccess

    @Binding public var isFavourite: Bool

    public let onAction: (Action) -> Void

    public init(
        line: Line,
        isFavourite: Binding<Bool>,
        loadingState: LoadingState,
        refreshDate: Date?,
        statusHistoryAccess: StatusHistoryAccess = .locked,
        onAction: @escaping (Action) -> Void
    ) {
        self.line = line
        self.loadingState = loadingState
        self.refreshDate = refreshDate
        self.statusHistoryAccess = statusHistoryAccess
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
                Section {
                    statusHistoryButton
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

    private var statusHistoryButton: some View {
        Button {
            onAction(.statusHistoryTapped)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(line.id.backgroundColor)
                    .frame(width: 36)

                VStack(alignment: .leading, spacing: 3) {
                    Text(.lineStatusHistoryNavigationTitle)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(statusHistorySubtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 8)

                statusHistoryAccessory
            }
            .padding(16)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .cardStyle()
        .accessibilityHint(statusHistoryAccessibilityHint)
    }

    private var statusHistorySubtitle: LocalizedStringResource {
        switch statusHistoryAccess {
        case .locked:
            .lineStatusHistoryEntryLockedSubtitle
        case .unlocked:
            .lineStatusHistoryEntryUnlockedSubtitle
        }
    }

    @ViewBuilder
    private var statusHistoryAccessory: some View {
        switch statusHistoryAccess {
        case .locked:
            Image(systemName: "lock.fill")
                .foregroundStyle(.secondary)
                .accessibilityLabel(.lineStatusHistoryEntryLockedAccessibilityLabel)
        case .unlocked:
            Image(systemName: "chevron.forward")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        }
    }

    private var statusHistoryAccessibilityHint: LocalizedStringResource {
        switch statusHistoryAccess {
        case .locked:
            .lineStatusHistoryEntryLockedAccessibilityHint
        case .unlocked:
            .lineStatusHistoryEntryUnlockedAccessibilityHint
        }
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


private struct ServiceDetailTextView: View {
    let line: Line
    let textItem: Line.ServiceDetailTextItem

    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            descriptionText
            expandableAdditionalInfoText
        }
    }

    @ViewBuilder private var descriptionText: some View {
        Group {
            switch textItem.messageType {
            case .goodService:
                goodServiceText
            case let .disrupted(reason):
                if let reason {
                    Text(reason)
                }
            }
        }
        .font(.body)
    }

    @ViewBuilder
    private var expandableAdditionalInfoText: some View {
        if let additionalInfo = textItem.additionalInfo {
            VStack(alignment: .leading, spacing: 8) {
                ExpansionInfoButton(isExpanded: $isExpanded)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                if isExpanded {
                    Text(additionalInfo)
                }
            }
            .font(.caption)
        }
    }

    @ViewBuilder private var goodServiceText: some View {
        switch line.id {
        case .bakerloo, .central, .circle, .district, .dlr, .elizabeth, .hammersmithAndCity, .jubilee,
            .liberty, .lioness, .metropolitan, .mildmay, .overground, .northern, .piccadilly,
            .suffragette, .victoria, .waterlooAndCity, .weaver, .windrush:
            Text(.lineStatusDetailGoodServiceOnThe(line.id.longName))
        case .tram:
            Text(.lineStatusDetailGoodServiceOnTrams)
        }
    }
}


// MARK: - Previews

private struct Previewer: View {
    let line: Line
    var loadingState: LoadingState = .loaded
    var refreshDate: Date? = .now
    var statusHistoryAccess = LineStatusDetailView.StatusHistoryAccess.locked
    @State var isFavourite = false

    var body: some View {
        NavigationStack {
            LineStatusDetailView(
                line: line,
                isFavourite: $isFavourite,
                loadingState: loadingState,
                refreshDate: refreshDate,
                statusHistoryAccess: statusHistoryAccess,
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
        statusHistoryAccess: .unlocked
    )
}

#Preview("Disrupted state (dups. removed)") {
    Previewer(line: ModelStubs.lineStatusDisruptedDuplicates)
}

#Preview("Loading state") {
    Previewer(line: ModelStubs.lineStatusGoodService, loadingState: .loading)
}

#Preview("Error state") {
    Previewer(line: ModelStubs.lineStatusGoodService, loadingState: .failure(errorMessage: "Oops"))
}
