import Models
import SwiftUI

struct ServiceDetailTextView: View {
    let line: Line
    let mergedStatus: Line.MergedStatus
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
            if mergedStatus.isDisrupted {
                if !mergedStatus.reason.isEmpty {
                    Text(mergedStatus.reason)
                }
            } else {
                goodServiceText
            }
        }
        .font(.body)
    }

    @ViewBuilder
    private var expandableAdditionalInfoText: some View {
        if let additionalInfo = mergedStatus.additionalInfo, !additionalInfo.isEmpty {
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
        switch context {
        case .live:
            Text(.lineStatusDetailGoodService(line.id.nameInSentence))
        case .planned:
            Text(.lineStatusDetailNoDisruptionsPlanned(line.id.nameInSentence))
        }
    }
}


// MARK: - Previews

import ModelStubs

#Preview("Good service (live)") {
    let line = ModelStubs.lineStatusGoodService
    ForEach(line.mergedLineStatuses) { mergedStatus in
        ServiceDetailTextView(line: line, mergedStatus: mergedStatus, context: .live)
    }
    .padding()
}

#Preview("Good service (planned)") {
    let line = ModelStubs.lineStatusGoodService
    ForEach(line.mergedLineStatuses) { mergedStatus in
        ServiceDetailTextView(line: line, mergedStatus: mergedStatus, context: .planned)
    }
    .padding()
}

#Preview("Disrupted") {
    let line = ModelStubs.lineStatusDisrupted
    ForEach(line.mergedLineStatuses) { mergedStatus in
        ServiceDetailTextView(line: line, mergedStatus: mergedStatus, context: .live)
    }
    .padding()
}
