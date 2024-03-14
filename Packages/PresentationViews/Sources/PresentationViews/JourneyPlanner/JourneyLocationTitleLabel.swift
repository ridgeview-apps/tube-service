import Models
import SwiftUI

public enum JourneyCurrentLocationAccessoryStatus {
    case warning
    case loadingState(LoadingState)
    case omitted
}

public struct JourneyLocationValueTitleLabel: View {
    public enum Style {
        case pickerList(LocationUIStatus)
        case form(JourneyCurrentLocationAccessoryStatus)
    }
    
    public let value: JourneyLocationPicker.Value
    public var style: Style
    
    public var body: some View {
        switch value {
        case let .currentLocation(name):
            currentLocationTitleView(for: name)
        case .station(let station):
            stationLabel(for: station)
        case .nationalRail(let stopPoint):
            nationalRailStationLabel(for: stopPoint)
        case let .searchResult(result):
            searchResultLabel(for: result)
        }
    }
    
    @ViewBuilder
    private func currentLocationTitleView(for locationName: String?) -> some View {
        HStack(alignment: .top, spacing: 4) {
            switch style {
            case .pickerList(let locationUIStatus):
                currentLocationIconAndLabel(locationName: locationName, 
                                            showsLocationSubtitle: true)
                    .locationUIStatus(locationUIStatus)
            case .form:
                currentLocationIconAndLabel(locationName: locationName, 
                                            showsLocationSubtitle: false)
            }
            currentLocationAccessoryView
        }
    }
    
    @ViewBuilder private func currentLocationIconAndLabel(locationName: String?,
                                                          showsLocationSubtitle: Bool) -> some View {
        Text(Image(systemName: "location.fill"))
        VStack(alignment: .leading) {
            Text("journey.planner.location.value.current.location", bundle: .module)
            if let locationName, showsLocationSubtitle {
                Text(locationName)
                    .font(.footnote)
            }
        }
    }
    
    @ViewBuilder
    private var currentLocationAccessoryView: some View {
        switch style {
        case .form(.warning):
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.yellow)
        case let .form(.loadingState(loadingState)):
            RefreshStatusView(loadingState: loadingState,
                              showsText: false)
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func stationLabel(for station: Station) -> some View {
        switch style {
        case .pickerList:
            StationLineGroupCell(station: station)
        case .form:
            Text(station.name)
        }
    }
    
    @ViewBuilder
    private func nationalRailStationLabel(for stopPoint: StopPoint) -> some View {
        switch style {
        case .pickerList:
            HStack(spacing: 8) {
                Image("national-rail", bundle: .module)
                    .resizable()
                    .scaledToFit()
                    .padding(2)
                    .frame(width: 40)
                    .foregroundStyle(Color.nationalRail)
                Text(stopPoint.sanitizedName ?? "")
            }
        case .form:
            Text(stopPoint.sanitizedName ?? "")
        }
    }
    
    @ViewBuilder
    private func searchResultLabel(for result: LocationSearchResult) -> some View {
        switch style {
        case .pickerList:
            VStack(alignment: .leading) {
                Text(result.title)
                Text(result.subtitle)
                    .font(.footnote)
            }
        case .form:
            Text(!result.subtitle.isEmpty ? result.subtitle : result.title)
        }
    }
}

private struct Previewer: View {
    let style: JourneyLocationValueTitleLabel.Style
    
    var body: some View {
        List {
            JourneyLocationValueTitleLabel(value: .currentLocation(name: nil), style: style)
            JourneyLocationValueTitleLabel(value: .currentLocation(name: "Barnet"), style: style)
            JourneyLocationValueTitleLabel(value: .station(ModelStubs.kingsCrossStation), style: style)
            JourneyLocationValueTitleLabel(value: .nationalRail(ModelStubs.twickenhamRailStation), style: style)
            JourneyLocationValueTitleLabel(value: .searchResult(.init(title: "Loc title", subtitle: "Loc subtitle")), style: style)
        }
        
    }
}

#Preview("Picker style") {
    Previewer(style: .pickerList(.init(style: .locationAllowed, onAllowLocation: {})))
}

#Preview("Form style") {
    Previewer(style: .form(.omitted))
}

#Preview("Location loading") {
    Previewer(style: .form(.loadingState(.loading)))
}

#Preview("Location error") {
    Previewer(style: .form(.loadingState(.failure(errorMessage: "Oops"))))
}
