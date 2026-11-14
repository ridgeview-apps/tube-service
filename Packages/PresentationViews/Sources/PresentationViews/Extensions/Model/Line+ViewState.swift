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
            let reason = status.reason?.trimmed() ?? ""
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
