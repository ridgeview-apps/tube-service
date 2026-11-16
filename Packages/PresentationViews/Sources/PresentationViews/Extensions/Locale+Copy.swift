import Foundation

extension Locale {

    /// The language the copy is shown in, with the user's own region and preferences.
    /// Use it for formatting that lands inside localized copy, so a French device shows
    /// "Circle and Met" rather than "Circle et Met" while the copy is only in English.
    static var copy: Locale {
        var components = Locale.Components(locale: .current)
        components.languageComponents = Locale.Language.Components(
            identifier: Bundle.module.preferredLocalizations.first ?? "en"
        )
        return Locale(components: components)
    }
}
