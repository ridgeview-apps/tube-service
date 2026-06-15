import Shared
import SwiftUI

struct ArrivalsBoardCellView: View {
    let item: ArrivalsBoardCellItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            numberLabel
            VStack(alignment: .leading, spacing: 4) {
                headerRow
                footerRow
            }
        }
    }

    private var numberLabel: some View {
        let label = item.numberLabel

        return Text(label.valueText)
            .padding(2)
            .minimumScaleFactor(0.4)
            .foregroundColor(label.textColor)
            .shadow(
                color: label.textShadow.color,
                radius: label.textShadow.radius,
                x: label.textShadow.x,
                y: label.textShadow.y
            )
            .frame(width: 28, height: 32)
            .background(label.backgroundColor)
            .roundedBorder(.white, cornerRadius: 4)
    }

    private var headerRow: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            destinationText
                .font(.headline)

            Spacer()

            text(for: item.headerRow.countdownText)
                .font(.callout)
        }
        .strikethrough(item.headerRow.needsStrikethrough)
        .foregroundStyle(Color.arrivalsBoardPrimary)
    }

    @ViewBuilder private var destinationText: some View {
        switch item.headerRow.destination {
        case .towards(let towards):
            text(for: .verbatim(towards))
        case .checkFrontOfTrain:
            text(for: .localized(.arrivalsCheckFrontOfTrain))
        }
    }

    @ViewBuilder private var footerRow: some View {
        if let footerRow = item.footerRow {
            switch footerRow {
            case .tubeLiveLocation(let currentLocation):
                text(for: .verbatim(currentLocation))
                    .foregroundStyle(.white)
                    .font(.caption)
            case .departureStatus(let departureStatus):
                departureStatusRow(departureStatus)
            }
        }
    }

    private func departureStatusRow(
        _ departureStatus: ArrivalsBoardCellItem.DepartureStatusState
    ) -> some View {
        HStack(alignment: .firstTextBaseline) {
            if let scheduledDeparture = departureStatus.scheduledDeparture {
                text(for: scheduledDeparture)
                    .foregroundStyle(Color.arrivalsBoardPrimary)
            }

            if let estimatedDeparture = departureStatus.estimatedDeparture {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Image(systemName: "exclamationmark.triangle")
                        .imageScale(.small)
                    text(for: estimatedDeparture)
                }
                .foregroundStyle(.midRed1)
                .fontWeight(.semibold)
            }

            Spacer()

            if let statusText = departureStatus.statusText {
                text(for: statusText)
                    .foregroundStyle(
                        departureStatus.style == .warning ? .midRed1 : .white
                    )
                    .fontWeight(
                        departureStatus.style == .warning ? .semibold : .regular
                    )
            }
        }
        .font(.footnote)
    }

    private func text(for textType: ArrivalsBoardCellItem.TextType) -> Text {
        switch textType {
        case .verbatim(let rawString):
            Text(rawString)
        case .localized(let localizedStringResource):
            Text(localizedStringResource)
        }
    }
}
