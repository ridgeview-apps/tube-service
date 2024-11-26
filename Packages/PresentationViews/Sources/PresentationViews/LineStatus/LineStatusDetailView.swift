import Models
import SwiftUI

public struct LineStatusDetailView: View {
    
    public enum Action {
        case linkTapped(LineStatusTwitterLink)
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
                    favouritesButton
                    Divider()
                    twitterSection
                } header: {
                    refreshStatus
                }
                .background(Color.defaultBackground)
            }
            .withDefaultMaxWidth()
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
        }
        .background(Color.defaultBackground)
        .scrollBounceBehavior(.basedOnSize)
    }
    
    
    // MARK: - Layout views
    
    private var refreshStatus: some View {
        RefreshStatusView(loadingState: loadingState, 
                          refreshDate: refreshDate)
            .font(.caption)
            .foregroundStyle(Color.adaptiveMidGrey2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.defaultBackground)
            .padding(.vertical, 4)
    }
    
    private var statusHeaderCard: some View {
        HStack(spacing: 12) {
            Rectangle()
                .foregroundColor(line.id.backgroundColor)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 12) {
                Label {
                    Text(line.shortText)
                        .font(.title2)
                } icon: {
                    line.accessoryImageType.image
                        .imageScale(.large)
                }

                ForEach(Array(line.serviceDetailTextItems.enumerated()), id: \.offset) { idx, textItem in
                    serviceDetailText(for: textItem, needsDivider: idx != 0)
                }
            }
            .padding([.top, .bottom, .trailing])
            Spacer()
        }
        .foregroundColor(line.isDisrupted ? .adaptiveRed : .primary)
        .cardStyle(cornerRadius: 8)
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
    
    private var twitterSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                Text(.lineStatusTwitterSectionTitle)
                
                ForEach(line.twitterLinks) { link in
                    twitterLinkButton(for: link)
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder private func twitterLinkButton(for link: LineStatusTwitterLink) -> some View {
        Button {
            onAction(.linkTapped(link))
        } label: {
            Group {
                switch link.style {
                case .tflAllTweets:
                    Text(.lineStatusTflTweetsTitleAllLines)
                case let .lineTweets(line):
                    Text(.lineStatusTflTweetsTitleLine(line.longName))
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
