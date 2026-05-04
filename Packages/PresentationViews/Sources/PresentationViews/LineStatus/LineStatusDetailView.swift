import Models
import SwiftUI

public struct LineStatusDetailView: View {
    
    public enum Action: Sendable {
        case linkTapped(LineStatusXPostLink)
    }
    
    public let line: Line
    public let loadingState: LoadingState
    public let refreshDate: Date?

    @Binding public var isFavourite: Bool
    
    public let onAction: (Action) -> Void
    
    public init(
        line: Line,
        isFavourite: Binding<Bool>,
        loadingState: LoadingState,
        refreshDate: Date?,
        onAction: @escaping (Action) -> Void
    ) {
        self.line = line
        self.loadingState = loadingState
        self.refreshDate = refreshDate
        self._isFavourite = isFavourite
        self.onAction = onAction
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20, pinnedViews: .sectionHeaders) {
                Section {
                    statusHeaderCard
                } header: {
                    refreshStatus
                }
                Section {
                    xPostsSection
                }
                favouritesButton
            }
            .withDefaultMaxWidth()
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
        }
        .scrollBounceBehavior(.basedOnSize)
        .background(Color.defaultBackground)
    }
    
    
    // MARK: - Layout views
    
    private var refreshStatus: some View {
        RefreshStatusView(loadingState: loadingState, 
                          refreshDate: refreshDate)
            .font(.caption)
            .foregroundStyle(Color.adaptiveMidGrey2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.defaultBackground)
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
        }
        .padding(12)
    }
    
    private var favouritesButton: some View {
        FavouritesButton(style: .large, isSelected: $isFavourite)
    }
    
    private var xPostsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(.lineStatusXPostsSectionTitle)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

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
            }
        }
        .buttonStyle(.borderless)
        .frame(minHeight: 44)
    }
}


// MARK: - Service Detail Additional Info

private struct ServiceDetailAdditionalInfoView: View {
    let textItem: Line.ServiceDetailTextItem
    @State private var isExpanded = false

    var body: some View {
        if let additionalInfo = textItem.additionalInfo {
            VStack(alignment: .leading, spacing: 8) {
                ExpansionInfoButton(isExpanded: $isExpanded)
                    .font(.caption)
                    .buttonStyle(.borderless)

                if isExpanded {
                    Text(additionalInfo)
                        .font(.caption)
                }
            }
        }
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
        .font(.subheadline)
    }
    
    @ViewBuilder
    private var expandableAdditionalInfoText: some View {
        if let additionalInfo = textItem.additionalInfo {
            VStack(alignment: .leading, spacing: 8) {
                ExpansionInfoButton(isExpanded: $isExpanded)
                
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
    @State var isFavourite = false
    
    var body: some View {
        NavigationStack {
            LineStatusDetailView(
                line: line,
                isFavourite: $isFavourite,
                loadingState: loadingState,
                refreshDate: refreshDate,
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
    Previewer(line: ModelStubs.lineStatusDisrupted)
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
