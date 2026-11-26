import Models
import Shared
import SwiftUI

/// The nearby stops, or the location access, loading, empty or failure row in their place.
struct NearbySection<Rows: View>: View {

    var title: LocalizedStringResource?
    let locationAccess: LocationAccess
    let isEmpty: Bool
    let noResultsText: LocalizedStringResource
    let onRefresh: () -> Void
    @ViewBuilder let rows: Rows

    var body: some View {
        Section {
            switch locationAccess.state {
            case .notAsked:
                allowLocationRow
            case .denied:
                locationOffRow
            case .allowed(.loaded) where isEmpty:
                zeroResultsView
            case .allowed(.failure) where isEmpty:
                failureRow
            case .allowed:
                // A failed update keeps the last stops, which are usually still right
                rows
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
        // Without stops, the failure row explains the error instead
        case .allowed(.failure) where !isEmpty:
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
                onRefresh()
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
            Text(noResultsText)
            refreshButton
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
                onRefresh()
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
            onRefresh()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "arrow.clockwise")
                Text(.refreshButtonTitle)
            }
        }
        .buttonStyle(.primary)
    }
}
