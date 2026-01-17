import Foundation

final class NewTaskViewModel {

    var onSucess: (() -> Void)?
    var onError: ((String) -> Void)?

    private let repo = TaskRepository.shared
    
    func createRepeatingTask (title: String, shouldSchedule: Bool, selectedDate: Date?, repeatDays: [Int]) {
        
    }
    
    func createTask(title: String, shouldSchedule: Bool, selectedDate: Date?) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            onError?("Digite uma tarefa para ser adicionada!")
            return
        }

        let timeString = DateFormatHelper.formatTime(shouldSchedule: shouldSchedule, date: selectedDate)
        let hasTime = (shouldSchedule && timeString.isEmpty == false)

        let baseDay = selectedDate ?? Date()

        let dueDate = DateHelper.combine(day: baseDay, timeHM: timeString)

        repo.createTask(title: trimmed,
                        timeString: timeString,
                        dueDate: dueDate,
                        hasTime: hasTime) { [weak self] result in
            switch result {
            case .success(let taskID):
                if hasTime {
                    NotificationManager.shared.scheduleTaskReminder(title: trimmed, date: dueDate, identifier: taskID)
                }
                self?.onSucess?()
            case .failure(let err):
                self?.onError?("Erro ao criar tarefa: \(err.localizedDescription)")
            }
        }
    }

    /// Versão alternativa se você já tiver o `timeString` pronto (ex.: “14:30”).
    func createTask(title: String, timeString: String?, baseDay: Date) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            onError?("Digite uma tarefa para ser adicionada!")
            return
        }
        let dueDate = DateHelper.combine(day: baseDay, timeHM: timeString)
        let hasTime = (timeString?.isEmpty == false)
        
        repo.createTask(title: trimmed,
                        timeString: timeString,
                        dueDate: dueDate,
                        hasTime: hasTime) { [weak self] result in
            switch result {
            case .success(let taskID):
                if hasTime {
                    NotificationManager.shared.scheduleTaskReminder(title: trimmed, date: dueDate, identifier: taskID)
                }
                self?.onSucess?()
            case .failure(let err):
                self?.onError?("Erro ao criar tarefa: \(err.localizedDescription)")
            }
        }
    }
}

