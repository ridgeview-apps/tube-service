import SwiftUI

struct BusStopTile: View {
    let letter: String?

    @ScaledMetric private var size: CGFloat

    init(letter: String?, size: CGFloat = 30) {
        self.letter = letter
        self._size = ScaledMetric(wrappedValue: size, relativeTo: .subheadline)
    }

    var body: some View {
        RoundedRectangle(cornerRadius: size * 0.25, style: .continuous)
            .fill(Color.bus)
            .frame(width: size, height: size)
            .overlay {
                Group {
                    if let letter {
                        Text(verbatim: letter)
                            .font(.system(size: size * (letter.count > 1 ? 0.4 : 0.55), weight: .bold))
                    } else {
                        Image(systemName: "bus.doubledecker.fill")
                            .font(.system(size: size * 0.5))
                    }
                }
                .foregroundStyle(.white)
            }
            .accessibilityHidden(true)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    HStack {
        BusStopTile(letter: "H")
        BusStopTile(letter: "HA")
        BusStopTile(letter: nil)
    }
    .padding()
}
