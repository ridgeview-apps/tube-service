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
        .withCardOrGlassStyle(cornerRadius: 12)
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

            ForEach(Array(line.serviceDetailTextItems.enumerated()), id: \.offset) { idx, textItem in
                serviceDetailText(for: textItem, needsDivider: idx != 0)
            }
        }
        .foregroundColor(line.isDisrupted ? .adaptiveRed : .primary)
        .padding(12)
    }
    
    @ViewBuilder private func serviceDetailText(for textItem: Line.ServiceDetailTextItem, needsDivider: Bool) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if needsDivider {
                Divider()
            }
            serviceDetailDescription(for: textItem)
            serviceDetailAdditionalInfo(for: textItem)
        }
    }
    
    @ViewBuilder private func serviceDetailDescription(for textItem: Line.ServiceDetailTextItem) -> some View {
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
    
    @ViewBuilder func serviceDetailAdditionalInfo(for textItem: Line.ServiceDetailTextItem) -> some View {
        if let additionalInfo = textItem.additionalInfo {
            Text(additionalInfo)
                .font(.caption)
        }
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
                ForEach(Array(line.xPostLinks.enumerated()), id: \.element.id) { idx, link in
                    if idx != 0 {
                        Divider()
                            .padding(.leading, 12)
                    }
                    xPostLinkButton(for: link)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                }
            }
            .withCardOrGlassStyle(cornerRadius: 12)
        }
    }

    @ViewBuilder private func xPostLinkButton(for link: LineStatusXPostLink) -> some View {
        Button {
            onAction(.linkTapped(link))
        } label: {
            Group {
                switch link.style {
                case .tflAllXPosts:
                    Text(.lineStatusTflXPostsTitleAllLines)
                case let .lineXPosts(line):
                    Text(.lineStatusTflXPostsTitleLine(line.longName))
                }
            }
        }
        .buttonStyle(.borderless)

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
