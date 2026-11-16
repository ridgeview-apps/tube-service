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
            stationID: "HUBHHY",
            reason: "Highbury's departures don't say which line each train is on, so a combined Mildmay and Windrush group can't be split"
        ) {
            $0.lineIds.contains("mildmay") && $0.lineIds.contains("windrush")
        }
    ]
}
