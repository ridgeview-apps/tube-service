import Models
import SwiftUI

public enum LineStatusFilterOption: Int, Identifiable, CaseIterable {
    public var id: Int { rawValue }
    case today, tomorrow, thisWeekend, future
}

public enum LineStatusAccessoryImageType {
    case goodService, disruption
}

public extension LineStatusAccessoryImageType {
    @ViewBuilder var image: some View {
        switch self {
        case .disruption:
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(.adaptiveRed)
        case .goodService:
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        }
    }
}


// MARK: X Posts

extension URL {
    
    static func latestXPosts(filteredBy filteredLine: TrainLineID? = nil) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "x.com"

        if let line = filteredLine, let searchNameFilter = line.xPostsSearchNameFilter {
            urlComponents.path = "/search"
            
            var query: String = "(from:TfL OR to:TfL)"
            query.append(" \(searchNameFilter)")

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

public struct LineStatusXPostLink: Equatable, Identifiable, Sendable {
    public enum Style: Equatable, Sendable {
        case tflAllXPosts
        case lineXPosts(lineId: TrainLineID)
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
