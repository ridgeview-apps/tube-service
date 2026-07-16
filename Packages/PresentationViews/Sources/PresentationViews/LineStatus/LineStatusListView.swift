import Models
import Shared
import SwiftUI

public struct LineStatusListView: View {

    public let loadingState: LoadingState
    public let lines: [Line]
    public let favouriteLineIDs: Set<TrainLineID>
    public let disruptionCountsByLineID: [TrainLineID: Int]
    public let refreshDate: Date?

    public let onSelectLine: (Line) -> Void
    @Binding var selectedFilterOption: LineStatusFilterOption
    @Binding var selectedDate: Date
    @Binding var selectedWeekendDayFilter: WeekendDayFilter

    private var favourites: [Line] { lines.favouritesOnly(matching: favouriteLineIDs) }
    private var disruptions: [Line] { lines.disruptionsOnly().removingLineIDs(favouriteLineIDs) }
    private var allOtherLines: [Line] { lines.goodServiceOnly().removingLineIDs(favouriteLineIDs) }

    @State private var isOtherLinesExpanded = false

    public init(
        loadingState: LoadingState,
        lines: [Line],
        favouriteLineIDs: Set<TrainLineID>,
        disruptionCountsByLineID: [TrainLineID: Int],
        refreshDate: Date?,
        onSelectLine: @escaping (Line) -> Void,
        selectedFilterOption: Binding<LineStatusFilterOption>,
        selectedDate: Binding<Date>,
        selectedWeekendDayFilter: Binding<WeekendDayFilter>
    ) {
        self.loadingState = loadingState
        self.lines = lines
        self.favouriteLineIDs = favouriteLineIDs
        self.disruptionCountsByLineID = disruptionCountsByLineID
        self.refreshDate = refreshDate
        self.onSelectLine = onSelectLine
        self._selectedFilterOption = selectedFilterOption
        self._selectedDate = selectedDate
        self._selectedWeekendDayFilter = selectedWeekendDayFilter
    }

