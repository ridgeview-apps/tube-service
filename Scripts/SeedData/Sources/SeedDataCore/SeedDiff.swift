/// An entry that can be compared between the current file and a regenerated one.
public protocol SeedEntry: Equatable {
    /// The ID saved user data refers to the entry by, so a removed ID is a broken reference.
    var diffID: String { get }
    var diffName: String { get }
    /// How removing an entry affects saved user data, shown on the summary's removed list.
    static var removalImpact: String { get }
    /// Readable descriptions of the fields that differ, e.g. `name: "Old" → "New"`.
    func changedFields(from old: Self) -> [String]
}

public struct SeedDiff<Entry: SeedEntry> {

    public struct Change {
        public let old: Entry
        public let new: Entry
    }

    public let oldCount: Int
    public let newCount: Int
    public let added: [Entry]
    public let removed: [Entry]
    public let changed: [Change]

    public var isEmpty: Bool { added.isEmpty && removed.isEmpty && changed.isEmpty }

    /// A missing current file (`old == nil`) counts every new entry as added.
    public init(old: [Entry]?, new: [Entry]) {
        let old = old ?? []
        // Validation reports duplicate IDs; here the first one stands for all of them.
        let oldByID = Dictionary(old.map { ($0.diffID, $0) }, uniquingKeysWith: { first, _ in first })
        let newIDs = Set(new.map(\.diffID))

        oldCount = old.count
        newCount = new.count
        added = new.filter { oldByID[$0.diffID] == nil }.sorted(by: Self.isOrderedBefore)
        removed = old.filter { !newIDs.contains($0.diffID) }.sorted(by: Self.isOrderedBefore)
        changed = new.compactMap { entry in
            guard let oldEntry = oldByID[entry.diffID], oldEntry != entry else { return nil }
            return Change(old: oldEntry, new: entry)
        }
        .sorted { Self.isOrderedBefore($0.new, $1.new) }
    }

    private static func isOrderedBefore(_ lhs: Entry, _ rhs: Entry) -> Bool {
        (lhs.diffName, lhs.diffID) < (rhs.diffName, rhs.diffID)
    }
}

public extension SeedDiff {

    /// Keeps a PR description well under GitHub's 65,536-character limit, even when TfL changes every entry.
    static var maximumListedEntries: Int { 50 }

    /// One Markdown section for the file: counts, then removed, changed and added entries, then any issues.
    func markdown(file: String, issues: [SeedIssue]) -> String {
        var lines = ["## \(file)", ""]

        if isEmpty {
            lines.append("No changes.")
        } else {
            lines.append("\(oldCount) → \(newCount) entries: \(added.count) added, \(removed.count) removed, \(changed.count) changed.")
        }

        lines += Self.list("Removed (\(Entry.removalImpact))", removed.map(Self.describe))
        lines += Self.list("Changed", changed.map { "\(Self.describe($0.new)): \($0.new.changedFields(from: $0.old).joined(separator: "; "))" })
        lines += Self.list("Added", added.map(Self.describe))
        lines += Self.list("Issues", issues.map(\.description))

        return lines.joined(separator: "\n") + "\n"
    }

    private static func describe(_ entry: Entry) -> String {
        "\(entry.diffName) (`\(entry.diffID)`)"
    }

    private static func list(_ title: String, _ items: [String]) -> [String] {
        guard !items.isEmpty else { return [] }

        var lines = ["", "### \(title)", ""]
        lines += items.prefix(maximumListedEntries).map { "- \($0)" }
        if items.count > maximumListedEntries {
            lines.append("- …and \(items.count - maximumListedEntries) more")
        }
        return lines
    }
}

extension LondonStation: SeedEntry {

    public var diffID: String { id }
    public var diffName: String { name }
    // Both FavouriteStop.station(id:) and SavedJourney.LocationType.station(id:) store the station ID.
    public static var removalImpact: String { "affects saved favourites and journeys" }

    public func changedFields(from old: LondonStation) -> [String] {
        var fields: [String] = []
        if name != old.name {
            fields.append("name: \"\(old.name)\" → \"\(name)\"")
        }
        if icsCode != old.icsCode {
            fields.append("icsCode: \(old.icsCode) → \(icsCode)")
        }
        if lineGroups != old.lineGroups {
            let removedGroups = old.lineGroups.filter { !lineGroups.contains($0) }.map { "−\(Self.describe($0))" }
            let addedGroups = lineGroups.filter { !old.lineGroups.contains($0) }.map { "+\(Self.describe($0))" }
            let groupChanges = removedGroups + addedGroups
            fields.append(groupChanges.isEmpty ? "line groups reordered" : "line groups: \(groupChanges.joined(separator: ", "))")
        }
        if location != old.location {
            fields.append("location")
        }
        return fields
    }

    private static func describe(_ lineGroup: LineGroup) -> String {
        "\(lineGroup.atcoCode) (\(lineGroup.lineIds.joined(separator: ", ")))"
    }
}

extension NationalRailStopPoint: SeedEntry {

    // Keyed by ICS code rather than naptanId, because SavedJourney.LocationType.nationalRail(icsCode:) stores it.
    public var diffID: String { icsCode }
    public var diffName: String { commonName }
    public static var removalImpact: String { "affects saved journeys" }

    public func changedFields(from old: NationalRailStopPoint) -> [String] {
        var fields: [String] = []
        if commonName != old.commonName {
            fields.append("name: \"\(old.commonName)\" → \"\(commonName)\"")
        }
        if naptanId != old.naptanId {
            fields.append("naptanId: \(old.naptanId) → \(naptanId)")
        }
        if lat != old.lat || lon != old.lon {
            fields.append("location")
        }
        return fields
    }
}
