import Models
import SwiftUI

public struct LineStatusCell: View {
    
    public let style: Style
    public let showsAccessory: Bool
    public var leadingColumnInset = 4.0
    
    public enum Style: Hashable {
        case singleLine(Line, showFavouriteImage: Bool)
        case multiLine([Line])
        
        var accessoryImageType: LineStatusAccessoryImageType {
            switch self {
            case .singleLine(let line, _):
                return line.isDisrupted ? .disruption : .goodService
            case .multiLine(let lines):
                return lines.allAreGoodService ? .goodService : .disruption
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
        case .singleLine(let line, let showFavouriteImage):
            singleLineLeadingColumn(line: line, showFavouriteImage: showFavouriteImage)
        case .multiLine(let lines):
            multilineLeadingColumn(with: lines)
        }
    }
    
    private func singleLineLeadingColumn(line: Line, showFavouriteImage: Bool) -> some View {
        HStack(spacing: 4) {
            if showFavouriteImage {
                Image(systemName: "star.fill")
                    .imageScale(.small)
                    .foregroundStyle(.white)
            }
            Text(line.id.name)
            Spacer()
        }
        .toEqualWidthColumn(textColor: line.id.textColor)
        .shadow(color: line.id.textShadow.color,
                radius: line.id.textShadow.radius,
                x: line.id.textShadow.x,
                y: line.id.textShadow.y)
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
        case .singleLine(let line, _):
            singleLineTrailingColumn(line: line)
        case .multiLine(let lines):
            multilineTrailingColumn(with: lines)
        }
    }
    
    private func singleLineTrailingColumn(line: Line) -> some View {
        Text(line.shortText)
            .toEqualWidthColumn(textColor: line.isDisrupted ? .adaptiveRed : .primary)
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
        }
    }

}


extension View {

    @ViewBuilder func toEqualWidthColumn(textColor: Color? = nil) -> some View {
        Group {
            if let textColor {
                font(.body)
                    .padding(8)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(textColor)
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
                LineStatusCell(style: .singleLine(ModelStubs.lineStatusGoodService,
                                                  showFavouriteImage: false),
                               showsAccessory: true)
            }
            Section("Single line - favourite") {
                LineStatusCell(style: .singleLine(ModelStubs.lineStatusGoodService,
                                                  showFavouriteImage: true),
                               showsAccessory: true)
            }
            Section("Single line - disrupted") {
                LineStatusCell(style: .singleLine(ModelStubs.lineStatusDisrupted,
                                                  showFavouriteImage: true),
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
