import SwiftUI

public struct ErrorView: View {
    public let errorMessage: String
    
    public init(errorMessage: String) {
        self.errorMessage = errorMessage
    }
    
    public var body: some View {
        ZStack {
            Color.red
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(Color.white)
                    .imageScale(.large)
                Text(errorMessage)
                    .foregroundColor(.white)
            }
            .padding(8)
        }
        .cornerRadius(8)
    }
}
