import UserNotifications


class NotificationManager {
    
    static let shared = NotificationManager()
    
    func scheduleDailyMorningNotification() {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Bom dia! ☀️"
        content.body = "Hora de transformar seu dia em um Big Day!"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "morningReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleWeeklyMondayMotivation() {
        var components = DateComponents()
        components.weekday = 2
        components.hour = 8
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Nova semana, novas conquistas 🚀"
        content.body = "Planeje seu Big Day e comece a semana com tudo!"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "mondayMotivation", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleDailyNightNotification() {
        var components = DateComponents()
        components.hour = 22
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "E aí, foi produtivo hoje? 📊"
        content.body = "Dá uma olhada na sua lista e veja o quanto você concluiu!"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "nightReflection", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func rescheduleTaskReminder(for taskID: String, title: String, dueDate: Date) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [taskID])
        scheduleTaskReminder(title: title, date: dueDate, identifier: taskID)
    }
    
    func cancelTaskReminder(for taskID: String) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [taskID])
    }
    
    func scheduleTaskReminder(title: String, date: Date, identifier: String) {
        guard let reminderDate = Calendar.current.date(byAdding: .minute, value: -10, to: date) else { return }
        guard reminderDate > Date() else { return }
        
        let comps = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Alerta de tarefa ⏰"
        content.body = "Sua tarefa \"\(title)\" começa em 10 minutos!"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleWeeklyWedMotivation() {
        var components = DateComponents()
        components.weekday = 4
        components.hour = 8
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Já passamos da metade! 🚀"
        content.body = "Agora é hora de manter o gás e transformar essa semana em conquista total. Bora fechar com chave de ouro!"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "WedMotivation", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleWeeklySundayMotivation() {
        var components = DateComponents()
        components.weekday = 1
        components.hour = 16
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Hoje é dia de descanso 😴"
        content.body = "Planeje sua semana e comece com foco!"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "SundayMotivation", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
