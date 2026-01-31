import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    func scheduleAllWeeklyAndDailyNotifications() {
        scheduleDailyNightNotification()
        scheduleWeeklySundayMotivation()
        scheduleWeeklyMondayMotivation()
        scheduleWeeklyTuesdayMotivation()
        scheduleWeeklyWedMotivation()
        scheduleWeeklyThusMotivation()
        scheduleWeeklyFridayMotivation()
    }

    func removeAllBigDayNotifications() {
        let ids = [
            "nightReflection",
            "sundayMotivation",
            "mondayMotivation",
            "tuesMotivation",
            "wedMotivation",
            "thuMotivation",
            "friMotivation"
        ]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
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
        guard let reminderDate = Calendar.current.date(byAdding: .minute, value: -5, to: date) else { return }
        guard reminderDate > Date() else { return }
        
        let comps = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Alerta de tarefa ⏰"
        content.body = "Sua tarefa \"\(title)\" começa em 5 minutos!"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
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
        
        let request = UNNotificationRequest(identifier: "sundayMotivation", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleWeeklyMondayMotivation() {
        var components = DateComponents()
        components.weekday = 2
        components.hour = 8
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Planejamento define resultados 📌"
        content.body = "Estruture seu dia e conduza a semana com clareza e foco."
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "mondayMotivation", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleWeeklyTuesdayMotivation() {
        var components = DateComponents()
        components.weekday = 3
        components.hour = 8
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Hoje é dia de progresso 📈"
        content.body = "Passo por passo, tua rotina tá virando resultado 👊"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "tuesMotivation", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleWeeklyWedMotivation() {
        var components = DateComponents()
        components.weekday = 4
        components.hour = 8
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Metade do caminho, mesma força 🎯"
        content.body = "Não desacelera agora — teu Big Day ainda tá acontecendo 🔥"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "wedMotivation", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleWeeklyThusMotivation() {
        var components = DateComponents()
        components.weekday = 5
        components.hour = 8
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Constância é o novo talento 🧠"
        content.body = "Segue no ritmo. Quem mantém o foco, colhe diferente 🌱"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "thuMotivation", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleWeeklyFridayMotivation() {
        var components = DateComponents()
        components.weekday = 6
        components.hour = 8
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Último Big Day da semana 🚀"
        content.body = "Fecha forte hoje pra encerrar a semana com orgulho 💪"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "friMotivation", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
