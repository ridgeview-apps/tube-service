import Models
import Testing

@testable import PresentationViews

struct LineIDViewStateTests {

    @Test
    func lineIDShortNames() {
        #expect(TrainLineID.bakerloo.name == "Bakerloo")
        #expect(TrainLineID.central.name == "Central")
        #expect(TrainLineID.circle.name == "Circle")
        #expect(TrainLineID.district.name == "District")
        #expect(TrainLineID.elizabeth.name == "Elizabeth")
        #expect(TrainLineID.hammersmithAndCity.name == "Hammersmith & City")
        #expect(TrainLineID.jubilee.name == "Jubilee")
        #expect(TrainLineID.metropolitan.name == "Metropolitan")
        #expect(TrainLineID.northern.name == "Northern")
        #expect(TrainLineID.piccadilly.name == "Piccadilly")
        #expect(TrainLineID.victoria.name == "Victoria")
        #expect(TrainLineID.waterlooAndCity.name == "Waterloo & City")
        #expect(TrainLineID.dlr.name == "DLR")
        #expect(TrainLineID.overground.name == "Overground")
        #expect(TrainLineID.tram.name == "Tram")
    }
    
    @Test
    func lineIDLongNames() {
        #expect(TrainLineID.bakerloo.longName == "Bakerloo line")
        #expect(TrainLineID.central.longName == "Central line")
        #expect(TrainLineID.circle.longName == "Circle line")
        #expect(TrainLineID.district.longName == "District line")
        #expect(TrainLineID.elizabeth.longName == "Elizabeth line")
        #expect(TrainLineID.hammersmithAndCity.longName == "Hammersmith & City line")
        #expect(TrainLineID.jubilee.longName == "Jubilee line")
        #expect(TrainLineID.metropolitan.longName == "Metropolitan line")
        #expect(TrainLineID.northern.longName == "Northern line")
        #expect(TrainLineID.piccadilly.longName == "Piccadilly line")
        #expect(TrainLineID.victoria.longName == "Victoria line")
        #expect(TrainLineID.waterlooAndCity.longName == "Waterloo & City line")
        #expect(TrainLineID.dlr.longName == "DLR")
        #expect(TrainLineID.overground.longName == "Overground")
        #expect(TrainLineID.tram.longName == "Tram")
    }
}
