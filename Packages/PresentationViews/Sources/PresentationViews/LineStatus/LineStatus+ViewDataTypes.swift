import Models
import SwiftUI

public enum LineStatusFilterOption: Int, Identifiable, CaseIterable {
    public var id: Int { rawValue }
    case today, thisWeekend, future
}


// MARK: Twitter Links

extension URL {
    
    static func latestTflTweets(filteredBy filteredLine: LineID? = nil) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "twitter.com"

        if let line = filteredLine, let twitterSearchNameFilter = line.twitterSearchNameFilter {
            urlComponents.path = "/search"
            
            var query: String = "(from:TfL OR to:TfL)"
            query.append(" \(twitterSearchNameFilter)")

            urlComponents.queryItems = [
                URLQueryItem(name: "q", value: query),
//                URLQueryItem(name: "src", value: "typed_query"),
                URLQueryItem(name: "f", value: "live"),
            ]
        } else {
            urlComponents.path = "/TfL/with_replies"
        }
        
        return urlComponents.url!
    }
}

public struct LineStatusTwitterLink: Equatable, Identifiable {
    public enum Style: Equatable {
        case tflAllTweets
        case lineTweets(lineId: LineID)
    }
    
    public var id: URL { url }
    public var style: Style
    public var url: URL
    
    public init(style: Style,
                url: URL) {
        self.style = style
        self.url = url
    }
}
