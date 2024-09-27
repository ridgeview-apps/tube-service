import Models
import SwiftUI

struct SystemStatusTitleView: View {
    
    let systemStatus: SystemStatus
    
    var body: some View {
        Label {
            Text(.systemStatusBannerTitle)
                .font(.title2)
        } icon: {
            systemStatus.titleImage
        }
    }
}


// MARK: - Previews
import ModelStubs

#Preview("OK") {
    SystemStatusTitleView(
        systemStatus: ModelStubs.systemStatusOK
    )
}

#Preview("Outage") {
    SystemStatusTitleView(
        systemStatus: ModelStubs.systemStatusOutage
    )
}

#Preview("Resolved") {
    SystemStatusTitleView(
        systemStatus: ModelStubs.systemStatusResolved
    )
}
