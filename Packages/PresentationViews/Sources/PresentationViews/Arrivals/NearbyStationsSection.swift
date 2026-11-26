import Models
import Shared
import SwiftUI

/// The nearby stations, or the location access, loading, empty or failure row in their place.
struct NearbyStationsSection: View {

    enum Action: Sendable {
        case tappedRefresh
        case tappedStation(Station)
    }

    var title: LocalizedStringResource?
    let locationAccess: LocationAccess
    let rows: [StopRow]
    let onAction: (Action) -> Void

    /// For a `ScrollViewReader`. A nearby station can also be in Recents, so the row's own ID isn't unique in the list.
    static func scrollID(for row: StopRow) -> String { "nearby-\(row.id)" }

    var body: some View {
        Section {
            switch locationAccess.state {
            case .notAsked:
                allowLocationRow
            case .denied:
                locationOffRow
            case .allowed(.loaded) where rows.isEmpty:
                zeroResultsView
            case .allowed(.failure) where rows.isEmpty:
                failureRow
            case .allowed:
                // A failed update keeps the last stations, which are usually still right
                stationRows
            }
        } header: {
            headerView
        }
        .lineGroupListRowStyle()
    }

    @ViewBuilder private var headerView: some View {
        if let title {
            HStack {
                LineGroupSectionHeader(title: title, imageName: "location")
                Spacer()
                statusView
            }
            .secondarySectionHeaderStyle()
        } else {
            statusView
        }
    }

    @ViewBuilder private var statusView: some View {
        switch locationAccess.state {
        case .allowed(.loading):
            LoadingStatusView(loadingState: .loading)
                .defaultLoadingStatusStyle()
        // Without stations, the failure row explains the error instead
        case .allowed(.failure) where !rows.isEmpty:
            updateFailureView
        default:
            EmptyView()
        }
    }

    private var updateFailureView: some View {
        HStack(spacing: 8) {
            LoadingStatusView(
                loadingState: .failure(errorMessage: String(localized: .nearbyStationsUpdateFailure))
            )
            .defaultLoadingStatusStyle()
            Button {
                onAction(.tappedRefresh)
            } label: {
                Label(.refreshButtonTitle, systemImage: "arrow.clockwise")
                    .labelStyle(.iconOnly)
            }
            .buttonStyle(.borderless)
            // The header's secondary style would otherwise grey it out
            .foregroundStyle(.tint)
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
            .id(Self.scrollID(for: row))
        }
    }

    private func accessibilityID(for row: StopRow) -> String {
        switch row.kind {
        case .station(let station):
            AccessibilityID.Nearby.station(station.id)
        }
    }

    private var failureRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(.locationDetectionFailure)
                Text(.nearbyStationsLoadFailureSubtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                onAction(.tappedRefresh)
            } label: {
                Text(.refreshButtonTitle)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .controlSize(.small)
        }
        .frame(minHeight: 52)
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
