import Foundation
import SwiftUI

public protocol Deeplinkable {}
public typealias DeeplinkHandler = (Deeplinkable) -> DeeplinkHandlerResult

public class DeeplinkManager: ObservableObject {
    fileprivate var pendingDeeplink: Deeplinkable?
    fileprivate var isHandlingPendingDeeplink = false
    fileprivate var handlers: [(id: String, handler: DeeplinkHandler)] = []

    public init() {}

    public func handle(_ deeplink: Deeplinkable) {
        pendingDeeplink = deeplink
        isHandlingPendingDeeplink = false

        for element in handlers {
            // print("[Deeplink] Running handler \(element.id)")

            let result = element.handler(deeplink)

            switch result {
            case .fullyHandled:
                isHandlingPendingDeeplink = false
            case .partiallyHandled:
                isHandlingPendingDeeplink = true
            case .notHandled:
                break
            }
        }

        // If nothing is handling the deeplink anymore, we clear it.
        if !isHandlingPendingDeeplink {
            // print("[Deeplink] Deeplink is not being handled anymore, clearing pending deeplink")
            pendingDeeplink = nil
        }
    }

    func register(handler: @escaping (Deeplinkable) -> DeeplinkHandlerResult) -> String {
        let id = UUID().uuidString
        
        // print("[Deeplink] Registering handler \(id)")

        handlers.append((id: id, handler: handler))

        // If we have a pending deeplink, immediately run the handler. If the handler resolved the deeplink, clear it.
        if let deeplink = pendingDeeplink {
            // print("[Deeplink] Running handler on register \(id)")

            let result = handler(deeplink)

            switch result {
            case .fullyHandled:
                // print("[Deeplink] Deeplink is not being handled anymore, clearing pending deeplink")
                isHandlingPendingDeeplink = false
                pendingDeeplink = nil
            case .partiallyHandled:
                isHandlingPendingDeeplink = true
            case .notHandled:
                break
            }
        } else {
            // print("[Deeplink] No pending deeplink")
        }

        return id
    }

    fileprivate func unregister(handlerWithID id: String) {
        guard let index = handlers.firstIndex(where: { $0.id == id }) else {
            assertionFailure("Handler with id \(id) does not exist")
            return
        }

        // print("[Deeplink] Unregistering handler \(id)")
        handlers.remove(at: index)
    }
}