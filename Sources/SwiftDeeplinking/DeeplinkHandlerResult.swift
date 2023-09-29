/// A result returned from a deeplink handler
public enum DeeplinkHandlerResult {
    /// The handler finished handling the deeplink, there is no further processing needed.
    case fullyHandled

    /// The handler handled the deeplink, but further processing is needed by other handlers.
    case partiallyHandled

    /// The handler did not handle the deeplink. Further processing might be needed by other handlers.
    case notHandled
}