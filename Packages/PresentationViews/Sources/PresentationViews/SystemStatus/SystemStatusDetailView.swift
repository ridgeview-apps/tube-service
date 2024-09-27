import Models
import SwiftUI

public struct SystemStatusDetailView: View {
    
    public let systemStatus: SystemStatus?
    
    public init(systemStatus: SystemStatus?) {
        self.systemStatus = systemStatus
    }
    
    public var body: some View {
        if let systemStatus {
            contentAvailableView(systemStatus)
        } else {
            contentUnavailableView
        }
    }
    
    private func contentAvailableView(_ systemStatus: SystemStatus) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    SystemStatusTitleView(systemStatus: systemStatus)
                    
                    Text(systemStatus.formattedMessage)
                }
                .withDefaultMaxWidth(alignment: .leading)
                .padding()
                .cardStyle(backgroundColor: systemStatus.backgroundColor)
                .foregroundStyle(systemStatus.foregroundStyle)
                
                if let detail = systemStatus.detail {
                    Divider()
                    Text(.init(stringLiteral: detail))
                }
            }
            .padding(.horizontal)
            .withDefaultMaxWidth(alignment: .leading)
        }
        .scrollBounceBehavior(.basedOnSize)
    }
    
    private var contentUnavailableView: some View {
        ContentUnavailableView {
            Label {
                Text(.settingsSystemStatusDetailUnableToLoad)
            } icon: {
                Image(systemName: "wifi.slash")
            }
        }
    }
}


// MARK: - Previews

import ModelStubs

#Preview("OK") {
    SystemStatusDetailView(systemStatus: ModelStubs.systemStatusOK)
}

#Preview("Outage") {
    SystemStatusDetailView(systemStatus: ModelStubs.systemStatusOutage)
}

#Preview("Resolved") {
    SystemStatusDetailView(systemStatus: ModelStubs.systemStatusResolved)
}

#Preview("Unavailable") {
    SystemStatusDetailView(systemStatus: nil)
}
