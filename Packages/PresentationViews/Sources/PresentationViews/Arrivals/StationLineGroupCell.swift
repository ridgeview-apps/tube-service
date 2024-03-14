import Models
import SwiftUI

struct StationLineGroupCell: View {
    
    private(set) var style: LineGroupCell.Style = .plain
    let station: Station    
    
    var body: some View {
        LineGroupCell(style: style,
                      lineIDs: station.sortedLineIDs, 
                      title: station.name)
    }
}

#Preview {
    List {
        StationLineGroupCell(station: ModelStubs.kingsCrossStation)
        StationLineGroupCell(station: ModelStubs.eastFinchleyStation)
    }
}
