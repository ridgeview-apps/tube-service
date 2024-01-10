import Models
import SwiftUI

public struct LineStatusDetailView: View {
    
    public let line: Line
    @Binding public var isFavourite: Bool
    
    @State private var twitterLinkSelection: LineStatusTwitterLink?
    
    public init(line: Line, isFavourite: Binding<Bool>) {
        self.line = line
        self._isFavourite = isFavourite
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    statusHeaderCard
                    favouritesButton
                    Divider()
                    twitterSection
                }
                .withDefaultMaxWidth()
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .background(Color.defaultBackground)
    }
    
    
    // MARK: - Layout views
    
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
                switch line.id {
                case .bakerloo, .central, .circle, .district, .dlr, .elizabeth, .hammersmithAndCity, .jubilee,
                     .metropolitan, .overground, .northern, .piccadilly, .victoria, .waterlooAndCity:
                    Text("line.status.detail.good.service.on.the \(line.id.longName)", bundle: .module)
                case .tram:
                    Text("line.status.detail.good.service.on.trams", bundle: .module)
                }
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
             .metropolitan, .overground, .northern, .piccadilly, .victoria, .waterlooAndCity:
            Text("line.status.detail.good.service.on.the \(line.id.longName)", bundle: .module)
        case .tram:
            Text("line.status.detail.good.service.on.trams", bundle: .module)
        }
    }
    
    @ViewBuilder func serviceDetailAdditionalInfo(for textItem: Line.ServiceDetailTextItem) -> some View {
        if let additionalInfo = textItem.additionalInfo {
            Text(additionalInfo)
                .font(.caption)
        }
    }
    
    private var favouritesButton: some View {
        VStack(alignment: .leading) {
            FavouritesButton(style: .large, isSelected: $isFavourite)
            if !isFavourite {
                Text("line.status.favourites.button.footer", bundle: .module)
                    .font(.footnote)
                    .foregroundStyle(Color.adaptiveMidGrey2)
            }
        }
    }
    
    private var twitterSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("line.status.twitterSection.title", bundle: .module)
                
                ForEach(line.twitterLinks) { link in
                    twitterLinkButton(for: link)
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder private func twitterLinkButton(for link: LineStatusTwitterLink) -> some View {
        Button {
            twitterLinkSelection = link
        } label: {
            Group {
                switch link.style {
                case .tflAllTweets:
                    Text("line.status.tfl.tweets.title.allLines", bundle: .module)
                case let .lineTweets(line):
                    Text("line.status.tfl.tweets.title.line \(line.longName)", bundle: .module)
                }
            }
        }
        .sheet(item: $twitterLinkSelection) { link in
            SafariView(url: link.url)
        }
        .buttonStyle(.borderless)

    }
}


// MARK: - Previews
#if DEBUG
#Preview("Good service state") {
    LineStatusDetailView(line: ModelStubs.lineStatusGoodService,
                         isFavourite: .constant(false))
}

#Preview("Disrupted state") {
    LineStatusDetailView(line: ModelStubs.lineStatusDisrupted,
                         isFavourite: .constant(false))
}

#Preview("Disrupted state (dups. removed)") {
    LineStatusDetailView(line: ModelStubs.lineStatusDisruptedDuplicates,
                         isFavourite: .constant(false))
}
#endif
