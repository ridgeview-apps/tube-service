import Models
import SwiftUI

struct JourneyLocationTitleLabel: View {
    let value: JourneyLocationPicker.Value
    var accessoryStatus: JourneyLocationValueButton.AccessoryStatus?
    
    public var body: some View {
        switch value {
        case .currentLocation:
            currentLocationLabel
        case .station, .nationalRail, .namedLocation:
            Text(value.localizedTitle)
        }
    }
    
    @ViewBuilder
    private var currentLocationLabel: some View {
        HStack(alignment: .top, spacing: 4) {
            Text(Image(systemName: "location.fill"))
            Text(value.localizedTitle)
            if let accessoryStatus {
                switch accessoryStatus {
                case .warning:
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.yellow)
                case .loadingState(let loadingState):
                    RefreshStatusView(loadingState: loadingState,
                                      showsText: false)
                }
            }
        }
    }
}


// MARK: - Previews

#Preview {
    VStack {
        JourneyLocationTitleLabel(value: .currentLocation(.unknown))
        JourneyLocationTitleLabel(value: .currentLocation(.unknown), accessoryStatus: .loadingState(.loading))
        JourneyLocationTitleLabel(value: .currentLocation(.unknown), accessoryStatus: .loadingState(.failure(errorMessage: "")))
        JourneyLocationTitleLabel(value: .currentLocation(.unknown), accessoryStatus: .warning)
        JourneyLocationTitleLabel(value: .currentLocation(.init(name: .init(title: "Example Road",
                                                                            subtitle: "Example region"))))
        JourneyLocationTitleLabel(value: .station(ModelStubs.kingsCrossStation))
        JourneyLocationTitleLabel(value: .nationalRail(ModelStubs.twickenhamRailStation))
        JourneyLocationTitleLabel(value: .namedLocation(.init(name: .init(title: "Named location title",
                                                                         subtitle: "Named location subtitle"),
                                                              coordinate: nil)))
        JourneyLocationTitleLabel(value: .namedLocation(.init(name: .init(title: "Named location title only",
                                                                         subtitle: ""),
                                                              coordinate: nil)))
    }
}
