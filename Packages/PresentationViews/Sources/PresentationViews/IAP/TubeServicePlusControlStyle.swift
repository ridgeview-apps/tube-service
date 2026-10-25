import StoreKit
import SwiftUI

/// Subscription controls for the Tube Service Plus store: the offer terms, a subscribe button that says what it
/// does, and a low-key restore link. Replaces the built-in controls, whose labels are either the product name or
/// a generic "Accept Offer", and whose restore button is as prominent as the subscribe button.
public struct TubeServicePlusControlStyle: SubscriptionStoreControlStyle {

    let isRestoring: Bool
    let onRestore: () -> Void

    public init(isRestoring: Bool, onRestore: @escaping () -> Void) {
        self.isRestoring = isRestoring
        self.onRestore = onRestore
    }

    public func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 12) {
            ForEach(configuration.options) { option in
                VStack(spacing: 8) {
                    // StoreKit requires the active offer's terms to be shown alongside the control.
                    Text(terms(for: option))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    // The store view styles this like its own subscribe button.
                    Button(action: option.subscribe) {
                        Text(isFreeTrial(option) ? .tubeServicePlusSubscribeFreeTrialButton : .tubeServicePlusSubscribeButton)
                    }
                }
            }

            Button(action: onRestore) {
                if isRestoring {
                    ProgressView()
                } else {
                    Text(.tubeServicePlusRestoreButton)
                }
            }
            .font(.subheadline)
            // Opts out of the store view's prominent button style, which it applies to every button in the controls.
            .buttonStyle(.borderless)
            .disabled(isRestoring)
        }
    }

    private func isFreeTrial(_ option: Configuration.Option) -> Bool {
        option.activeOffer?.paymentMode == .freeTrial
    }

    /// e.g. "1 month free, then £6.99/year", or "£6.99/year" once the trial has been used.
    private func terms(for option: Configuration.Option) -> String {
        let product = option.subscription
        guard let period = product.subscription?.subscriptionPeriod else { return product.displayPrice }
        let price = pricePerPeriod(product.displayPrice, period: period, product: product)

        if let offer = option.activeOffer, offer.paymentMode == .freeTrial {
            let trialLength = offer.period.formatted(numericPeriodStyle(for: product))
            return String(localized: .tubeServicePlusTermsFreeTrial(trialLength, price))
        }
        return price
    }

    /// Uses our own strings for single periods: StoreKit's unit format style capitalises a standalone unit ("Year").
    private func pricePerPeriod(
        _ price: String,
        period: Product.SubscriptionPeriod,
        product: Product
    ) -> String {
        guard period.value == 1 else {
            let length = period.formatted(numericPeriodStyle(for: product))
            return String(localized: .tubeServicePlusPriceEvery(price, length))
        }
        switch period.unit {
        case .day: return String(localized: .tubeServicePlusPricePerDay(price))
        case .week: return String(localized: .tubeServicePlusPricePerWeek(price))
        case .month: return String(localized: .tubeServicePlusPricePerMonth(price))
        case .year: return String(localized: .tubeServicePlusPricePerYear(price))
        @unknown default:
            return String(localized: .tubeServicePlusPriceEvery(price, period.formatted(numericPeriodStyle(for: product))))
        }
    }

    /// StoreKit's period format style spells numbers out ("one month"); the wide style keeps digits ("1 month").
    private func numericPeriodStyle(for product: Product) -> Date.ComponentsFormatStyle {
        var style = product.subscriptionPeriodFormatStyle
        style.style = .wide
        return style
    }
}


// MARK: - Alerts

/// Problems on the Tube Service Plus store that the store view doesn't report itself.
public enum TubeServicePlusAlert: Equatable {
    case purchaseFailed(errorMessage: String)
    case nothingToRestore
    case restoreFailed(errorMessage: String)
}

extension View {

    /// Explains a purchase or restore that didn't unlock Tube Service Plus. Success needs no alert: the store
    /// dismisses itself once the subscription is active.
    public func tubeServicePlusAlert(_ alert: Binding<TubeServicePlusAlert?>) -> some View {
        self.alert(
            Text(alert.wrappedValue?.title ?? .tubeServicePlusRestoreNothingTitle),
            isPresented: Binding(
                get: { alert.wrappedValue != nil },
                set: { isPresented in
                    if !isPresented { alert.wrappedValue = nil }
                }
            ),
            presenting: alert.wrappedValue
        ) { _ in
            Button(.globalOk, role: .cancel) {}
        } message: { alert in
            switch alert {
            case .nothingToRestore:
                Text(.tubeServicePlusRestoreNothingMessage)
            case .purchaseFailed(let errorMessage), .restoreFailed(let errorMessage):
                Text(verbatim: errorMessage)
            }
        }
    }
}

private extension TubeServicePlusAlert {
    var title: LocalizedStringResource {
        switch self {
        case .purchaseFailed: .tubeServicePlusPurchaseFailedTitle
        case .nothingToRestore: .tubeServicePlusRestoreNothingTitle
        case .restoreFailed: .tubeServicePlusRestoreFailedTitle
        }
    }
}
