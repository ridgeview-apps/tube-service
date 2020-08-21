import SwiftUI

struct ErrorView: View {
    let errorMessage: String
    
    var body: some View {
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
