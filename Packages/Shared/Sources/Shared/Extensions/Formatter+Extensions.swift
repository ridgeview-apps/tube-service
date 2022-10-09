import Foundation

public extension Formatter {
    
    static let mediumRelativeDateTimeStyle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    static let fullDateStyle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }()
    
    static let longDateStyle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    static let shortTimeStyle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}

public extension DateIntervalFormatter {
    static let longDateIntervalStyle: DateIntervalFormatter = {
        let df = DateIntervalFormatter()
        df.dateStyle = .long
        df.timeStyle = .none
        return df
    }()
}
