import Model
import ModelUI
import StyleGuide
import SwiftUI
 
public struct LineColourKeyView: View {

    public let lines: [TrainLine]
    public let height: CGFloat
    public let width: CGFloat
    
    public init(lines: [TrainLine],
                height: CGFloat = 40,
                width: CGFloat = 40) {
        self.lines = lines
        self.height = height
        self.width = width
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(lines, id: \.self) { line in
                line.backgroundColor
                if line != lines.last {
                    Divider()
                        .frame(height: 1)
                        .background(.white)
                }
            }
        }
        .frame(width: width, height: height)
        .roundedBorder(.white)
    }
}
