public enum NotificationsDataStoreError: Error, Sendable {
    /// The action needs a server-side device, but this device has never registered.
    case deviceNotRegistered
}
