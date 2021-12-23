import XCTest
import Combine
import CombineSchedulers
import Model
@testable import DataClients

final class StationsClientTests: XCTestCase {
    
    private var cancelBag = Set<AnyCancellable>()
    
    func testLoadStationData() throws {
        var loadedStations = [Station]()
        
        // Given
        let stationsClient = StationsClient.real
        
        // When
        stationsClient
                .load()
                .receive(on: DispatchQueue.immediate)
                .sink { loadedStations = $0 }
                .store(in: &cancelBag)
        
        // Then
        XCTAssertEqual(loadedStations.count, 348)
    }
}
