import Models
import SwiftUI

public struct JourneyLocationTitleLabel: View {

    public enum AccessoryStatus {
        case warning
        case loadingState(LoadingState)
    }

    let value: JourneyLocationPicker.Value
    var accessoryStatus: AccessoryStatus?

    public var body: some View {
        switch value {
        case .station, .nationalRail:
            Text(value.name)
        case let .namedLocation(locationValue):
            if locationValue.isCurrentLocation {
                currentLocationLabel
            } else {
                Text(value.name)
            }
        }
    }

    @ViewBuilder
    private var currentLocationLabel: some View {
        HStack(spacing: 4) {
            Text(Image(systemName: "location.fill"))
                .font(.caption2)
            Text(value.name)
            if let accessoryStatus {
                Group {
                    switch accessoryStatus {
                    case .warning:
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                    case .loadingState(.loading):
                        ProgressView()
                    case .loadingState(.failure):
                        Image(systemName: "exclamationmark.circle.fill")
                    default:
                        EmptyView()
                    }
                }
                .controlSize(.mini)
                .font(.caption2)
            }
        }
    }
}


// MARK: - Previews

import ModelStubs

#Preview {
    VStack {
        JourneyLocationTitleLabel(value: .unknownCurrentLocation)
        JourneyLocationTitleLabel(value: .unknownCurrentLocation, accessoryStatus: .loadingState(.loading))
        JourneyLocationTitleLabel(value: .unknownCurrentLocation, accessoryStatus: .loadingState(.failure(errorMessage: "")))
        JourneyLocationTitleLabel(value: .unknownCurrentLocation, accessoryStatus: .warning)
        JourneyLocationTitleLabel(
            value: .currentLocation(
                name: .init(title: "Example Road", subtitle: "Example region"),
                coordinate: nil
            )
        )
        JourneyLocationTitleLabel(value: .station(ModelStubs.kingsCrossStation))
        JourneyLocationTitleLabel(value: .nationalRail(ModelStubs.twickenhamRailStation))
        JourneyLocationTitleLabel(
            value: .namedLocation(
                .init(
                    name: .init(
                        title: "Named location title",
                        subtitle: "Named location subtitle"
                    ),
                    coordinate: nil,
                    isCurrentLocation: false
                )
            )
        )
        JourneyLocationTitleLabel(
            value: .namedLocation(
                .init(
                    name: .init(
                        title: "Named location title only",
                        subtitle: ""
                    ),
                    coordinate: nil,
                    isCurrentLocation: false
                )
            )
        )
    }
}
