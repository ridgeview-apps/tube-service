/// London-only name fixes, applied after `StationNameCleaner`. National rail keeps its regional suffixes, because
/// across the whole country they tell apart stations that share a name.
public enum LondonStationNames {

    // Every station in the London list is in or near London, so these add nothing.
    static let regionalSuffixes = [" (London)", " (Berks)"]

    /// Names chosen by hand, by station ID, for stations whose TfL names look the same in search.
    public static let renames: [String: String] = [
        "940GZZLUBLG": "Bethnal Green (Central)",
        "910GBTHNLGR": "Bethnal Green (Weaver)"
    ]

    static func name(forStationID stationID: String, tfLName: String, renames: [String: String]) -> String {
        if let rename = renames[stationID] {
            return rename
        }

        let cleanedName = StationNameCleaner.clean(tfLName)
        guard let suffix = regionalSuffixes.first(where: cleanedName.hasSuffix) else { return cleanedName }
        return String(cleanedName.dropLast(suffix.count))
    }
}
