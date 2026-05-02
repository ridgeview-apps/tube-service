import Models
import SwiftUI

public struct LineStatusCell: View {
    
    public let style: Style
    public let showsAccessory: Bool
    public var leadingColumnInset = 4.0
    public var animatedAccessoryImage: Bool = false
    
    @ScaledMetric private var dynamicScaleFactor: CGFloat = 1
    
    public enum Style: Hashable {
        case singleLine(Line)
        case multiLine([Line])
        
        var accessoryImageType: LineStatusAccessoryImageType {
            switch self {
            case .singleLine(let line):
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
    
    
    public var body: some View {
        HStack(spacing: 0) {
            leadingColumn()
            trailingColumn()
            accessoryImage
        }
    }
    
    
    // MARK: Leading column
    
    @ViewBuilder private func leadingColumn() -> some View {
        switch style {
        case .singleLine(let line):
            singleLineLeadingColumn(line: line)
        case .multiLine(let lines):
            multilineLeadingColumn(with: lines)
        }
    }
    
    private func singleLineLeadingColumn(line: Line) -> some View {
        HStack(spacing: 4) {
            Text(line.id.name)
            Spacer()
        }
        .toEqualWidthColumn(textColor: line.id.textColor)
        .padding(.leading, leadingColumnInset)
        .background(line.id.backgroundColor)
    }
    
    private func multilineLeadingColumn(with lines: [Line]) -> some View {
        LineColourKeyView(lineIDs: lines.map(\.id))
            .toEqualWidthColumn()
    }

    
    // MARK: Trailing column
    
    @ViewBuilder private func trailingColumn() -> some View {
        switch style {
        case .singleLine(let line):
            singleLineTrailingColumn(line: line)
        case .multiLine(let lines):
            multilineTrailingColumn(with: lines)
        }
    }
    
    private func singleLineTrailingColumn(line: Line) -> some View {
        Text(line.shortText)
            .toEqualWidthColumn(
                textColor: line.isDisrupted ? .adaptiveRed : .primary
            )
    }
    
    private func multilineTrailingColumn(with lines: [Line]) -> some View {
        Group {
            if lines.count == allLineIDs.count {
                Text(.lineStatusPlannedGoodServiceAllLinesTitle)
            } else {
                Text(.lineStatusPlannedGoodServiceOtherLinesTitle)
            }
        }
        .toEqualWidthColumn(textColor: .primary)
    }
    
    private var allLineIDs: [TrainLineID] {
        TrainLineID.allCases.filter { $0 != .overground }
    }
    
    
    // MARK: - Accessory image
        
    @ViewBuilder private var accessoryImage: some View {
        if showsAccessory {
            style
                .accessoryImageType
                .image
                .padding(.trailing)
                .frame(width: 30)
                .bounceOnceSymbol(
                    isEnabled: animatedAccessoryImage && style.supportsAnimation
                )
        }

    }

}


private extension View {

    @ViewBuilder func toEqualWidthColumn(textColor: Color? = nil,
                                         isBold: Bool = false) -> some View {
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
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .leading)
    }
    
}


// MARK: - Previews

import ModelStubs

#Preview {
    List {
        Group {
            Section("Single line - good service") {
                LineStatusCell(style: .singleLine(ModelStubs.lineStatusGoodService),
                               showsAccessory: true)
            }
            Section("Single line - disrupted") {
                LineStatusCell(style: .singleLine(ModelStubs.lineStatusDisrupted),
                               showsAccessory: true)
            }
            Section("Multline") {
                LineStatusCell(style: .multiLine(ModelStubs.lineStatusesFuture.filter { !$0.isDisrupted }),
                               showsAccessory: true)
            }
        }
        .listRowInsets(.zero)
    }
}
