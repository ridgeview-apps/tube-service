import Models
import SwiftUI

public struct RecentJourneyItem: Hashable, Identifiable {
    public let id: UUID
    public var fromLocation: JourneyLocationPicker.Value
    public var toLocation: JourneyLocationPicker.Value
    public let viaLocation: JourneyLocationPicker.Value?
    public var lastUsed: Date
    
    public init(id: UUID,
                fromLocation: JourneyLocationPicker.Value,
                toLocation: JourneyLocationPicker.Value,
                viaLocation: JourneyLocationPicker.Value?,
                lastUsed: Date) {
        self.id = id
        self.fromLocation = fromLocation
        self.toLocation = toLocation
        self.viaLocation = viaLocation
        self.lastUsed = lastUsed
    }
}

struct RecentJourneyCell: View {
    
    @Binding var item: RecentJourneyItem
    let animationNamespace: Namespace.ID
    let onAction: () -> Void
    
    @State private var isSwapped = false
        
    var body: some View {
        HStack(spacing: 0) {
            SwapValuesButton(isSwapped: $isSwapped,
                             valueA: $item.fromLocation,
                             valueB: $item.toLocation)
                .imageScale(.small)
                .foregroundStyle(Color.accentColor)
                .padding()
            Button {
                withAnimation {
                    onAction()
                }
            } label: {
                buttonLabel
            }
        }
        .cardStyle(cornerRadius: 8)
    }
    
    var buttonLabel: some View {
        HStack {
            VStack(alignment: .leading) {
                journeyFromToLocation
                journeyViaLocation
            }
            .lineLimit(1)
            Spacer()
            Image(systemName: "chevron.right")
                .imageScale(.small)
                .foregroundStyle(Color.accentColor)
        }
        .contentShape(Rectangle())
        .padding(.vertical)
        .padding(.trailing)
    }
    
    private var journeyFromToLocation: some View {
        VStack(alignment: .leading) {
            Text(item.fromLocation.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .swapValuesGeometryEffectID(.firstPairItem("\(item.id)"), isSwapped: isSwapped, in: animationNamespace)
            Text(.recentJourneyCellTo)
                .font(.caption)
            Text(item.toLocation.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .swapValuesGeometryEffectID(.secondPairItem("\(item.id)"), isSwapped: isSwapped, in: animationNamespace)
        }
        .font(.subheadline)
        .foregroundStyle(.primary)
    }
    
    @ViewBuilder
    private var journeyViaLocation: some View {
        if let viaLocation = item.viaLocation {
            HStack {
                Text(.recentJourneyCellVia(viaLocation.name))
                Spacer()
            }
            .font(.caption)
        }
    }
}


// MARK: - Previews

import ModelStubs

private struct Previewer: View {
    
    @State var recentJourneyItems: [RecentJourneyItem]
    @Namespace private var animationNamespace
    var onAction: () -> Void = { print("Button tapped") }
    
    var body: some View {
        List {
            ForEach($recentJourneyItems) { $recentJourneyItem in
                RecentJourneyCell(
                    item: $recentJourneyItem,
                    animationNamespace: animationNamespace,
                    onAction: onAction
                )
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    Previewer(
        recentJourneyItems: [
            .init(id: UUID(),
                  fromLocation: .station(ModelStubs.eastFinchleyStation),
                  toLocation: .station(ModelStubs.kingsCrossStation),
                  viaLocation: nil,
                  lastUsed: .distantPast),
            .init(id: UUID(),
                  fromLocation: .station(ModelStubs.angelStation),
                  toLocation: .station(ModelStubs.eastFinchleyStation),
                  viaLocation: .station(ModelStubs.kingsCrossStation),
                  lastUsed: .distantPast)
        ]
    )
}
