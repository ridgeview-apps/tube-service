import SwiftUI
import UIKit
import MessageUI

//
// Adapted from: https://stackoverflow.com/questions/56784722/swiftui-send-email
//
// swiftlint:disable identifier_name
public struct MailButton<Label: View>: View {
    
    @State private var result: Result<MFMailComposeResult, Error>?
    @State private var showMailComposer = false
    @State private var showMailUnsupported = false
    
    private let label: Label
    private let config: MailViewConfig?
    
    public init(to: [String]? = nil,
                cc: [String]? = nil,
                bcc: [String]? = nil,
                subject: String? = nil,
                body: String? = nil,
                isHtml: Bool = false,
                @ViewBuilder label: () -> Label) {
        self.label = label()
        self.config = .init(to: to,
                            cc: cc,
                            bcc: bcc,
                            subject: subject,
                            body: body,
                            isHtml: isHtml)
    }
    
    public var body: some View {
        Button {
            showMailComposer = MFMailComposeViewController.canSendMail()
            showMailUnsupported = !MFMailComposeViewController.canSendMail()
        } label: {
            label
        }
        .sheet(isPresented: $showMailComposer) {
            MailViewController(result: $result, messageConfig: config)
        }
        .alert(isPresented: $showMailUnsupported) {
            Alert(title: Text(.mailNotSupported))
        }
    }
}

struct MailViewConfig {
    struct Body {
        let text: String
        let isHtml: Bool
    }
    private(set) var to: [String]?
    private(set) var cc: [String]?
    private(set) var bcc: [String]?
    private(set) var subject: String?
    private(set) var body: String?
    private(set) var isHtml: Bool
    
    init(to: [String]? = nil,
         cc: [String]? = nil,
         bcc: [String]? = nil,
         subject: String? = nil,
         body: String? = nil,
         isHtml: Bool = false) {
        self.to = to
        self.cc = cc
        self.bcc = bcc
        self.subject = subject
        self.body = body
        self.isHtml = isHtml
    }
}

private struct MailViewController: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    private(set) var messageConfig: MailViewConfig?
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        let messageConfig: MailViewConfig?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>,
             messageConfig: MailViewConfig? = nil) {
            _presentation = presentation
            _result = result
            
            self.messageConfig = messageConfig
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result,
                           messageConfig: messageConfig)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()

        vc.mailComposeDelegate = context.coordinator

        if let messageConfig = context.coordinator.messageConfig {
            if let to = messageConfig.to {
                vc.setToRecipients(to)
            }
            if let cc = messageConfig.cc {
                vc.setCcRecipients(cc)
            }
            if let bcc = messageConfig.bcc {
                vc.setBccRecipients(bcc)
            }
            if let subject = messageConfig.subject {
                vc.setSubject(subject)
            }
            if let body = messageConfig.body {
                vc.setMessageBody(body, isHTML: messageConfig.isHtml)
            }
        }

        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
    }

}
// swiftlint:enable identifier_name
