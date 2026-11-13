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

extension Line {
    /// The first disruption's reason without TfL's line name prefix, for the Station screen's line status card.
    var disruptionReason: String? {
        mergedLineStatuses
            .first { $0.isDisrupted && !$0.reason.isEmpty }
            .map { $0.reason.removingLineNamePrefix() }
    }
}

extension String {
    /// TfL starts most reasons with the line's name, which the card already shows, e.g. "Bakerloo Line: No service…",
    /// "DOCKLANDS LIGHT RAILWAY: Sunday 22 October, …" or "London Overground: Minor delays…". A prefix with digits is
    /// kept, as it's more likely a date, e.g. "Sunday 22 October: …".
    func removingLineNamePrefix() -> String {
        guard let separator = range(of: ": ") else { return self }
        let prefix = self[..<separator.lowerBound]
        let isLineName = prefix.split(separator: " ").count <= 4 && !prefix.contains(where: \.isNumber)
        return isLineName ? String(self[separator.upperBound...]) : self
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
