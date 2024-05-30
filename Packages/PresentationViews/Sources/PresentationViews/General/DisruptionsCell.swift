import Foundation
import SwiftUI

struct DisruptionsCell: View {
    let disruptionMessages: [String]
    
    @State var isExpanded = false
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            ForEach(disruptionMessages, id: \.self) { message in
                HStack {
                    Text(message)
                    Spacer()
                }
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
            }
        } label: {
            HStack {
                LineStatusAccessoryImageType.disruption.image
                Text(.disruptionsCellDefaultTitle)
                Spacer()
            }
        }
        .foregroundStyle(Color.adaptiveRed)
    }
}

// swiftlint:disable line_length
#Preview {
    List {
        DisruptionsCell(
            disruptionMessages: [
                "Bakerloo Line: Minor delays due to train cancellations.",
                "Kings Cross St Pancras Station: Mini ramps are available at this station on the Circle, Hammersmith & City, Metropolitan, Northern and Victoria line platforms. They are designed to cover the small remaining step / or gap between the platform and the train on step-free to train platforms. They make it easier for customers people to get on and off the train, in particular for people whose mobility aids have small or swivel wheels. The ramps are quick and easy to use. Staff are trained to use them and will be happy to provide one for you to use. If you would like to use a mini ramp, please ask for help from staff or press the information button on a help point."
            ]
        )
    }
    
}
// swiftlint:enable line_length
