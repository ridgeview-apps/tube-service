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
                width: CGFloat = 16) {
        self.lines = lines
        self.height = height
        self.width = width
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(lines, id: \.self) { line in
                line.backgroundColor
            }
        }
        .frame(width: width, height: height)
        .clipShape(Capsule())
    }
}


public struct LineColourKeyView2: View {

    public let lines: [TrainLine]
    
    public init(lines: [TrainLine]) {
        self.lines = lines
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(lines, id: \.self) { line in
                line.backgroundColor
            }
        }
//        .frame(width: width, height: height)
        .roundedBorder(.white)
    }
}
