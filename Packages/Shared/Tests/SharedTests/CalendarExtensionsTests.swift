import Foundation
import Testing

@testable import Shared

struct CalendarExtensionsTests {
    
    let weds18th = dayMonthYear(18, 10, 2023, in: .london)  // Weds 18th Oct 2023
    let friday20th = dayMonthYear(20, 10, 2023, in: .london)  // Fri 20th Oct 2023
    
    let saturday21st = dayMonthYear(21, 10, 2023, in: .london)  // Sat 21st Oct 2023
    let sunday22nd = dayMonthYear(22, 10, 2023, in: .london)    // Sun 22nd Oct 2023
    let monday23rd = dayMonthYear(23, 10, 2023, in: .london)    // Mon 23nd Oct 2023
    
    @Test
    func thisOrNextWeekend_MidWeek() {
        // Given
        let timeZone = TimeZone.london
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = timeZone
            
        // When
        let today = weds18th
        let weekendRange = calendar.thisOrNextWeekendDateInterval(for: today)
        
        // Then
        #expect(weekendRange?.start == saturday21st)
        #expect(weekendRange?.end == monday23rd) // N.B. Weekend date intervals end on Monday midnight (start of day)
    }
    
    @Test
    func thisOrNextWeekend_JustBeforeTheWeekend() {
        // Given
        let timeZone = TimeZone.london
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = timeZone
            
        // When
        let today = friday20th
        let weekendRange = calendar.thisOrNextWeekendDateInterval(for: today)
        
        // Then
        #expect(weekendRange?.start == saturday21st)
        #expect(weekendRange?.end == monday23rd) // N.B. Weekend date intervals end on Monday midnight (start of day)
    }
    
    @Test
    func thisOrNextWeekend_DuringTheWeekend_OnSaturday() {
        // Given
        let timeZone = TimeZone.london
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = timeZone
            
        // When
        let today = saturday21st
        let weekendRange = calendar.thisOrNextWeekendDateInterval(for: today)
        
        // Then
        #expect(weekendRange?.start == saturday21st)
        #expect(weekendRange?.end == monday23rd) // N.B. Weekend date intervals end on Monday midnight (start of day)
    }
    
    @Test
    func thisOrNextWeekend_DuringTheWeekend_OnSunday() {
        // Given
        let timeZone = TimeZone.london
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = timeZone
            
        // When
        let today = sunday22nd
        let weekendRange = calendar.thisOrNextWeekendDateInterval(for: today)
        
        // Then
        #expect(weekendRange?.start == saturday21st)
        #expect(weekendRange?.end == monday23rd) // N.B. Weekend date intervals end on Monday midnight (start of day)
    }
}


// MARK: - Private helpers

private extension CalendarExtensionsTests {
    
    private static func dayMonthYear(_ day: Int, _ month: Int, _ year: Int, in timeZone: TimeZone) -> Date {
        let calendar = Calendar.iso8601(in: timeZone)
        let dateComponents = DateComponents(calendar: calendar,
                                            timeZone: calendar.timeZone,
                                            year: year,
                                            month: month,
                                            day: day)
        return calendar.date(from: dateComponents)!
    }
}
