import SwiftUI

public extension View {

    func withDefaultMaxWidth(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: 700, alignment: alignment)
    }

    func topSafeAreaTint(_ color: Color) -> some View {
        background(alignment: .top) {
            GeometryReader { proxy in
                color
                    .frame(height: proxy.safeAreaInsets.top)
                    .offset(y: -proxy.safeAreaInsets.top)
            }
        }
    }

    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear.preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

public extension EdgeInsets {
    static let zero = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
}

private struct SizePreferenceKey: PreferenceKey {
    static let defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct HLine: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        }
    }
}

struct VLine: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
    }
}
