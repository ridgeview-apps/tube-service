import Model
import SwiftUI

struct LineColourKeyView: View {
    
    let lines: [TrainLine]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(lines, id: \.self) { line in
                line.backgroundColor
            }
        }
        .frame(width: 44, height: 44)
        .roundedBorder(.white)
    }
}
