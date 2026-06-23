import PresentationViews
import SwiftUI

@Observable
@MainActor
final class JourneyPlannerSession {
    var form: JourneyPlannerForm = .empty
}
