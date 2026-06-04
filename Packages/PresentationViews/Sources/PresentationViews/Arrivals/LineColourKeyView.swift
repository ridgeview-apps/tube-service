import Models
import SwiftUI

public struct LineColourKeyView: View {

    public let lineIDs: [TrainLineID]

    public init(lineIDs: [TrainLineID]) {
        self.lineIDs = lineIDs
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(lineIDs, id: \.self.rawValue) { lineID in
                lineID.backgroundColor
                if lineID != lineIDs.last {
                    Divider()
                        .frame(height: 1)
                        .background(.white)
                }
            }
        }
    }
}


// MARK: - Previews

#Preview {
    VStack {
        LineColourKeyView(lineIDs: [.bakerloo, .circle, .central, .district, .dlr])
    }
}
