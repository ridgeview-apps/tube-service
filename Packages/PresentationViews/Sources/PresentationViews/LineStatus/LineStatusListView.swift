import Models
import Shared
import SwiftUI

public struct LineStatusListView: View {
    
    public let loadingState: LoadingState
    public let lines: [Line]
    public let refreshDate: Date?
    
    @Binding var selectedLine: Line?
    @Binding var selectedFilterOption: LineStatusFilterOption
    @Binding var selectedFutureDate: Date?
    
    @State private var selectedDateInternal: Date = .now
    
    public init(loadingState: LoadingState,
                lines: [Line],
                refreshDate: Date?,
                selectedLine: Binding<Line?>,
                selectedFilterOption: Binding<LineStatusFilterOption>,
                selectedFutureDate: Binding<Date?>) {
        self.loadingState = loadingState
        self.lines = lines
        self.refreshDate = refreshDate
        self._selectedLine = selectedLine
        self._selectedFilterOption = selectedFilterOption
        self._selectedFutureDate = selectedFutureDate
    }
    
    public var body: some View {
        List(selection: $selectedLine) {
            Section {
                ForEach(lines) { line in
                    cell(with: line)
                }
            } header: {
                sectionHeader
            }
            .defaultListRowStyle()
        }
        .listStyle(.plain)
        .defaultScrollContentBackgroundColor()
    }
    
    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            filterOptions
            headerTitle
                .font(.subheadline)
            futureDatePicker
            RefreshStatusView(loadingState: loadingState,
                              refreshDate: refreshDate)
                .font(.caption)
                .foregroundStyle(Color.adaptiveMidGrey2)
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
                
            }
        }
        .pickerStyle(.segmented)
    }
    
    @ViewBuilder private var headerTitle: some View {
        switch selectedFilterOption {
        case .today:
            HStack(spacing: 4) {
                Image(systemName: "circle.inset.filled")
                    .pulsatingSymbol()
                Text("line.status.service.now", bundle: .module)
            }
        case .thisWeekend:
            Text(weekendDatesFormatted())
        case .future:
            EmptyView()
        }
    }
    
    @ViewBuilder private var futureDatePicker: some View {
        if selectedFilterOption == .future {
            VStack(alignment: .leading) {
                DatePicker(selection: $selectedDateInternal,
                           in: .now...,
                           displayedComponents: [.date]) {
                    Text("line.status.date.picker.please.select.title", bundle: .module)
                        .font(.subheadline)
                }
               .id(selectedFutureDate)
               .onChange(of: selectedDateInternal) {
                   selectedFutureDate = $0
               }
                if let selectedFutureDate, selectedFutureDate <= .now {
                    Text("line.status.error.date.invalid" , bundle: .module)
                        .foregroundStyle(Color.adaptiveRed)
                        .font(.callout)
                }
            }
        }
    }
    
    private func cell(with line: Line) -> some View {
        Button {
            selectedLine = line
        } label: {
            HStack(spacing: 0) {
                columnText(line.id.name)
                    .foregroundColor(line.id.textColor)
                    .background(line.id.backgroundColor)
                    .multilineTextAlignment(.leading)

                columnText(line.shortText)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(line.isDisrupted ? .adaptiveRed : .primary)

                accessoryImage(for: line)
            }
            .cardStyle()
            .frame(minHeight: 44)
        }
        .buttonStyle(.borderless)
        .padding(.bottom, 8)
    }
    
    private func columnText(_ text: String) -> some View {
        Text(text)
            .font(.body)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .leading)
            .padding(8)
    }
    
    @ViewBuilder private func accessoryImage(for lineStatus: Line) -> some View {
        if lineStatus.isDisrupted {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(.adaptiveRed)
                .padding(.trailing)
                .frame(width: 30)
        } else {
            Image(systemName: "chevron.right")
                .foregroundColor(.adaptiveMidGrey2)
                .padding(.trailing)
                .frame(width: 30)
        }
    }
    
    func weekendDatesFormatted() -> String {
        guard let thisOrNextWeekendDateInterval = Calendar.london.thisOrNextWeekendDateInterval(for: .now) else {
            return ""
        }
        let startOfSaturday = thisOrNextWeekendDateInterval.start
        let endOfSunday = thisOrNextWeekendDateInterval.end - 1 // Subtract 1 from Monday midnight (start of day)
        return DateIntervalFormatter.longDateIntervalStyle.string(from: startOfSaturday, to: endOfSunday)
    }
}

private extension LineStatusFilterOption {
    var localizedKey: LocalizedStringKey {
        switch self {
        case .today:
            return "line.status.filter.option.today"
        case .thisWeekend:
            return "line.status.filter.option.this.weekend"
        case .future:
            return "line.status.filter.option.future"
        }
    }
}


// MARK: - Previews

#if DEBUG
private struct WrapperView: View  {
    let loadingState: LoadingState
    let lines: [Line]
    var refreshDate: Date? = .now
    @State var selectedLine: Line?
    @State var selectedFilterOption: LineStatusFilterOption = .today
    @State var selectedFutureDate: Date?
    
    var body: some View {
        NavigationSplitView {
            LineStatusListView(
                loadingState: loadingState,
                lines: lines,
                refreshDate: refreshDate,
                selectedLine: $selectedLine,
                selectedFilterOption: $selectedFilterOption,
                selectedFutureDate: $selectedFutureDate
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
                lines: ModelStubs.lineStatusesToday.sortedByStatusSeverity())
}
         
#Preview("Loading state") {
    WrapperView(loadingState: .loading,
                lines: ModelStubs.lineStatusesToday.sortedByStatusSeverity())
}

#Preview("Error state") {
    WrapperView(loadingState: .failure(errorMessage: "Sorry, something went wrong"),
                lines: ModelStubs.lineStatusesToday.sortedByStatusSeverity())
}

#Preview("Future") {
    WrapperView(loadingState: .loaded,
                lines: [],
                selectedFilterOption: .future)
}
#endif
