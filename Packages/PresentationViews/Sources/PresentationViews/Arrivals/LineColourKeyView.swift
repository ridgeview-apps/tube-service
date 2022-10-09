import Models
import SwiftUI
 
public struct LineColourKeyView: View {

    public let lineIDs: [LineID]
    public let height: CGFloat
    public let width: CGFloat
    
    public init(lineIDs: [LineID],
                height: CGFloat = 40,
                width: CGFloat = 40) {
        self.lineIDs = lineIDs
        self.height = height
        self.width = width
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
        .frame(width: width, height: height)
        .roundedBorder(.white)
    }
}


// MARK: - Previews

struct LineColourKeyView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LineColourKeyView(lineIDs: [.bakerloo, .circle, .central, .district, .dlr])
        }
    }
}
