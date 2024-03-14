import SwiftUI

struct JourneyPlannerSwapButton: View {
    let action: () -> Void

    var body: some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
    }
}

#Preview {
    JourneyPlannerSwapButton(action: {})
}