    public var body: some View {
        List {
            Section {
                loadingStatusView
                lineStatusCells
            } header: {
                LineStatusFilterHeader(
                    refreshDate: refreshDate,
                    selectedFilterOption: $selectedFilterOption,
                    selectedDate: $selectedDate,
                    selectedWeekendDayFilter: $selectedWeekendDayFilter
                )
            }
            .listRowInsets(.init(top: 4, leading: 16, bottom: 4, trailing: 16))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.defaultBackground)
        }
        .defaultMaxWidthWithFullBackground()
        .listStyle(.plain)
        .withHardScrollEdgeEffectStyle(for: .top)
        .environment(\.defaultMinListRowHeight, 0)
        .onChange(of: selectedFilterOption) { isOtherLinesExpanded = false }
    }

    private var loadingStatusView: some View {
        LoadingStatusView(
            loadingState: loadingState
        )
        .defaultLoadingStatusStyle()
        .frame(height: loadingState == .loaded ? 0 : nil)
    }

    @ViewBuilder private var lineStatusCells: some View {
        if shouldShowLineStatusCells {
            Spacer()
                .listRowInsets(.zero)
                .frame(height: 8)
            if !favourites.isEmpty {
                sectionLabel(.lineStatusSectionFavourites, systemImage: "star.fill")
                tappableStatusCells(with: favourites)
            }
            if !disruptions.isEmpty {
                sectionLabel(.lineStatusSectionDisruptions, systemImage: "exclamationmark.triangle.fill")
                tappableStatusCells(with: disruptions)
            }
            allOtherLineCells
        }
    }

    @ViewBuilder
    private var allOtherLineCells: some View {
        if !allOtherLines.isEmpty {
            if allOtherLines.count == 1 {
                sectionLabel(otherLinesSectionTitle)
                tappableStatusCells(with: allOtherLines)
            } else {
                collapsibleOtherLinesSectionLabel
                if isOtherLinesExpanded {
                    tappableStatusCells(with: allOtherLines)
                } else {
                    Button {
                        withAnimation(.easeInOut) { isOtherLinesExpanded.toggle() }
                    } label: {
                        otherLinesSummaryCell
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
    }

    private var otherLinesSectionTitle: LocalizedStringResource {
        favourites.isEmpty && disruptions.isEmpty
            ? .lineStatusSectionAllLines
            : .lineStatusSectionAllOtherLines
    }

    private var collapsibleOtherLinesSectionLabel: some View {
        Button {
            withAnimation(.easeInOut) { isOtherLinesExpanded.toggle() }
        } label: {
            HStack(spacing: 8) {
                Text(otherLinesSectionTitle)
                    .secondarySectionHeaderStyle()
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .rotationEffect(.degrees(isOtherLinesExpanded ? 90 : 0))
            }
            .contentShape(.rect)
            .padding(.top, 8)
        }
        .buttonStyle(.plain)
    }

    private func sectionLabel(_ title: LocalizedStringResource, systemImage: String? = nil) -> some View {
        HStack(spacing: 4) {
            if let systemImage {
                Image(systemName: systemImage)
            }
            Text(title)
        }
        .secondarySectionHeaderStyle()
        .padding(.top, 8)
    }

    private func tappableStatusCells(with lines: [Line]) -> some View {
        ForEach(lines) { line in
            tappableStatusCell(for: line)
        }
    }

    private func tappableStatusCell(for line: Line) -> some View {
        Button {
            onSelectLine(line)
        } label: {
            LineStatusCell(
                style: .singleLine(line),
                showsAccessory: true,
                animatedAccessoryImage: true,
                historyIndicator: historyIndicator(for: line)
            )
            .frame(minHeight: 52)
            .cardStyle()
            .id(statusCellAnimationID(for: line))
        }
        .buttonStyle(.borderless)
        .accessibility(identifier: line.id.rawValue)
    }

    private func statusCellAnimationID(for line: Line) -> some Hashable {
        "\(line.id)_\(selectedFilterOption)_\(refreshDate ?? .distantPast)"
    }

    private func historyIndicator(for line: Line) -> LineStatusHistoryIndicator? {
        guard selectedFilterOption == .today else { return nil }
        return line.historyIndicator(disruptionCountsByLineID: disruptionCountsByLineID)
    }

    private var shouldShowLineStatusCells: Bool {
        switch selectedFilterOption {
        case .today, .tomorrow, .thisWeekend:
            return true
        case .future:
            return isValidFutureDate
        }
    }

    private var isValidFutureDate: Bool {
        guard let startOfTomorrow = Calendar.london.startOfTomorrow() else {
            return true
        }
        return selectedDate >= startOfTomorrow
    }

    private var otherLinesSummaryCell: some View {
        LineStatusCell(
            style: .multiLine(allOtherLines),
            showsAccessory: true
        )
        .cardStyle()
        .frame(minHeight: 72)
    }
}

// MARK: - Previews

import ModelStubs

private struct WrapperView: View {
    let loadingState: LoadingState
    let lines: [Line]
    var favouriteLineIDs: Set<TrainLineID> = []
    var disruptionCountsByLineID: [TrainLineID: Int] = [:]
    var refreshDate: Date? = .now
    @State var selectedFilterOption: LineStatusFilterOption = .today
    @State var selectedDate: Date = .now
    @State var selectedWeekendDayFilter: WeekendDayFilter = .both

    var body: some View {
        NavigationStack {
            LineStatusListView(
                loadingState: loadingState,
                lines: lines,
                favouriteLineIDs: favouriteLineIDs,
                disruptionCountsByLineID: disruptionCountsByLineID,
                refreshDate: refreshDate,
                onSelectLine: { _ in },
                selectedFilterOption: $selectedFilterOption,
                selectedDate: $selectedDate,
                selectedWeekendDayFilter: $selectedWeekendDayFilter
            )
            .navigationTitle("Preview")
        }
    }
}

#Preview("Loaded state") {
    WrapperView(
        loadingState: .loaded,
        lines: ModelStubs.lineStatusesToday.sortedByStatusSeverity(),
        favouriteLineIDs: [.jubilee, .northern, .metropolitan],
        disruptionCountsByLineID: Dictionary(uniqueKeysWithValues: TrainLineID.allCases.map { ($0, 2) })
    )
}

#Preview("Loading state") {
    WrapperView(
        loadingState: .loading,
        lines: ModelStubs.lineStatusesToday.sortedByStatusSeverity(),
        favouriteLineIDs: [.jubilee, .northern]
    )
}

#Preview("Error state") {
    WrapperView(
        loadingState: .failure(errorMessage: "Sorry, something went wrong"),
        lines: ModelStubs.lineStatusesToday.sortedByStatusSeverity(),
        favouriteLineIDs: [.jubilee, .northern]
    )
}

#Preview("Date picker visible") {
    WrapperView(
        loadingState: .loaded,
        lines: [],
        favouriteLineIDs: [.jubilee, .northern],
        selectedFilterOption: .future
    )
}

#Preview("All good service - no favourites") {
    WrapperView(
        loadingState: .loaded,
        lines: ModelStubs.lineStatusesToday.sortedByStatusSeverity()
    )
}

#Preview("Weekend filter") {
    WrapperView(
        loadingState: .loaded,
        lines: ModelStubs.lineStatusesToday.sortedByStatusSeverity(),
        favouriteLineIDs: [],
        selectedFilterOption: .thisWeekend
    )
}
