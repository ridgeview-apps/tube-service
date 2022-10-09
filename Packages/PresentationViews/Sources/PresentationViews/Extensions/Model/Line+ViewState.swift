import Foundation
import Models


// MARK: - Data sorting

public extension Array where Element == Line {
    func sortedByStatusSeverity() -> [Line] {
        sorted { $0.sortProperties < $1.sortProperties }
    }
}

public extension Line {
    
    typealias SortProperties = (disruptionSortOrder: Int,
                                lineName: String)
    
    var statusSeverity: LineStatusSeverity {
        lineStatusesSortedBySeverity
            .compactMap(\.statusSeverity).first ?? .undefined
    }
    
    var lineStatusesSortedBySeverity: [LineStatus] {
        (lineStatuses ?? []).sortedByStatusSeverity()
    }
    
    var isDisrupted: Bool {
        (lineStatuses ?? []).contains { $0.isDisrupted }
    }
    
    var sortProperties: SortProperties {
        (isDisrupted ? 0 : 1,
         lineName: id.name)
    }
}


// MARK: - Display

public extension Line {
    
    struct ServiceDetailTextItem: Equatable {
        enum MessageType: Equatable {
            case goodService
            case disrupted(reason: String?)
        }
        let messageType: MessageType
        let additionalInfo: String?
    }
    
    var serviceDetailTextItems: [ServiceDetailTextItem] {
        var uniqueTextItems = [ServiceDetailTextItem]()
        
        lineStatuses?.sortedByStatusSeverity().forEach {
            let textItem: ServiceDetailTextItem
            if $0.isDisrupted {
                textItem = ServiceDetailTextItem(messageType: .disrupted(reason: $0.reason),
                                                 additionalInfo: $0.disruption?.additionalInfo)
            } else {
                textItem = ServiceDetailTextItem(messageType: .goodService,
                                                 additionalInfo: nil)
            }
            if !uniqueTextItems.contains(textItem) {
                uniqueTextItems.append(textItem)
            }
        }
        
         return uniqueTextItems
    }

    var shortText: String {
        let uniqueStatusDescriptions = Set((lineStatuses ?? []).compactMap { $0.statusSeverityDescription }).sorted()
        return uniqueStatusDescriptions.joined(separator: ", ")
    }
    
    var twitterLinks: [LineStatusTwitterLink] {
        var twitterLinks = [LineStatusTwitterLink(style: .tflAllTweets, url: .latestTflTweets())]
        if id.shouldShowFilteredTweets {
            let filteredTweets = LineStatusTwitterLink(style: .lineTweets(lineId: id),
                                                       url: .latestTflTweets(filteredBy: id))
            twitterLinks.append(filteredTweets)
        }
        return twitterLinks
    }
}
