import UIKit

enum SelectedDateStore {
    private static let key = "selectedDateKey"

    static func save(_ date: Date) {
        let k = DateHelper.dateKey(from: date)
        UserDefaults.standard.set(k, forKey: key)
    }

    static func load() -> Date? {
        guard let k = UserDefaults.standard.string(forKey: key) else { return nil }
        // Remonta uma Date a partir da dateKey (meia-noite no fuso correto)
        let f = DateFormatter()
        f.timeZone = DateHelper.tz
        f.dateFormat = "yyyy-MM-dd"
        return f.date(from: k)
    }
}
