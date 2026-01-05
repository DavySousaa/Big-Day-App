import Foundation

enum DateHelper {
    static let tz = TimeZone(identifier: "America/Fortaleza") ?? .current

    static func dateKey(from date: Date) -> String {
        var comp = Calendar.current.dateComponents(in: tz, from: date)
        comp.hour = 0; comp.minute = 0; comp.second = 0; comp.nanosecond = 0
        let day = Calendar.current.date(from: comp) ?? date
        let f = DateFormatter()
        f.timeZone = tz
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: day)
    }

    static func dayTitle(from date: Date) -> String {
        let f = DateFormatter()
        f.timeZone = tz
        f.dateFormat = "EEE',' 'dia' d 'de' MMMM"
        return f.string(from: date).capitalized
    }

    /// Junta uma data (dia) com um horário "HH:mm" (opcional)
    static func combine(day: Date, timeHM: String?) -> Date {
        guard let timeHM, timeHM.count == 5 else { return day }
        let comps = timeHM.split(separator: ":")
        let h = Int(comps[0]) ?? 0
        let m = Int(comps[1]) ?? 0
        var cal = Calendar.current
        cal.timeZone = tz
        var c = cal.dateComponents([.year,.month,.day], from: day)
        c.hour = h; c.minute = m
        return cal.date(from: c) ?? day
    }
}
