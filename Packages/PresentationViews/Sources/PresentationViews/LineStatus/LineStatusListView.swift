import Models
import Shared
import SwiftUI

public struct LineStatusListView: View {
        
    public let loadingState: LoadingState
    public let lines: [Line]
    public let favouriteLineIDs: Set<TrainLineID>
    public let refreshDate: Date?
    
    @Binding var selectedLine: Line?
    @Binding var selectedFilterOption: LineStatusFilterOption
    @Binding var selectedDate: Date
    
    private var favourites: [Line] { lines.favouritesOnly(matching: favouriteLineIDs) }
    private var disruptions: [Line] { lines.disruptionsOnly().removingLineIDs(favouriteLineIDs) }
    private var allOtherLines: [Line] { lines.goodServiceOnly().removingLineIDs(favouriteLineIDs) }
    private var showsDatePicker: Bool { selectedFilterOption == .future }
    private var hasFavouritesOrDisruptions: Bool { !(favourites + disruptions).isEmpty }
        
    public init(loadingState: LoadingState,
                lines: [Line],
                favouriteLineIDs: Set<TrainLineID>,
                refreshDate: Date?,
                selectedLine: Binding<Line?>,
                selectedFilterOption: Binding<LineStatusFilterOption>,
                selectedDate: Binding<Date>) {
        self.loadingState = loadingState
        self.lines = lines
        self.favouriteLineIDs = favouriteLineIDs
        self.refreshDate = refreshDate
        self._selectedLine = selectedLine
        self._selectedFilterOption = selectedFilterOption
        self._selectedDate = selectedDate
    }
    
    public var body: some View {
        List(selection: $selectedLine) {
            Section {
                lineStatusCells
            } header: {
                stickyHeader
            }
            .listRowInsets(.init(top: 4, leading: 16, bottom: 4, trailing: 16))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.defaultBackground)
        }
        .defaultScrollContentBackgroundColor()
        .listStyle(.plain)
        .withHardScrollEdgeEffectStyle()
    }
    
    @ViewBuilder private var lineStatusCells: some View {
        if shouldShowLineStatusCells {
            tappableStatusCells(with: favourites, needsTopPadding: true)
            tappableStatusCells(with: disruptions,
                                needsTopPadding: favourites.isEmpty)
            if showOtherLinesSummaryCell {
                otherLinesSummaryCell
            } else {
                tappableStatusCells(with: allOtherLines,
                                    needsTopPadding: true)
            }
        }
    }
    
    private func tappableStatusCells(with lines: [Line],
                                     needsTopPadding: Bool = false) -> some View {
        ForEach(lines) { line in
            tappableStatusCell(for: line)
                .padding(.top, line == lines.first && needsTopPadding ? 12 : 0)
        }
    }
    
    private func tappableStatusCell(for line: Line) -> some View {
        Button {
            selectedLine = line
        } label: {
            LineStatusCell(
                style: .singleLine(line, showFavouriteImage: favouriteLineIDs.contains(line.id)),
                showsAccessory: true,
                animatedAccessoryImage: true
            )
            .cardStyle(cornerRadius: 8)
            .frame(minHeight: 52)
            .id(statusCellAnimationID(for: line))
        }
        .buttonStyle(.borderless)
        .accessibility(identifier: line.id.rawValue)        
    }
    
    private func statusCellAnimationID(for line: Line) -> some Hashable {
        "\(line.id)_\(selectedFilterOption)_\(refreshDate ?? .distantPast)"
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
    
    @ViewBuilder
    private var stickyHeader: some View {
        if #available(iOS 26.0, *) {
            headerContent
                .padding(12)
                .glassEffect(
                    .regular,
                    in: .rect(cornerRadius: 16)
                )
        } else {
            headerContent
                .listRowInsets(.zero)
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .background(Color.defaultBackground)
        }
    }
    
    private var headerContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            filterOptionsPicker
            headerTitleView
            refreshStatusView
            datePickerView
        }
        .foregroundStyle(.foreground)
    }
    
    private var filterOptionsPicker: some View {
        Picker("", selection: $selectedFilterOption) {
            ForEach(LineStatusFilterOption.allCases) { filterOption in
                Text(filterOption.localized)
                    .tag(filterOption)
                    .accessibilityIdentifier(filterOption.accessibilityID)
            }
        }
        .pickerStyle(.segmented)
    }
        
    @ViewBuilder private var headerTitleView: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            headerTitleImage
            headerTitleText
        }
        .font(.subheadline)
    }
    
    @ViewBuilder private var headerTitleImage: some View {
        switch selectedFilterOption {
        case .today:
            Image(systemName: "circle.inset.filled")
                .pulsatingSymbol()
        case .tomorrow, .thisWeekend, .future:
            Image(systemName: "hammer.circle.fill")
        }
    }
    
    @ViewBuilder private var headerTitleText: some View {
        switch selectedFilterOption {
        case .today:
            Text(.lineStatusServiceNow)
        case .tomorrow:
            Text(tomorrowFormatted())
        case .thisWeekend:
            Text(weekendDatesFormatted())
        case .future:
            if isValidFutureDate {
                Text(selectedDateFormatted())
            } else {
                Text(.lineStatusSelectOtherDateTitle)
                    .foregroundStyle(Color.adaptiveRed)
            }
        }
    }
    
    @ViewBuilder private var datePickerView: some View {
        if showsDatePicker {
            DatePicker(selection: $selectedDate,
                       in: .now...,
                       displayedComponents: [.date]) {
                Text(.lineStatusDatePickerTitle)
                    .font(.subheadline)
            }
            .withAutoDismissID(of: selectedDate)
        }
    }
    
    @ViewBuilder private var refreshStatusView: some View {
        if !shouldHideRefreshStatusView {
            RefreshStatusView(loadingState: loadingState,
                              refreshDate: refreshDate)
            .font(.caption2)
            .foregroundStyle(Color.adaptiveMidGrey2)
        }
    }
    
    private var shouldHideRefreshStatusView: Bool {
        selectedFilterOption == .future && !isValidFutureDate
    }
    
    private func tomorrowFormatted() -> String {
        guard let startOfTomorrow = Calendar.london.startOfTomorrow() else {
            return ""
        }
        return startOfTomorrow.formatted(date: .complete, time: .omitted)
    }
    
    private func weekendDatesFormatted() -> String {
        guard let thisOrNextWeekendDateInterval = Calendar.london.thisOrNextWeekendDateInterval(for: .now) else {
            return ""
        }
        let startOfSaturday = thisOrNextWeekendDateInterval.start
        let endOfSunday = thisOrNextWeekendDateInterval.end - 1 // Subtract 1 from Monday midnight (start of day)
        return DateIntervalFormatter.longDateIntervalStyle.string(from: startOfSaturday, to: endOfSunday)
    }
    
    private func selectedDateFormatted() -> String {
        selectedDate.formatted(date: .complete, time: .omitted)
    }
    
    private var otherLinesSummaryCell: some View {
        LineStatusCell(
            style: .multiLine(allOtherLines),
            showsAccessory: true
        )
        .cardStyle(cornerRadius: 8)
        .frame(minHeight: 52)
        .padding(.top, hasFavouritesOrDisruptions ? 12 : 0)
    }
}

