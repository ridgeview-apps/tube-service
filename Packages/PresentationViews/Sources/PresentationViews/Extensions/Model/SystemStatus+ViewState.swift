import SwiftUI
import Models

extension SystemStatus {
    
    var formattedMessage: LocalizedStringResource {
        guard let message else {
            return defaultMessageText
        }
        return LocalizedStringResource(stringLiteral: message)
    }
    
    private var defaultMessageText: LocalizedStringResource {
        switch status {
        case .ok: .systemStatusOkDefaultMessage
        case .resolved: .systemStatusOkDefaultMessage
        case .outage: .systemStatusOutageDefaultMessage
        }
    }
    
    var titleImage: some View {
        Group {
            switch status {
            case .ok, .resolved:
                Image(systemName: "checkmark.circle.fill")
            case .outage:
                Image(systemName: "exclamationmark.circle.fill")
            }
        }
        .imageScale(.large)
    }
    
    var tint: Color {
        switch status {
        case .ok, .resolved: .systemBannerOK
        case .outage: .systemBannerOutage
        }
    }
    
    var foregroundStyle: Color { .white }
}
