import ComposableArchitecture

enum LineStatusDetail: Equatable {
    
    struct ViewState: Equatable, Identifiable {
        struct TwitterLink: Equatable {
            var title: String
            var url: URL
        }
        var id: LineStatus.ID { lineStatus.id }
        var hasLoaded = false
        var lineStatus: LineStatus
        var allTweetsLink: TwitterLink?
        var filteredTweetsLink: TwitterLink?
        var activeTwitterLink: TwitterLink?
    }
    
    typealias State = IdentifiableState<ViewState>
    
    enum Action: Equatable {
        case onAppear
        case set(twitterLink: ViewState.TwitterLink, isActive: Bool)
        case global(Global.Action)
    }
    
    typealias Environment = Root.Environment

    static let reducer = Reducer<State, Action, Environment>.combine(
        
        Global.reducer.pullback(state: \.globalState,
                                action: /Action.global,
                                environment: { $0 }),
        
        Reducer  { state, action, env in
            switch action {
            case .onAppear:
                if !state.hasLoaded {
                    let tflTwitterHandle = env.stringLocalizer.localized("status.tfl.twitter.handle")
                    let allTweetsSuffix = env.stringLocalizer.localized("status.tfl.twitter.allTweets")
                    state.allTweetsLink = .init(title: "\(tflTwitterHandle) (\(allTweetsSuffix))",
                                                url: .latestTflTweets())
                    if let filteredTweetsSuffix = state.lineStatus.id.filteredTweetsTitleSuffix {
                        state.filteredTweetsLink = .init(title: "\(tflTwitterHandle) (\(filteredTweetsSuffix))",
                                                         url: .latestTflTweets(filteredBy: state.lineStatus.id))
                    }
                    state.hasLoaded = true
                }
                return .none
            case let .set(twitterLink, isActive):
                state.activeTwitterLink = isActive ? twitterLink : nil
                return .none
            case .global:
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
        case .bakerloo, .central, .circle, .district, .hammersmithAndCity, .jubilee, .metropolitan,
             .northern, .piccadilly, .victoria, .waterlooAndCity:
            return "\(rawValue) line"
        case .tram, .dlr:
            return rawValue
        case .tflRail, .overground:
            return nil
        }
    }

    var filteredTweetsTitleSuffix: String? {
        switch self {
        case .bakerloo, .central, .circle, .district, .hammersmithAndCity, .jubilee, .metropolitan,
             .northern, .piccadilly, .victoria, .waterlooAndCity:
            return longName
        case .tram, .dlr:
            return shortName
        case .tflRail, .overground:
            return nil
        }
    }
}
