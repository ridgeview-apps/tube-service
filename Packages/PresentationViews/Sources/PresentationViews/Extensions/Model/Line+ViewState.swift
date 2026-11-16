import Foundation
import Models


// MARK: - Data sorting

public extension Sequence where Element == Line {
    func sortedByStatusSeverity() -> [Line] {
        sorted { $0.sortProperties < $1.sortProperties }
    }

    var hasDisruptions: Bool {
        !disruptionsOnly().isEmpty
    }

    var allAreDisrupted: Bool {
        allSatisfy { $0.isDisrupted }
    }

    var allAreGoodService: Bool {
        allSatisfy { $0.statusSeverity == .goodService }
    }

    func disruptionsOnly() -> [Line] {
        self.filter { $0.isDisrupted }.sortedByStatusSeverity()
    }

    func goodServiceOnly() -> [Line] {
        self.filter { !$0.isDisrupted }.sorted { $0.id.name < $1.id.name }
    }

    func removingLineIDs(_ excludedLineIDs: [TrainLineID]) -> [Line] {
        self.filter { !excludedLineIDs.contains($0.id) }
    }

    /// Returns the favourite lines in the user's chosen order (not by status severity).
    func favouritesOnly(matching favouriteLineIDs: [TrainLineID]) -> [Line] {
        let linesByID = Dictionary(map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        return favouriteLineIDs.compactMap { linesByID[$0] }
    }
}

/// Lines that share a status, which the Station screen shows as one row.
struct LineStatusGroup: Identifiable {
    let statusText: String
    let isDisrupted: Bool
    fileprivate(set) var lines: [Line]

    var id: String { statusText }
}

extension Sequence where Element == Line {
    /// Grouped by the status they show, in the Line Status tab's order: disrupted first, good service last.
    func groupedByStatus() -> [LineStatusGroup] {
        var groups: [LineStatusGroup] = []
        for line in sortedByStatusSeverity() {
            if let index = groups.firstIndex(where: { $0.statusText == line.shortStatusText }) {
                groups[index].lines.append(line)
            } else {
                groups.append(.init(statusText: line.shortStatusText, isDisrupted: line.isDisrupted, lines: [line]))
            }
        }
        return groups
    }
}

extension Sequence where Element == Line {
    /// A sentence saying which lines aren't running normally, e.g. "Minor delays on the Circle line", or nil when they
    /// all are.
    var disruptionSummary: String? {
        let disruptedLines = disruptionsOnly()
        guard let firstLine = disruptedLines.first else { return nil }
        let lineIDs = disruptedLines.map(\.id)
        let lineNames = lineIDs.namesInSentence
        // "Suspended on the Circle line" reads badly, so lines that are out of service say so as a sentence of their
        // own. The most severe status leads, e.g. part suspended with severe delays.
        let mostSevereStatuses = Set(disruptedLines.map(\.statusSeverity))
        if mostSevereStatuses.count == 1, let outOfServiceText = firstLine.statusSeverity?.outOfServiceText {
            let sentence: LocalizedStringResource =
                lineIDs.count == 1
                ? .lineDisruptionSummaryOutOfServiceOne(lineNames, outOfServiceText)
                : .lineDisruptionSummaryOutOfServiceMany(lineNames, outOfServiceText)
            return String(localized: sentence).capitalizingFirstLetter
        }
        guard disruptedLines.groupedByStatus().count == 1 else {
            return String(localized: .lineDisruptionSummaryMixed(lineNames))
        }
        return String(localized: .lineDisruptionSummary(firstLine.statusInSentence, lineNames))
    }
}

private extension LineStatusSeverity {
    /// What follows "the Circle line is", for the statuses that mean no trains (or only some) are running.
    var outOfServiceText: String? {
        switch self {
        case .suspended: String(localized: .lineDisruptionOutOfServiceSuspended)
        case .partSuspended: String(localized: .lineDisruptionOutOfServicePartSuspended)
        case .notRunning: String(localized: .lineDisruptionOutOfServiceNotRunning)
        case .closed, .serviceClosed: String(localized: .lineDisruptionOutOfServiceClosed)
        default: nil
        }
    }
}

private extension String {
    var capitalizingFirstLetter: String {
        prefix(1).uppercased() + dropFirst()
    }
}

private extension Array where Element == TrainLineID {
    var namesInSentence: String {
        if let lineID = first, count == 1 {
            return lineID.nameInSentence
        }
        // DLR and London Trams aren't "lines", so they can't share one "the … lines" phrase
        let areAllNamedLines = allSatisfy { $0 != .dlr && $0 != .tram }
        guard areAllNamedLines else {
            return map(\.nameInSentence).formatted(.list(type: .and).locale(.copy))
        }
        let shortNames = map { $0.abbreviatedName(besideOtherLines: true) }.formatted(.list(type: .and).locale(.copy))
        return String(localized: .lineNamesInSentence(shortNames))
    }
}

private extension Line {
    /// The statuses joined as a sentence opening, e.g. "Part closure and minor delays".
    var statusInSentence: String {
        mergedLineStatuses
            .flatMap(\.severityDescriptions)
            .removingDuplicates()
            .enumerated()
            .map { index, description in index == 0 ? description : description.lowercased() }
            .formatted(.list(type: .and).locale(.copy))
    }
}

public extension Line {

