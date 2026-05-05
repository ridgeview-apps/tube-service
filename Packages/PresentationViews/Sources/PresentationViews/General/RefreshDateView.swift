import SwiftUI

public struct RefreshTimestampView: View {
    
    public let date: Date

    private let timestampFormatter: DateFormatter = Formatter.relative(
        dateStyle: .short,
        timeStyle: .short
    )

    private var formattedDate: String {
        timestampFormatter.string(from: date)
    }

    public init(
        _ date: Date
    ) {
        self.date = date
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "clock")
            Text(formattedDate)
        }
    }
}

#Preview {
    let oneDay: TimeInterval = 60.0 * 60.0 * 24.0
    VStack {
        RefreshTimestampView(.now)
        RefreshTimestampView(.now.addingTimeInterval(-oneDay))
        RefreshTimestampView(.now.addingTimeInterval(-2 * oneDay))
        RefreshTimestampView(.now.addingTimeInterval(-7 * oneDay))
    }
}
