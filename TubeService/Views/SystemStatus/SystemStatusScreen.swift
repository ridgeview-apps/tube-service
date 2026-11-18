import DataStores
import PresentationViews
import SwiftUI

struct SystemStatusScreen: View {

    @Environment(SystemStatusDataStore.self) private var systemStatusData

    var body: some View {
        SystemStatusDetailView(systemStatus: systemStatusData.currentStatus)
    }
}


// MARK: - Previews

#if DEBUG
    #Preview {
        PreviewEnvironment {
            NavigationStack {
                SystemStatusScreen()
            }
        }
    }
#endif
