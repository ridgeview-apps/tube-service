/// A hand correction to TfL's data: line groups to remove from one station.
public struct LondonStationPatch: Sendable {
    public let stationID: String
    public let reason: String
    public let removes: @Sendable (LondonStation.LineGroup) -> Bool

    public init(stationID: String, reason: String, removes: @escaping @Sendable (LondonStation.LineGroup) -> Bool) {
        self.stationID = stationID
        self.reason = reason
        self.removes = removes
    }
}

public extension LondonStationPatch {

    static let all: [LondonStationPatch] = [
        LondonStationPatch(
            stationID: "HUBPAD",
            reason: "Paddington's Elizabeth line is already listed under 910GPADTON, so its low-level platforms would show it twice"
        ) {
            $0.lineIds == ["elizabeth"] && $0.atcoCode == "910GPADTLL"
        },
        LondonStationPatch(
            stationID: "HUBLST",
            reason: "Liverpool Street's Elizabeth line is already listed under 910GLIVST, so its low-level platforms would show it twice"
        ) {
            $0.lineIds == ["elizabeth"] && $0.atcoCode == "910GLIVSTLL"
        },
        LondonStationPatch(
            stationID: "HUBCLJ",
            reason: "Clapham Junction's Mildmay line is already listed under 910GCLPHMJC, whose departures are the same trains"
        ) {
            $0.lineIds == ["mildmay"] && $0.atcoCode == "910GCLPHMJ1"
        }
    ]
}
