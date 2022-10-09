import SwiftUI

public struct ErrorView: View {
    public let errorMessage: String
    
    public init(errorMessage: String) {
        self.errorMessage = errorMessage
    }
    
    public var body: some View {
        ZStack {
            Color.red
            HStack {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(Color.white)
                    .imageScale(.large)
                Text(errorMessage)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(8)
        }
        .cornerRadius(8)
    }
}


// MARK: - Previews

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(errorMessage: "Oops something went wrong")
    }
}