    typealias SortProperties = (
        disruptionSortOrder: Int,
        lineName: String
    )

    var statusSeverity: LineStatusSeverity? {
        lineStatusesSortedBySeverity
            .compactMap(\.statusSeverity).first
    }

    var lineStatusesSortedBySeverity: [LineStatus] {
        (lineStatuses ?? []).sortedByStatusSeverity()
    }

    var sortProperties: SortProperties {
        (
            isDisrupted ? 0 : 1,
            lineName: id.name
        )
    }

    func historyIndicator(
        disruptionCountsByLineID: [TrainLineID: Int]
    ) -> LineStatusHistoryIndicator? {
        guard let count = disruptionCountsByLineID[id] else { return nil }
        guard !isDisrupted || count > 1 else { return nil }
        return .disruptionEarlierToday
    }
}


// MARK: - Display

extension Line {

    var accessoryImageType: LineStatusAccessoryImageType {
        isDisrupted ? .disruption : .goodService
    }

    struct MergedStatus: Hashable, Identifiable {
        fileprivate(set) var severityDescriptions: [String]
        let isDisrupted: Bool
        let reason: String
        let additionalInfo: String?

        var severityText: String { severityDescriptions.joined(separator: ", ") }
        var id: Self { self }
    }

    var mergedLineStatuses: [MergedStatus] {
        var groups = [MergedStatus]()

        for status in lineStatusesSortedBySeverity {
            let reason = status.reason?.trimmed().removingLineNamePrefix(for: id) ?? ""
            let additionalInfo = status.disruption?.additionalInfo?.trimmed()

            if let index = groups.firstIndex(
                where: { $0.reason == reason && $0.additionalInfo == additionalInfo }
            ) {
                if let desc = status.statusSeverityDescription.map(\.sentenceCase), !groups[index].severityDescriptions.contains(desc) {
                    groups[index].severityDescriptions.append(desc)
                }
            } else {
                groups.append(
                    MergedStatus(
                        severityDescriptions: status.statusSeverityDescription.map { [$0.sentenceCase] } ?? [],
                        isDisrupted: status.isDisrupted,
                        reason: reason,
                        additionalInfo: additionalInfo
                    )
                )
            }
        }

        return groups
    }

    var shortStatusText: String {
        mergedLineStatuses
            .flatMap(\.severityDescriptions)
            .removingDuplicates()
            .joined(separator: ", ")
    }

    var truncatedStatusText: String {
        let descriptions =
            mergedLineStatuses
            .flatMap(\.severityDescriptions)
            .removingDuplicates()
        guard descriptions.count > 2 else { return descriptions.joined(separator: ", ") }
        return descriptions.prefix(2).joined(separator: ", ") + "…"
    }

}

extension String {
    /// TfL starts most reasons with the line's name, which only repeats the screen's title, in varying forms, e.g.
    /// "CENTRAL LINE: Severe delays…", "Bakerloo Line: No service…" or "DOCKLANDS LIGHT RAILWAY: Sunday 22 October…".
    func removingLineNamePrefix(for lineID: TrainLineID) -> String {
        guard let separator = range(of: ": ") else { return self }
        let prefix = self[..<separator.lowerBound]
        let isLineName = lineID.namesUsedByTfL.contains {
            prefix.compare($0, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
        }
        guard isLineName else { return self }
        let remainder = self[separator.upperBound...]
        return remainder.prefix(1).uppercased() + remainder.dropFirst()
    }
}

private extension TrainLineID {
    var namesUsedByTfL: [String] {
        let ownNames = [name, "\(name) line"]
        switch self {
        case .dlr: return ownNames + ["Docklands Light Railway"]
        case .tram: return ownNames + ["Trams", "London Trams"]
        case .liberty, .lioness, .mildmay, .suffragette, .weaver, .windrush: return ownNames + ["London Overground"]
        default: return ownNames
        }
    }
}

private extension String {
    var sentenceCase: String {
        guard let first = first else { return self }
        return first.uppercased() + dropFirst().lowercased()
    }
}

extension Line {
    var xPostLinks: [LineStatusXPostLink] {
        var xPostLinks = [LineStatusXPostLink(style: .tflAllXPosts, url: .latestXPosts())]

        let filteredPosts = LineStatusXPostLink(
            style: .lineXPosts(lineId: id),
            url: .latestXPosts(filteredBy: id)
        )
        xPostLinks.append(filteredPosts)

        return xPostLinks
    }
}
