import Foundation

/// Strips the suffixes TfL adds to station names, e.g. "Abbey Wood Rail Station" → "Abbey Wood".
public enum StationNameCleaner {

    private static let removedPhrases = [
        "(Rail Station)",
        "Underground Station",
        "DLR Station",
        "Tram Stop",
        "Rail Station"
    ]

    private static let stationSuffix = " Station"

    // Names where "Station" is part of the place name rather than a suffix TfL added.
    private static let namesEndingInStation: Set<String> = [
        "Battersea Power Station"
    ]

    public static func clean(_ name: String) -> String {
        var cleanedName = removedPhrases.reduce(name) { name, phrase in
            name.replacingOccurrences(of: phrase, with: "")
        }
        .trimmingCharacters(in: .whitespaces)

        if cleanedName.hasSuffix(stationSuffix), !namesEndingInStation.contains(cleanedName) {
            cleanedName = String(cleanedName.dropLast(stationSuffix.count))
        }

        return cleanedName
    }
}
