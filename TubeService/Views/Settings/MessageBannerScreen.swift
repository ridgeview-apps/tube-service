import PresentationViews
import SwiftUI

struct MessageBannerScreen: View {
    
    @Environment(MessageBannerService.self) private var messageBanner: MessageBannerService
    @State private var autoDismissTask: DispatchWorkItem?
    
    var body: some View {
        Color
            .clear
            .ignoresSafeArea()
            .frame(width: .infinity, height: .infinity)
            .overlay(alignment: .top) {
                if let currentMessage = messageBanner.currentMessage {
                    MessageBannerView(
                        banner: currentMessage,
                        onManualClose: {
                            autoDismissTask?.cancel()
                            dismissAndShowNext()
                        }
                    )
                }
            }
            .onChange(of: messageBanner.currentMessage) { _, newValue in
                if let newValue {
                    setUpAutoDismiss(forMessage: newValue)
                }
            }
    }
    
    private func setUpAutoDismiss(forMessage currentMessage: MessageBanner) {
        let autoDismissTask = DispatchWorkItem { dismissAndShowNext() }
        DispatchQueue.main.asyncAfter(deadline: .now() + currentMessage.dismissAfter, execute: autoDismissTask)
        self.autoDismissTask = autoDismissTask
    }
    
    private func dismissAndShowNext() {
        withAnimation {
            // 1. Animate hiding the message
            messageBanner.hideCurrentMessage()
            
            // 2. Animate showing the next message in the queue
            if messageBanner.hasMoreMesssages {
                withAnimation(.default.delay(0.6)) {
                    messageBanner.dequeueNextMessage()
                }
            }
        }
    }
}


@Observable
@MainActor
final class MessageBannerService {
    
    private(set) var messageQueue = [MessageBanner]()
    private(set) var currentMessage: MessageBanner?
    
 
    func show(message: MessageBanner) {
        messageQueue.insert(message, at: 0)
        
        if currentMessage == nil {
            dequeueNextMessage()
        }
    }
}

private extension MessageBannerService {
    var hasMoreMesssages: Bool {
        !messageQueue.isEmpty
    }
    
    func hideCurrentMessage() {
        currentMessage = nil
    }
    
    func dequeueNextMessage() {
        guard let oldestMessage = messageQueue.popLast() else {
            return // No more messages
        }
        currentMessage = oldestMessage
    }
}


// MARK: - Previews

#Preview {
    @Previewable @State var messageBannerService: MessageBannerService = MessageBannerService()
    
    MessageBannerScreen()
        .overlay {
            Button("Show banner preview") {
                withAnimation {
                    messageBannerService.show(
                        message: .init(
                            style: .error, message: "Transient message"
                        )
                    )
                }
            }
        }
        .environment(messageBannerService)
}
