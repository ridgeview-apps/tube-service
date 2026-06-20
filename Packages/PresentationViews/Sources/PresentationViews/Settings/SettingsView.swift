import Models
import SwiftUI

public struct SettingsView: View {

    public enum Action {
        case openDebugSettings
        case notificationsTapped
    }

    public typealias ContactUs = Settings.ContactUs
    public typealias DebugAction = Settings.DebugAction

    public let appVersionNumber: String
    public let appReviewURL: URL
    public let contactUs: ContactUs
    public let systemStatus: SystemStatus?
    public let notificationsRowState: Settings.NotificationsRowState?
    public let onAction: (Action) -> Void

    public init(
        appVersionNumber: String,
        appReviewURL: URL,
        contactUs: ContactUs,
        systemStatus: SystemStatus?,
        notificationsRowState: Settings.NotificationsRowState? = nil,
        onAction: @escaping (Action) -> Void
    ) {
        self.appVersionNumber = appVersionNumber
        self.appReviewURL = appReviewURL
        self.contactUs = contactUs
        self.systemStatus = systemStatus
        self.notificationsRowState = notificationsRowState
        self.onAction = onAction
    }

    public var body: some View {
        Form {
            supportSection
            aboutSection
        }
    }


    // MARK: - Layout views

    private var supportSection: some View {
        Section {
            if let notificationsRowState {
                Button {
                    onAction(.notificationsTapped)
                } label: {
                    HStack {
                        Text(.settingsNotificationsRowTitle)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.tertiary)
                    }
                }
                .foregroundStyle(.primary)
                .opacity(notificationsRowState == .notSetUp ? 0.6 : 1)
            }
            MailButton(
                to: [contactUs.emailAddress],
                subject: emailSubject,
                body: emailBody
            ) {
                Text(.settingsContactUsTitle)
            }
            Link(destination: appReviewURL) {
                Text(.settingsRateThisAppTitle)
            }
            NavigationLink {
                SystemStatusDetailView(systemStatus: systemStatus)
            } label: {
                systemStatusLabelTitle
            }
        } header: {
            Text(.settingsSectionSupportTitle)
        }
    }

    private var systemStatusLabelTitle: some View {
        HStack {
            if let systemStatus {
                systemStatus
                    .titleImage
                    .foregroundStyle(systemStatus.tint)
            }
            Text(.settingsSystemStatusTitle)
            Spacer()
        }
    }

    private var aboutSection: some View {
        Section(
            header: Text(.settingsSectionAboutTitle)
        ) {
            HStack {
                Text(.settingsAppVersionTitle)
                Spacer()
                Text(appVersionNumber)
            }
            .contentShape(Rectangle())
            .onTapGesture(count: 10) {
                onAction(.openDebugSettings)
            }
            NavigationLink {
                acknowledgements
            } label: {
                Text(.settingsAcknowledgementsTitle)
            }
        }
    }

    @ViewBuilder private var acknowledgements: some View {
        if let acknowledgementsURL = URL(string: "https://tfl.gov.uk/info-for/open-data-users/") {
            HStack {
                Text(.settingsAppPoweredBy)
                Link(
                    "TfL Open Data",
                    destination: acknowledgementsURL
                )

                .foregroundColor(.blue)
            }
            .font(.headline)
        }
    }

    private var emailSubject: String {
        String(localized: .contactUsSubject(contactUs.appName))
    }

    private var emailBody: String {
        """
        \(String(localized: .contactUsBodyDiagnosticInfo))

        \(String(localized: .contactUsBodyAppVersion)): \(contactUs.appVersion)
        \(String(localized: .contactUsBodyDeviceInfo)): \(contactUs.deviceInfo)
        \(String(localized: .contactUsBodyLocaleInfo)): \(contactUs.localeInfo)
        \(String(localized: .contactUsBodyOsVersion)): \(osNameAndVersion)
        """
    }

    private var osNameAndVersion: String {
        "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
    }
}


// MARK: - Previews

import ModelStubs

private struct Previewer: View {
    var body: some View {
        NavigationStack {
            SettingsView(
                appVersionNumber: "1.1.1",
                appReviewURL: URL(string: "https://www.google.com")!,
                contactUs: .empty,
                systemStatus: ModelStubs.systemStatusOutage,
                onAction: { print("Action \($0)") }
            )
        }
    }
}

#Preview {
    Previewer()
}
