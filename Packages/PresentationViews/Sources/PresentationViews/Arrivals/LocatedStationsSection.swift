import Models
import Shared
import SwiftUI

/// The nearby stations, or the location access, loading, empty or failure row in their place.
struct LocatedStationsSection: View {

    var title: LocalizedStringResource?
    let locationAccess: LocationAccess
    let rows: [StopRow]
    let onAction: (LocatedStationsView.Action) -> Void

    var body: some View {
        Section {
            switch locationAccess.state {
            case .notAsked:
                allowLocationRow
            case .denied:
                locationOffRow
            case .allowed(.loaded) where rows.isEmpty:
                zeroResultsView
            case .allowed(.loaded), .allowed(.loading):
                stationRows
            case .allowed(.failure):
                errorView
            }
        } header: {
            headerView
        }
        .lineGroupListRowStyle()
    }

    @ViewBuilder private var headerView: some View {
        if let title {
            HStack {
                Text(title)
                Spacer()
                loadingStatusView
            }
        } else {
            loadingStatusView
        }
    }

    @ViewBuilder private var loadingStatusView: some View {
        if let loadingState = locationAccess.loadingState {
            LoadingStatusView(loadingState: loadingState)
                .defaultLoadingStatusStyle()
        }
    }

    private var allowLocationRow: some View {
        Button {
            locationAccess.onRequestPermissions()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "location.fill")
                VStack(alignment: .leading, spacing: 2) {
                    Text(.locationAccessNearbyAllowTitle)
                    Text(.locationAccessNearbyAllowSubtitle)
                        .font(.footnote)
                        // A hierarchical style would be tinted by the button
                        .foregroundStyle(Color.secondary)
                }
            }
            .frame(minHeight: 52)
        }
    }

    private var locationOffRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "location.slash")
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(.locationAccessNearbyOffTitle)
                Text(.locationAccessNearbyOffSubtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            OpenSettingsButton()
        }
        .frame(minHeight: 52)
    }

    private var zeroResultsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(.nearbyStationsNoResults)
            refreshButton
        }
    }

    private var stationRows: some View {
        ForEach(rows) { row in
            Button {
                switch row.kind {
                case .station(let station):
                    onAction(.tappedStation(station))
                }
            } label: {
                StopRowCell(row: row)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier(accessibilityID(for: row))
        }
    }

    private func accessibilityID(for row: StopRow) -> String {
        switch row.kind {
        case .station(let station):
            AccessibilityID.Nearby.station(station.id)
        }
    }

    private var errorView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(.nearbyStationsLoadFailureTitle)
                .font(.headline)
            refreshButton
        }
    }

    private var refreshButton: some View {
        Button {
            onAction(.tappedRefresh)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "arrow.clockwise")
                Text(.refreshButtonTitle)
            }
        }
        .buttonStyle(.primary)
    }
}
