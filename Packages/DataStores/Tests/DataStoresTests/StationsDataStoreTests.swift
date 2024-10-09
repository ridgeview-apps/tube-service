import Models
import ModelStubs
import Testing

@testable import DataStores

@MainActor
struct StationsModelTests {

    @Test
    func loadStationsByID() {
        let stationsModel = StationsDataStore(transportAPI: StubTransportAPIClient())
        
        #expect(stationsModel.station(forID: "HUBKGX") == ModelStubs.kingsCrossStation)
        #expect(stationsModel.station(forID: "HUBPAD") == ModelStubs.paddingtonStation)
        #expect(stationsModel.station(forID: "940GZZLUHBT") == ModelStubs.highBarnetStation)
    }
    
    @Test
    func loadStationsByLineGroup() {
        let stations = StationsDataStore(transportAPI: StubTransportAPIClient())
        
        // King's X
        #expect(stations.station(forLineGroupID: "940GZZLUKSX-circle,hammersmith-city,metropolitan") == ModelStubs.kingsCrossStation)
        #expect(stations.station(forLineGroupID: "940GZZLUKSX-northern") == ModelStubs.kingsCrossStation)
        #expect(stations.station(forLineGroupID: "940GZZLUKSX-piccadilly") == ModelStubs.kingsCrossStation)
        #expect(stations.station(forLineGroupID: "940GZZLUKSX-victoria") == ModelStubs.kingsCrossStation)
        
        // Paddington
        #expect(stations.station(forLineGroupID: "940GZZLUPAC-bakerloo") == ModelStubs.paddingtonStation)
        #expect(stations.station(forLineGroupID: "940GZZLUPAC-circle,district") == ModelStubs.paddingtonStation)
        #expect(stations.station(forLineGroupID: "940GZZLUPAH-circle,hammersmith-city") == ModelStubs.paddingtonStation)
        #expect(stations.station(forLineGroupID: "910GPADTON-elizabeth") == ModelStubs.paddingtonStation)
        
        // High barnet
        #expect(stations.station(forLineGroupID: "940GZZLUHBT-northern")?.name == "High Barnet")
    }
    
    @Test
    func filteredStationsByPartialName() {
        let stations = StationsDataStore(transportAPI: StubTransportAPIClient())
        
        func filteredStationsContainsKingsCross(forInputText partialName: String) -> Bool {
            stations.filteredStations(matchingName: partialName).contains(ModelStubs.kingsCrossStation)
        }
        
        #expect(filteredStationsContainsKingsCross(forInputText: "King's Cross & St Pancras International"))
        #expect(filteredStationsContainsKingsCross(forInputText: "Kings Cross St Pancras International"))
        #expect(filteredStationsContainsKingsCross(forInputText: "Kin"))
        #expect(filteredStationsContainsKingsCross(forInputText: "ternational"))
        #expect(filteredStationsContainsKingsCross(forInputText: "kings cross"))
        #expect(filteredStationsContainsKingsCross(forInputText: "kings cross st pancras"))
    }
    
}
