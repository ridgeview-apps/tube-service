import ComposableArchitecture
import Model
import Shared

public enum LineStatusDetail: Equatable {
    
    public struct State: Equatable, Identifiable {
        public var id: LineStatus.ID { lineStatus.id }
        public var hasLoaded = false
        public var lineStatus: LineStatus
        public var twitterLinks: [TwitterLink]
        public var activeTwitterLink: TwitterLink?
        
        public init(
            hasLoaded: Bool = false,
            lineStatus: LineStatus,
            twitterLinks: [LineStatusDetail.TwitterLink] = [],
            activeTwitterLink: LineStatusDetail.TwitterLink? = nil
        ) {
            self.hasLoaded = hasLoaded
            self.lineStatus = lineStatus
            self.twitterLinks = twitterLinks
            self.activeTwitterLink = activeTwitterLink
        }
    }
    
    public struct TwitterLink: Equatable, Identifiable {
        public enum Style: Equatable {
            case tflAllTweets
            case lineTweets(lineId: TrainLine)
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
    
    public enum Action: Equatable {
        case onAppear
        case setActiveTwitterLink(to: TwitterLink?)
    }
    
    public typealias Environment = Void

    public static let reducer = Reducer<State, Action, Environment>.combine(
        
        Reducer  { state, action, env in
            switch action {
            case .onAppear:
                if !state.hasLoaded {
                    state.twitterLinks = [.init(style: .tflAllTweets, url: .latestTflTweets())]
                    if state.lineStatus.id.shouldShowFilteredTweets {
                        let filteredTweets = TwitterLink(style: .lineTweets(lineId: state.lineStatus.id),
                                                         url: .latestTflTweets(filteredBy: state.lineStatus.id))
                        state.twitterLinks.append(filteredTweets)
                    }
                    state.hasLoaded = true
                }
                return .none
            case let .setActiveTwitterLink(twitterLink):
                state.activeTwitterLink = twitterLink
                return .none
            }
        })
}

private extension URL {
    static func latestTflTweets(filteredBy filteredLine: TrainLine? = nil) -> URL {
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

private extension TrainLine {

    var twitterSearchNameFilter: String? {
        switch self {
        case .bakerloo, .central, .circle, .district, .elizabeth, .hammersmithAndCity, .jubilee, .metropolitan,
             .northern, .piccadilly, .victoria, .waterlooAndCity:
            return "\(rawValue) line"
        case .tram, .dlr:
            return rawValue
        case .overground:
            return nil
        }
    }

    var shouldShowFilteredTweets: Bool {
        switch self {
        case .bakerloo, .central, .circle, .district, .elizabeth, .hammersmithAndCity, .jubilee, .metropolitan,
             .northern, .piccadilly, .victoria, .waterlooAndCity, .tram, .dlr:
            return true
        case .overground:
            return false
        }
    }
}
