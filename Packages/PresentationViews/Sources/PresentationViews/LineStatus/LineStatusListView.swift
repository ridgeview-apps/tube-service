import Models
import Shared
import SwiftUI

public struct LineStatusListView: View {

    public enum Action {
        case selectLine(Line)
        case reorderFavourites([TrainLineID])
        case removeFavourites([TrainLineID])
    }

    public let loadingState: LoadingState
    public let lines: [Line]
    public let favouriteLineIDs: [TrainLineID]
    public let disruptionCountsByLineID: [TrainLineID: Int]
    public let refreshDate: Date?

    public let onAction: (Action) -> Void
    @Binding var selectedFilterOption: LineStatusFilterOption
    @Binding var selectedDate: Date
    @Binding var selectedWeekendDayFilter: WeekendDayFilter

    private var favourites: [Line] { lines.favouritesOnly(matching: favouriteLineIDs) }
    private var disruptions: [Line] { lines.disruptionsOnly().removingLineIDs(favouriteLineIDs) }
    private var goodServiceLines: [Line] { lines.goodServiceOnly().removingLineIDs(favouriteLineIDs) }

    @State private var isGoodServiceSectionExpanded = false
    @State private var editMode: EditMode = .inactive

    private var canReorderFavourites: Bool { favourites.count > 1 }

    public init(
        loadingState: LoadingState,
        lines: [Line],
        favouriteLineIDs: [TrainLineID],
        disruptionCountsByLineID: [TrainLineID: Int],
        refreshDate: Date?,
        onAction: @escaping (Action) -> Void,
        selectedFilterOption: Binding<LineStatusFilterOption>,
        selectedDate: Binding<Date>,
        selectedWeekendDayFilter: Binding<WeekendDayFilter>
    ) {
        self.loadingState = loadingState
        self.lines = lines
        self.favouriteLineIDs = favouriteLineIDs
        self.disruptionCountsByLineID = disruptionCountsByLineID
        self.refreshDate = refreshDate
        self.onAction = onAction
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
        .contentMargins(.bottom, 24, for: .scrollContent)
        .environment(\.defaultMinListRowHeight, 0)
        .environment(\.editMode, $editMode)
        .onChange(of: selectedFilterOption) {
            isGoodServiceSectionExpanded = false
            editMode = .inactive
        }
        .onChange(of: favourites.isEmpty) {
            if favourites.isEmpty { editMode = .inactive }
        }
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
            favouriteLineCells
            disruptionLineCells
            goodServiceLineCells
        }
    }

    @ViewBuilder
    private var favouriteLineCells: some View {
        if !favourites.isEmpty {
            sectionLabel(.lineStatusSectionFavourites, systemImage: "star.fill") {
                editFavouritesButton
            }
            tappableStatusCells(with: favourites)
                .onMove(perform: moveFavourites)
                .onDelete(perform: removeFavourites)
                .moveDisabled(!canReorderFavourites)
                // Empty swipe actions replace onDelete's swipe-to-delete, so lines are only removable from
                // edit mode. Toggling deleteDisabled with edit mode instead stops the delete controls animating in.
                .swipeActions {}
        }
    }

    private var editFavouritesButton: some View {
        let title: LocalizedStringResource = editMode.isEditing ? .globalDone : .globalEdit
        return Button(title) {
            withAnimation { editMode = editMode.isEditing ? .inactive : .active }
        }
        .buttonStyle(.borderless)
    }

    private func moveFavourites(fromOffsets source: IndexSet, toOffset destination: Int) {
        var reorderedLineIDs = favourites.map(\.id)
        reorderedLineIDs.move(fromOffsets: source, toOffset: destination)
        onAction(.reorderFavourites(reorderedLineIDs))
    }

    private func removeFavourites(atOffsets offsets: IndexSet) {
        let removedLineIDs = offsets.map { favourites[$0].id }
        withAnimation { onAction(.removeFavourites(removedLineIDs)) }
    }

    @ViewBuilder
    private var disruptionLineCells: some View {
        if !disruptions.isEmpty {
            sectionLabel(.lineStatusSectionDisruptions)
            tappableStatusCells(with: disruptions)
        }
    }

    @ViewBuilder
    private var goodServiceLineCells: some View {
        if !goodServiceLines.isEmpty {
            if goodServiceLines.count == 1 {
                sectionLabel(.lineStatusSectionGoodService)
                tappableStatusCells(with: goodServiceLines)
            } else {
                collapsibleGoodServiceSectionLabel
                if isGoodServiceSectionExpanded {
                    tappableStatusCells(with: goodServiceLines)
                } else {
                    // The summary card expands the lines too, as it's the larger tap target
                    Button(action: toggleGoodServiceSection) {
                        goodServiceSummaryCell
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
    }

    private func toggleGoodServiceSection() {
        withAnimation(.easeInOut) { isGoodServiceSectionExpanded.toggle() }
    }

    private var collapsibleGoodServiceSectionLabel: some View {
        Button(action: toggleGoodServiceSection) {
            HStack(spacing: 8) {
                Text(.lineStatusSectionGoodService)
                    .secondarySectionHeaderStyle()
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .rotationEffect(.degrees(isGoodServiceSectionExpanded ? 90 : 0))
            }
            .contentShape(.rect)
            .padding(.top, 8)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(.isHeader)
        .accessibilityValue(
            Text(
                isGoodServiceSectionExpanded
                    ? .lineStatusSectionGoodServiceAccessibilityExpanded
                    : .lineStatusSectionGoodServiceAccessibilityCollapsed
            )
        )
    }

    private func sectionLabel(_ title: LocalizedStringResource, systemImage: String? = nil) -> some View {
        sectionLabel(title, systemImage: systemImage) { EmptyView() }
    }

    private func sectionLabel(
        _ title: LocalizedStringResource,
        systemImage: String?,
        @ViewBuilder trailingContent: () -> some View
    ) -> some View {
        HStack(spacing: 4) {
            LineGroupSectionHeader(title: title, imageName: systemImage)
                .secondarySectionHeaderStyle()
                .accessibilityAddTraits(.isHeader)
            Spacer()
            trailingContent()
                .font(.footnote.weight(.semibold))
        }
        .padding(.top, 8)
    }

    private func tappableStatusCells(with lines: [Line]) -> some DynamicViewContent {
        ForEach(lines) { line in
            tappableStatusCell(for: line)
        }
    }

    private func tappableStatusCell(for line: Line) -> some View {
        Button {
            // Rows are drag targets while reordering, so don't navigate away
            guard !editMode.isEditing else { return }
            onAction(.selectLine(line))
        } label: {
            LineStatusCell(
                style: .singleLine(line, isFavourite: false),  // The Favourites section label marks them instead
                showsAccessory: true,
                animatedAccessoryImage: true,
                historyIndicator: historyIndicator(for: line)
            )
            .frame(minHeight: 56)
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

    private var goodServiceSummaryCell: some View {
        LineStatusCell(
            style: .multiLine(goodServiceLines),
            showsAccessory: true
        )
        .cardStyle()
        .frame(minHeight: 76)
    }
}

// MARK: - Previews

import ModelStubs

private struct WrapperView: View {
    let loadingState: LoadingState
    let lines: [Line]
    var favouriteLineIDs: [TrainLineID] = []
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
                onAction: { _ in },
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
