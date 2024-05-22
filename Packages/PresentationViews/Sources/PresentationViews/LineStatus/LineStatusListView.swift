import Models
import Shared
import SwiftUI

public struct LineStatusListView: View {
    
    @ScaledMetric private var dynamicTextScale: CGFloat = 1
    
    public let loadingState: LoadingState
    public let lines: [Line]
    public let favouriteLineIDs: Set<TrainLineID>
    public let refreshDate: Date?
    
    @Binding var selectedLine: Line?
    @Binding var selectedFilterOption: LineStatusFilterOption
    @Binding var selectedDate: Date
    
    @State private var hasSelectedADate = false
    
    private var favourites: [Line] { lines.favouritesOnly(matching: favouriteLineIDs) }
    private var disruptions: [Line] { lines.disruptionsOnly().removingLineIDs(favouriteLineIDs) }
    private var allOtherLines: [Line] { lines.goodServiceOnly().removingLineIDs(favouriteLineIDs) }
    private var showsDatePicker: Bool { selectedFilterOption == .other }
        
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
                datePickerView
                    .padding(.bottom)
                lineStatusCells
            } header: {
                sectionHeader
            }
            .defaultListRowStyle()
        }
        .listStyle(.plain)
        .defaultScrollContentBackgroundColor()
    }
    
    @ViewBuilder private var lineStatusCells: some View {
        if shouldShowLineStatusCells {
            tappableStatusCells(with: favourites)
            tappableStatusCells(with: disruptions)
            if showOtherLinesSummaryCell {
                otherLinesSummaryCell
            } else {
                tappableStatusCells(with: allOtherLines)
            }
        }
    }
    
    private func tappableStatusCells(with lines: [Line]) -> some View {
        ForEach(lines) { line in
            tappableStatusCell(for: line)
                .padding(.top, line.id == lines.first?.id ? 12 : 0)
        }
    }
    
    private func tappableStatusCell(for line: Line) -> some View {
        Button {
            selectedLine = line
        } label: {
            LineStatusCell(
                style: .singleLine(line, showFavouriteImage: favouriteLineIDs.contains(line.id)),
                showsAccessory: true
            )
            .cardStyle()
            .frame(minHeight: 44 * dynamicTextScale)
        }
        .buttonStyle(.borderless)
        .padding(.bottom, 8)
        .accessibility(identifier: line.id.rawValue)
        .id(line.id)
    }
    
    private var shouldShowLineStatusCells: Bool {
        switch selectedFilterOption {
        case .today, .tomorrow, .thisWeekend:
            return true
        case .other:
            return isValidFutureDate
        }
    }
    
    private var showOtherLinesSummaryCell: Bool {
        switch selectedFilterOption {
        case .today:
            return false
        case .tomorrow, .thisWeekend, .other:
            return allOtherLines.count > 1
        }
    }
    
    private var isValidFutureDate: Bool {
        guard let startOfTomorrow = Calendar.london.startOfTomorrow() else {
            return true
        }
        return selectedDate >= startOfTomorrow
    }
    
    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            filterOptions
            refreshStatusView
            headerTitleView    
        }
        .foregroundStyle(.foreground)
        .padding(.top, 4)
        .padding(.bottom, 8)
    }
    
    private var filterOptions: some View {
        Picker("", selection: $selectedFilterOption) {
            ForEach(LineStatusFilterOption.allCases) { filterOption in
                Text(filterOption.localizedKey, bundle: .module)
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
        case .tomorrow, .thisWeekend, .other:
            Image(systemName: "hammer.circle.fill")
        }
    }
    
    @ViewBuilder private var headerTitleText: some View {
        switch selectedFilterOption {
        case .today:
            Text("line.status.service.now", bundle: .module)
        case .tomorrow:
            Text("line.status.planned.status.title \(tomorrowFormatted())", bundle: .module)
        case .thisWeekend:
            Text("line.status.planned.status.title \(weekendDatesFormatted())", bundle: .module)
        case .other:
            if isValidFutureDate {
                Text("line.status.planned.status.title \(selectedDateFormatted())", bundle: .module)
            } else {
                Text("line.status.select.other.date.title", bundle: .module)
                    .foregroundStyle(hasSelectedADate ? Color.adaptiveRed : Color.primary)
            }
        }
    }
    
    @ViewBuilder private var datePickerView: some View {
        if showsDatePicker {
            DatePicker(selection: $selectedDate,
                       in: .now...,
                       displayedComponents: [.date]) {
                Text("line.status.date.picker.title", bundle: .module)
                    .font(.subheadline)
            }
            .id(selectedDate)
            .onChange(of: selectedDate) {
                hasSelectedADate = true
            }
        }
    }
    
    @ViewBuilder private var refreshStatusView: some View {
        if !shouldHideRefreshStatusView {
            RefreshStatusView(loadingState: loadingState,
                              refreshDate: refreshDate)
            .font(.caption)
            .foregroundStyle(Color.adaptiveMidGrey2)
        }
    }
    
    private var shouldHideRefreshStatusView: Bool {
        selectedFilterOption == .other && !isValidFutureDate
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
        .cardStyle()
        .frame(minHeight: 44 * dynamicTextScale)
        .padding(.top, 12)
    }
}

private extension LineStatusFilterOption {
    var localizedKey: LocalizedStringKey {
        switch self {
        case .today:
            return "line.status.filter.option.today"
        case .tomorrow:
            return "line.status.filter.option.tomorrow"
        case .thisWeekend:
            return "line.status.filter.option.this.weekend"
        case .other:
            return "line.status.filter.option.other"
        }
    }
    
    var accessibilityID: String {
        switch self {
        case .today:
            return "acc.id.filter.option.today"
        case .tomorrow:
            return "acc.id.filter.option.tomorrow"
        case .thisWeekend:
            return "acc.id.filter.option.thisWeekend"
        case .other:
            return "acc.id.filter.option.other"
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
                favouriteLineIDs: [.jubilee, .northern])
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
                selectedFilterOption: .other)
}
