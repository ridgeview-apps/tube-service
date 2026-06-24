import SwiftUI

struct JourneyPlannerTimeChip: View {

    @Binding var timeSelection: JourneyTimePickerSelection

    private var isHighlighted: Bool {
        timeSelection.option != .leaveNow
    }

    var body: some View {
        Menu {
            ForEach(JourneyTimePickerSelection.Option.allCases, id: \.self) { option in
                Button {
                    withAnimation(.snappy) {
                        timeSelection.option = option
                    }
                } label: {
                    if option == timeSelection.option {
                        Label(option.title, systemImage: "checkmark")
                    } else {
                        Text(option.title)
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .imageScale(.small)
                Text(timeSelection.option.title)
                Image(systemName: "chevron.up.chevron.down")
                    .imageScale(.small)
            }
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .foregroundStyle(isHighlighted ? Color.accentColor : .secondary)
            .background(
                isHighlighted
                    ? AnyShapeStyle(Color.accentColor.opacity(0.12))
                    : AnyShapeStyle(Color(.tertiarySystemFill)),
                in: Capsule()
            )
        }
    }
}

// MARK: - Previews

#Preview("Leave now") {
    JourneyPlannerTimeChip(
        timeSelection: .constant(.leaveNow())
    )
}

#Preview("Arrive by") {
    JourneyPlannerTimeChip(
        timeSelection: .constant(.arriveBy(.now + 3600))
    )
}
