import Models
import SwiftUI

struct ServiceDetailTextView: View {
    let line: Line
    let textItem: Line.ServiceDetailTextItem
    let context: LineStatusDetailView.StatusContext

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
            .liberty, .lioness, .metropolitan, .mildmay, .northern, .piccadilly,
            .suffragette, .victoria, .waterlooAndCity, .weaver, .windrush:
            switch context {
            case .live:
                Text(.lineStatusDetailGoodServiceOnThe(line.id.longName))
            case .planned:
                Text(.lineStatusDetailNoDisruptionsPlannedOnThe(line.id.longName))
            }
        case .tram:
            switch context {
            case .live:
                Text(.lineStatusDetailGoodServiceOnTrams)
            case .planned:
                Text(.lineStatusDetailNoDisruptionsPlannedOnTrams)
            }
        }
    }
}


// MARK: - Previews

import ModelStubs

#Preview("Good service (live)") {
    let line = ModelStubs.lineStatusGoodService
    ForEach(line.serviceDetailTextItems) { item in
        ServiceDetailTextView(line: line, textItem: item, context: .live)
    }
    .padding()
}

#Preview("Good service (planned)") {
    let line = ModelStubs.lineStatusGoodService
    ForEach(line.serviceDetailTextItems) { item in
        ServiceDetailTextView(line: line, textItem: item, context: .planned)
    }
    .padding()
}

#Preview("Disrupted") {
    let line = ModelStubs.lineStatusDisrupted
    ForEach(line.serviceDetailTextItems) { item in
        ServiceDetailTextView(line: line, textItem: item, context: .live)
    }
    .padding()
}
