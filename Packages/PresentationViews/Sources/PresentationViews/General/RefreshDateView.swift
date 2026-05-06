import SwiftUI

public struct RefreshTimestampView: View {
    
    public enum TextStyle {
        case dateOnly
        case lastUpdated
    }
    
    public let date: Date
    public let textStyle: TextStyle

    private let timestampFormatter: DateFormatter

    private var formattedDate: String {
        timestampFormatter.string(from: date)
    }

    public init(
        date: Date,
        textStyle: TextStyle = .lastUpdated,
    ) {
        self.date = date
        self.textStyle = textStyle
        
        let formatterContext: Formatter.Context
        switch textStyle {
        case .dateOnly:
            formatterContext = .beginningOfSentence
        case .lastUpdated:
            formatterContext = .middleOfSentence
        }
        
        self.timestampFormatter = Formatter.relative(
            dateStyle: .short,
            timeStyle: .short,
            context: formatterContext
        )
    }
    
    public var body: some View {
        Label {
            timestampText
        } icon: {
            Image(systemName: "clock")
        }
    }
    
    private var timestampText: some View {
        switch textStyle {
        case .dateOnly:
            Text(formattedDate)
        case .lastUpdated:
            Text(.refreshStatusLastUpdated(formattedDate))
        }
    }
}

#Preview {
    let oneDay: TimeInterval = 60.0 * 60.0 * 24.0
    VStack {
        RefreshTimestampView(date: .now, textStyle: .dateOnly)
        RefreshTimestampView(date: .now)
        RefreshTimestampView(date: .now.addingTimeInterval(-oneDay))
        RefreshTimestampView(date: .now.addingTimeInterval(-2 * oneDay))
        RefreshTimestampView(date: .now.addingTimeInterval(-7 * oneDay))
    }
}
