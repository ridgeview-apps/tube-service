import Models
import SwiftUI

public struct LineStatusDetailView: View {
    
    public let line: Line
    
    @State private var twitterLinkSelection: LineStatusTwitterLink?
    
    public init(line: Line) {
        self.line = line
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                statusHeaderCard
                twitterSection
            }
            .padding()
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
                Text(line.shortText)
                    .font(.title2)
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
    
    private var twitterSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("line.status.twitterSection.title", bundle: .module)
            
            ForEach(line.twitterLinks) { link in
                twitterLinkButton(for: link)
            }
        }
    }
    
    @ViewBuilder private func twitterLinkButton(for link: LineStatusTwitterLink) -> some View {
        Button(action: {
            twitterLinkSelection = link
        }) {
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
    LineStatusDetailView(line: ModelStubs.lineStatusGoodService)
}

#Preview("Disrupted state") {
    LineStatusDetailView(line: ModelStubs.lineStatusDisrupted)
}

#Preview("Disrupted state (dups. removed)") {
    LineStatusDetailView(line: ModelStubs.lineStatusDisruptedDuplicates)
}
#endif
