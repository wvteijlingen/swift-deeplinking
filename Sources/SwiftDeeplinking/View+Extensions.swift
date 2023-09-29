import SwiftUI

extension View {
    /// Registers a handler to invoke when the view receives a deeplink.
    ///
    /// The `handler` receives a ``Deeplink`` instance. It can take some action depending on the deeplink,
    /// and should return a ``DeeplinkHandlerResult``.
    ///
    /// ## Return value
    /// If the handler has fully handled the deeplink and it doesn't need to be processed further,
    /// the handler should return `.fullyHandled`.
    ///
    /// If the handler has partially handled the deeplink, but another screen should
    /// also take some action based on the link, the handler should return `.partiallyHandled`.
    ///
    /// If the handler has not handled the deeplink at all, the handler should return `.notHandled`.
    ///
    /// - Parameter handler: A function that takes a Deeplink object and returns a ``HandlerResult``.
    public func onOpenDeeplink(handler: @escaping DeeplinkHandler) -> some View {
        modifier(OnOpenDeeplinkViewModifier(handler: handler))
    }
}

private struct OnOpenDeeplinkViewModifier: ViewModifier {
    private let handler: DeeplinkHandler

    @State private var deeplinkHandlerID: String?
    @EnvironmentObject private var deeplinkManager: DeeplinkManager

    init(handler: @escaping DeeplinkHandler) {
        self.handler = handler
    }

    public func body(content: Content) -> some View {
        content
            .onAppear {
                deeplinkHandlerID = deeplinkManager.register(handler: handler, id: deeplinkHandlerID)
            }
            .onDisappear {
                if let deeplinkHandlerID {
                    deeplinkManager.unregister(handlerWithID: deeplinkHandlerID)
                }
            }
    }
}