private extension DatePicker {
    
    @ViewBuilder
    func withAutoDismissID(of date: Date) -> some View {
        // On iOS, setting an ID makes a date picker auto-dismiss on selection ✅
        // On macOS (Silicon), setting an ID causes a date picker to freeze 🙄
        if !ProcessInfo.processInfo.isiOSAppOnMac {
            id(date)
        } else {
            self
        }
    }
}

private extension LineStatusFilterOption {
    var localized: LocalizedStringResource {
        switch self {
        case .today:
            .lineStatusFilterOptionToday
        case .tomorrow:
            .lineStatusFilterOptionTomorrow
        case .thisWeekend:
            .lineStatusFilterOptionThisWeekend
        case .future:
            .lineStatusFilterOptionFuture
        }
    }
    
    var accessibilityID: String {
        switch self {
        case .today:
            "acc.id.filter.option.today"
        case .tomorrow:
            "acc.id.filter.option.tomorrow"
        case .thisWeekend:
            "acc.id.filter.option.thisWeekend"
        case .future:
            "acc.id.filter.option.future"
        }
    }
}

// MARK: - Previews

import ModelStubs

private struct WrapperView: View {
    let loadingState: LoadingState
    let lines: [Line]
    var favouriteLineIDs: Set<TrainLineID> = []
    var refreshDate: Date? = .now
    @State var selectedLine: Line?
    @State var selectedFilterOption: LineStatusFilterOption = .today
    @State var selectedDate: Date = .now
    
    var body: some View {
        NavigationSplitView {
            LineStatusListView(
                loadingState: loadingState,
                lines: lines,
                favouriteLineIDs: favouriteLineIDs,
                refreshDate: refreshDate,
                selectedLine: $selectedLine,
                selectedFilterOption: $selectedFilterOption,
                selectedDate: $selectedDate
            )
            .navigationTitle("Preview")
        } detail: {
            if let selectedLine {
                Text("\(selectedLine.id.longName) selected")
            } else {
                Text("No value selected")
            }
        }
    }
}
    
#Preview("Loaded state") {
    WrapperView(loadingState: .loaded,
                lines: ModelStubs.lineStatusesToday.sortedByStatusSeverity(),
                favouriteLineIDs: [.jubilee, .northern, .metropolitan])
}
         
#Preview("Loading state") {
    WrapperView(loadingState: .loading,
                lines: ModelStubs.lineStatusesToday.sortedByStatusSeverity(),
                favouriteLineIDs: [.jubilee, .northern])
}

#Preview("Error state") {
    WrapperView(loadingState: .failure(errorMessage: "Sorry, something went wrong"),
                lines: ModelStubs.lineStatusesToday.sortedByStatusSeverity(),
                favouriteLineIDs: [.jubilee, .northern])
}

#Preview("Date picker visible") {
    WrapperView(loadingState: .loaded,
                lines: [],
                favouriteLineIDs: [.jubilee, .northern],
                selectedFilterOption: .future)
}
