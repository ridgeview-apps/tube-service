import os

public enum AppLogger {
    private static let subsystem = "com.ridgeviewapps.tube-service"

    public static let notifications = Logger(subsystem: subsystem, category: "Notifications")
    public static let purchases = Logger(subsystem: subsystem, category: "Purchases")
    public static let networking = Logger(subsystem: subsystem, category: "Networking")
}
