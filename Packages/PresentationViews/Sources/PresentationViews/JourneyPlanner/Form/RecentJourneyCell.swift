import Models
import SwiftUI

public struct RecentJourneyItem: Hashable, Identifiable {
    public var id: Self { self }
    public var fromLocation: JourneyLocationPicker.Value
    public var toLocation: JourneyLocationPicker.Value
    public let viaLocation: JourneyLocationPicker.Value?
    
    public init(fromLocation: JourneyLocationPicker.Value,
                toLocation: JourneyLocationPicker.Value,
                viaLocation: JourneyLocationPicker.Value?) {
        self.fromLocation = fromLocation
        self.toLocation = toLocation
        self.viaLocation = viaLocation
    }
}

struct RecentJourneyCell: View {
    
    @Binding var item: RecentJourneyItem
    let animationNamespace: Namespace.ID
    let onAction: () -> Void
    
    @State private var isSwapped = false
    
    private let swapButtonSize = CGSize(width: 44, height: 44)
    private let horizontalSpacing = 8.0
    
    var body: some View {
        Button {
            withAnimation {
                onAction()
            }
        } label: {
            buttonLabel
        }
        .foregroundStyle(.primary)
    }
    
    var buttonLabel: some View {
        HStack {
            VStack {
                journeyFromToLocation
                journeyViaLocation
            }
            .lineLimit(1)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
    }
    
    private var journeyFromToLocation: some View {
        HStack(spacing: horizontalSpacing) {
            
            SwapValuesButton(isSwapped: $isSwapped,
                             valueA: $item.fromLocation,
                             valueB: $item.toLocation,
                             namespace: animationNamespace)
            .foregroundStyle(Color.accentColor)
            .frame(width: swapButtonSize.width,
                   height: swapButtonSize.height)
            
            VStack(alignment: .leading) {
                Text(item.fromLocation.localizedTitle)
                    .swapValuesGeometryEffectID(.firstPairItem(item.id), isSwapped: isSwapped, in: animationNamespace)
                Text("recent.journey.cell.to", bundle: .module)
                    .font(.caption)
                Text(item.toLocation.localizedTitle)
                    .swapValuesGeometryEffectID(.secondPairItem(item.id), isSwapped: isSwapped, in: animationNamespace)
            }
            .font(.subheadline)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private var journeyViaLocation: some View {
        if let viaLocation = item.viaLocation {
            HStack {
                Text("recent.journey.cell.via \(viaLocation.localizedTitle)", bundle: .module)
                Spacer()
            }
            .font(.caption)
            .padding(.leading, swapButtonSize.width + horizontalSpacing)
        }
    }
}
