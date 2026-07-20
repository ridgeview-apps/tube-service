import Models
import SwiftUI

public struct LineStatusCell: View {

    public let style: Style
    public let showsAccessory: Bool
    public var leadingColumnInset = 4.0
    public var animatedAccessoryImage: Bool = false
    public var historyIndicator: LineStatusHistoryIndicator?

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @ScaledMetric private var dynamicScaleFactor: CGFloat = 1

    public enum Style: Hashable {
        case singleLine(Line, isFavourite: Bool)
        case multiLine([Line])

        var accessoryImageType: LineStatusAccessoryImageType {
            switch self {
            case .singleLine(let line, _):
                return line.isDisrupted ? .disruption : .goodService
            case .multiLine(let lines):
                return lines.allAreGoodService ? .goodService : .disruption
            }
        }

        var supportsAnimation: Bool {
            switch accessoryImageType {
            case .goodService:
                return false
            case .disruption:
                return true
            }
        }
    }


    @ViewBuilder public var body: some View {
        if dynamicTypeSize.isAccessibilitySize {
            HStack(spacing: 8) {
                VStack(spacing: 0) {
                    leadingColumn()
                    trailingColumn()
                }
                accessoryImage
            }
        } else {
            EqualColumnsWithAccessoryLayout(columnCount: 2) {
                leadingColumn()
                trailingColumn()
                accessoryImage
            }
        }
    }


    // MARK: Leading column

    @ViewBuilder private func leadingColumn() -> some View {
        switch style {
        case .singleLine(let line, let isFavourite):
            singleLineLeadingColumn(line: line, isFavourite: isFavourite)
        case .multiLine(let lines):
            multilineLeadingColumn(with: lines)
        }
    }

    private func singleLineLeadingColumn(line: Line, isFavourite: Bool) -> some View {
        HStack(spacing: 4) {
            if isFavourite {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(
                        width: 10 * dynamicScaleFactor,
                        height: 10 * dynamicScaleFactor
                    )
            }
            Text(line.id.name)
            Spacer()
        }
        .statusColumnStyle(textColor: line.id.textColor)
        .padding(.leading, leadingColumnInset)
        .background { line.id.backgroundColor }
    }

    private func multilineLeadingColumn(with lines: [Line]) -> some View {
        LineColourKeyView(lineIDs: lines.prefix(12).map(\.id))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(idealHeight: 72)
    }


    // MARK: Trailing column

    @ViewBuilder private func trailingColumn() -> some View {
        switch style {
        case .singleLine(let line, _):
            singleLineTrailingColumn(line: line)
        case .multiLine(let lines):
            multilineTrailingColumn(with: lines)
        }
    }

    private func singleLineTrailingColumn(line: Line) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(line.truncatedStatusText)
                .foregroundStyle(line.isDisrupted ? .adaptiveRed : .primary)

            if historyIndicator != nil {
                HStack(spacing: 4) {
                    Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                        .foregroundStyle(.orange)
                    Text(.lineStatusHistoryDisruptionEarlierToday)
                        .foregroundStyle(Color.secondary)
                }
                .font(.caption2.weight(.medium))
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .font(.body)
        .multilineTextAlignment(.leading)
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }

    private func multilineTrailingColumn(with lines: [Line]) -> some View {
        Group {
            if lines.count == TrainLineID.allCases.count {
                Text(.lineStatusPlannedGoodServiceAllLinesTitle)
            } else {
                Text(.lineStatusPlannedGoodServiceOtherLinesTitle)
            }
        }
        .statusColumnStyle(textColor: .primary)
    }

    // MARK: - Accessory image

    @ViewBuilder private var accessoryImage: some View {
        if showsAccessory {
            HStack(spacing: 0) {
                style
                    .accessoryImageType
                    .image
                    .dynamicTypeSize(...DynamicTypeSize.accessibility3)
                    .bounceOnceSymbol(
                        isEnabled: animatedAccessoryImage && style.supportsAnimation
                    )
                Spacer(minLength: 12)
            }
            .frame(width: dynamicTypeSize.isAccessibilitySize ? 44 : nil)
        }
    }

}


private extension View {

    @ViewBuilder func statusColumnStyle(
        textColor: Color? = nil,
        isBold: Bool = false
    ) -> some View {
        Group {
            if let textColor {
                font(.body)
                    .padding(8)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(textColor)
                    .bold(isBold)
            } else {
                self
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .leading
        )
    }

}


// MARK: - Previews

import ModelStubs

#Preview {
    List {
        Group {
            Section("Single line - good service") {
                LineStatusCell(
                    style: .singleLine(ModelStubs.lineStatusGoodService, isFavourite: false),
                    showsAccessory: true
                )
            }
            Section("Single line - good service (favourite)") {
                LineStatusCell(
                    style: .singleLine(ModelStubs.lineStatusGoodService, isFavourite: true),
                    showsAccessory: true
                )
            }
            Section("Single line - disruption earlier") {
                LineStatusCell(
                    style: .singleLine(ModelStubs.lineStatusGoodService, isFavourite: false),
                    showsAccessory: true,
                    historyIndicator: .disruptionEarlierToday
                )
            }
            Section("Single line - disrupted") {
                LineStatusCell(
                    style: .singleLine(ModelStubs.lineStatusDisrupted, isFavourite: false),
                    showsAccessory: true
                )
            }
            Section("Multline") {
                LineStatusCell(
                    style: .multiLine(ModelStubs.lineStatusesFuture.filter { !$0.isDisrupted }),
                    showsAccessory: true
                )
            }
        }
        .listRowInsets(.zero)
    }
    .listStyle(.plain)
}
