import SwiftUI

public struct LastUpatedTimeLabel: View {

    public let date: Date

    private let timestampFormatter: DateFormatter = Formatter.relative(
        dateStyle: .short,
        timeStyle: .short,
        context: .middleOfSentence
    )

    public init(date: Date) {
        self.date = date
    }

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Image(systemName: "clock")
            Text(
                .refreshStatusLastUpdated(
                    timestampFormatter.string(from: date)
                )
            )
        }
    }
}

extension View {
    func defaultLastUpdatedTimeLabelStyle(
        font: Font = .caption,
        foregroundStyle: some ShapeStyle = .secondary,
        imageScale: Image.Scale = .small
    ) -> some View {
        self
            .font(font)
            .foregroundStyle(foregroundStyle)
            .imageScale(imageScale)
    }
}

#Preview {
    let oneDay = 60.0 * 60.0 * 24.0
    VStack {
        LastUpatedTimeLabel(date: .now)
        LastUpatedTimeLabel(date: .now.addingTimeInterval(-1 * oneDay))
        LastUpatedTimeLabel(date: .now.addingTimeInterval(-2 * oneDay))
        LastUpatedTimeLabel(date: .now.addingTimeInterval(-7 * oneDay))
    }
    .defaultLastUpdatedTimeLabelStyle()
}
