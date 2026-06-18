import Models
import Shared
import SwiftUI

struct LineStatusFilterHeader: View {

    let refreshDate: Date?

    @Binding var selectedFilterOption: LineStatusFilterOption
    @Binding var selectedDate: Date
    @Binding var selectedWeekendDayFilter: WeekendDayFilter

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            filterOptionsPicker
            if selectedFilterOption == .thisWeekend {
                weekendDayFilterPicker
            } else if selectedFilterOption == .future {
                DatePicker(
                    selection: $selectedDate,
                    in: .now...,
                    displayedComponents: [.date]
                ) {
                    Text(.lineStatusDatePickerTitle)
                        .font(.subheadline)
                }
                .withAutoDismissID(of: selectedDate)
            } else {
                headerTitleView
            }
        }
        .foregroundStyle(.foreground)
        .padding(12)
        .cardStyle()
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

    private var weekendDayFilterPicker: some View {
        HStack(spacing: 8) {
            ForEach(WeekendDayFilter.allCases) { filter in
                Button {
                    selectedWeekendDayFilter = filter
                } label: {
                    Text(filter.localized)
                        .font(.subheadline.weight(.medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .foregroundStyle(
                            selectedWeekendDayFilter == filter
                                ? Color.white : Color.secondary
                        )
                        .background(
                            selectedWeekendDayFilter == filter
                                ? Color.accentColor : Color.secondary.opacity(0.12),
                            in: .capsule
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    @ViewBuilder private var headerTitleView: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            headerTitleImage
            headerTitleText
            Spacer()
            if let refreshDate, selectedFilterOption == .today {
                LastUpatedTimeLabel(date: refreshDate)
                    .defaultLastUpdatedTimeLabelStyle()
            }
        }
        .font(.subheadline)
    }

    @ViewBuilder private var headerTitleImage: some View {
        switch selectedFilterOption {
        case .today:
            Image(systemName: "circle.inset.filled")
                .pulsatingSymbol()
        case .tomorrow, .thisWeekend, .future:
            Image(systemName: "calendar")
        }
    }

    @ViewBuilder private var headerTitleText: some View {
        switch selectedFilterOption {
        case .today:
            Text(.lineStatusServiceNow)
        case .tomorrow:
            Text(tomorrowFormatted())
        case .thisWeekend, .future:
            EmptyView()
        }
    }

    private func tomorrowFormatted() -> String {
        guard let startOfTomorrow = Calendar.london.startOfTomorrow() else {
            return ""
        }
        return startOfTomorrow.formatted(date: .complete, time: .omitted)
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

private extension WeekendDayFilter {
    var localized: LocalizedStringResource {
        switch self {
        case .both: .lineStatusFilterWeekendDayBoth
        case .saturday: .lineStatusFilterWeekendDaySaturday
        case .sunday: .lineStatusFilterWeekendDaySunday
        }
    }
}
