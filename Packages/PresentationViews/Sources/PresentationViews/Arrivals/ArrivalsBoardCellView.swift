import Shared
import SwiftUI

struct ArrivalsBoardCellView: View {
    let item: ArrivalsBoardCellItem
    var style: ArrivalsBoardState.Style = .train

    @ScaledMetric(relativeTo: .headline) private var numberLabelWidth: CGFloat = 28
    @ScaledMetric(relativeTo: .headline) private var routeLabelWidth: CGFloat = 52
    @ScaledMetric(relativeTo: .headline) private var numberLabelHeight: CGFloat = 32
    @ScaledMetric(relativeTo: .headline) private var routeLabelHeight: CGFloat = 26

    var body: some View {
        Group {
            switch style {
            case .train:
                HStack(alignment: .top, spacing: 12) {
                    numberLabel
                    VStack(alignment: .leading, spacing: 4) {
                        headerRow
                        footerRow
                    }
                }
            case .bus:
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    numberLabel
                    headerRow
                }
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var numberLabel: some View {
        let label = item.numberLabel

        return Text(label.text)
            .lineLimit(1)
            .padding(2)
            .minimumScaleFactor(0.4)
            .foregroundColor(label.textColor)
            .shadow(
                color: label.textShadow.color,
                radius: label.textShadow.radius,
                x: label.textShadow.x,
                y: label.textShadow.y
            )
            .frame(
                width: label.width == .route ? routeLabelWidth : numberLabelWidth,
                height: style == .bus ? routeLabelHeight : numberLabelHeight
            )
            .background(label.backgroundColor)
            .clipShape(numberLabelShape)
            .overlay(numberLabelShape.strokeBorder(.white, lineWidth: 0.75))
            // Only orders the rows on screen, so it would be noise read out before each arrival
            .accessibilityHidden(true)
    }

    /// Matches `LineColourTile`, the line colour square in the chips above the boards.
    private var numberLabelShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: numberLabelWidth * 0.25, style: .continuous)
    }

    private var headerRow: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            destinationText
                .font(.headline)

            Spacer()

            text(for: item.headerRow.countdownText)
                .font(.callout)
                .monospacedDigit()
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
                    .foregroundStyle(.white.opacity(0.75))
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
                        departureStatus.style == .warning ? .midRed1 : .white.opacity(0.75)
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
