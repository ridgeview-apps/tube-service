import Observation

@Observable
@MainActor
final class Router<Route: Hashable> {
    var navigation = NavigationRouter<Route>()
    var sheetRouter = SheetRouter()
}

@Observable
@MainActor
final class NavigationRouter<Route: Hashable> {

    var path: [Route] = []

    var currentRoute: Route? {
        path.last
    }

    func popToRoot() {
        path = []
    }

    func push(_ nextRoute: Route) {
        path.append(nextRoute)
    }

    func goBack() {
        _ = path.popLast()
    }
}

@Observable
@MainActor
final class SheetRouter {
    var presentedSheet: Sheet?
    var presentedFullScreenSheet: Sheet?

    func show(_ sheet: Sheet?, style: Sheet.ModalStyle = .standard) {
        switch style {
        case .standard:
            self.presentedSheet = sheet
        case .fullScreen:
            presentedFullScreenSheet = sheet
        }
    }

    func dismiss(
        closePresentedSheet: Bool = true,
        closeFullScreenSheet: Bool = true
    ) {
        if closePresentedSheet {
            self.presentedSheet = nil
        }
        if closeFullScreenSheet {
            self.presentedFullScreenSheet = nil
        }
    }
}
