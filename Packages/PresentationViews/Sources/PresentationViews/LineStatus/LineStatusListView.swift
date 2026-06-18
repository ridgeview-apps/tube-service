import Models
import Shared
import SwiftUI

public struct LineStatusListView: View {

    public let loadingState: LoadingState
    public let lines: [Line]
    public let favouriteLineIDs: Set<TrainLineID>
    public let disruptionCountsByLineID: [TrainLineID: Int]
    public let refreshDate: Date?

    @Binding var selectedLine: Line?
    @Binding var selectedFilterOption: LineStatusFilterOption
    @Binding var selectedDate: Date

    private var favourites: [Line] { lines.favouritesOnly(matching: favouriteLineIDs) }
    private var disruptions: [Line] { lines.disruptionsOnly().removingLineIDs(favouriteLineIDs) }
    private var allOtherLines: [Line] { lines.goodServiceOnly().removingLineIDs(favouriteLineIDs) }
    private var hasFavouritesOrDisruptions: Bool { !(favourites + disruptions).isEmpty }

    public init(
        loadingState: LoadingState,
        lines: [Line],
        favouriteLineIDs: Set<TrainLineID>,
        disruptionCountsByLineID: [TrainLineID: Int],
        refreshDate: Date?,
        selectedLine: Binding<Line?>,
        selectedFilterOption: Binding<LineStatusFilterOption>,
        selectedDate: Binding<Date>
    ) {
        self.loadingState = loadingState
        self.lines = lines
        self.favouriteLineIDs = favouriteLineIDs
        self.disruptionCountsByLineID = disruptionCountsByLineID
        self.refreshDate = refreshDate
        self._selectedLine = selectedLine
        self._selectedFilterOption = selectedFilterOption
        self._selectedDate = selectedDate
    }

    public var body: some View {
        List(selection: $selectedLine) {
            Section {
                loadingStatusView
                lineStatusCells
            } header: {
                LineStatusFilterHeader(
                    refreshDate: refreshDate,
                    selectedFilterOption: $selectedFilterOption,
                    selectedDate: $selectedDate
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
            if hasFavouritesOrDisruptions {
                tappableStatusCells(with: favourites)
                tappableStatusCells(with: disruptions)
            }
            allOtherLineCells
        }
    }

    @ViewBuilder
    private var allOtherLineCells: some View {
        if !allOtherLines.isEmpty {
            sectionLabel(.lineStatusSectionAllOtherLines)

            if showOtherLinesSummaryCell {
                otherLinesSummaryCell
            } else {
                tappableStatusCells(with: allOtherLines)
            }
        }
    }

    private func sectionLabel(_ title: LocalizedStringResource) -> some View {
        Text(title)
            .secondarySectionHeaderStyle()
            .padding(.top, 8)
    }

    private func tappableStatusCells(
        with lines: [Line]
    ) -> some View {
        ForEach(lines) { line in
            tappableStatusCell(
                for: line,
                isFavourite: favouriteLineIDs.contains(line.id)
            )
        }
    }

    private func tappableStatusCell(
        for line: Line,
        isFavourite: Bool
    ) -> some View {
        Button {
            selectedLine = line
        } label: {
            LineStatusCell(
                style: .singleLine(line),
                showsAccessory: true,
                animatedAccessoryImage: true,
                isFavourite: isFavourite,
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

    private var showOtherLinesSummaryCell: Bool {
        switch selectedFilterOption {
        case .today:
            return false
        case .tomorrow, .thisWeekend, .future:
            return allOtherLines.count > 1
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
        .frame(minHeight: 52)
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
    @State var selectedLine: Line?
    @State var selectedFilterOption: LineStatusFilterOption = .today
    @State var selectedDate: Date = .now

    var body: some View {
        NavigationStack {
            LineStatusListView(
                loadingState: loadingState,
                lines: lines,
                favouriteLineIDs: favouriteLineIDs,
                disruptionCountsByLineID: disruptionCountsByLineID,
                refreshDate: refreshDate,
                selectedLine: $selectedLine,
                selectedFilterOption: $selectedFilterOption,
                selectedDate: $selectedDate
            )
            .navigationTitle("Preview")
            .navigationDestination(item: $selectedLine) { selectedLine in
                Text("\(selectedLine.id.longName) selected")
            }
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
