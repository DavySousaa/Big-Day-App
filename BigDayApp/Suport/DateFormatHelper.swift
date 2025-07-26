import Foundation


final class DateFormatHelper {
    static func formatTime(shouldSchedule: Bool, date: Date?) -> String {
        guard shouldSchedule, let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    static func dateFromFormattedTime(_ timeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: timeString)
    }
}
