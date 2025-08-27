import Foundation
import FirebaseFirestore

final class EditTaskViewModel {
    
    var taskToEdit: Task?
    
    var onSucess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private let repo = TaskRepository.shared
    
    func saveEditTask(title: String, shouldSchedule: Bool, selectedDate: Date?) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            onError?("Digite um título para a tarefa.")
            return
        }
        guard var task = taskToEdit else {
            onError?("Tarefa não encontrada.")
            return
        }
        guard let id = task.firebaseId else {
            onError?("ID da tarefa inválido.")
            return
        }
        
        var timeString: String? = nil
        if shouldSchedule, let selectedDate {
            let f = DateFormatter()
            f.locale = Locale(identifier: "pt_BR")
            f.timeZone = DateHelper.tz
            f.dateFormat = "HH:mm"
            timeString = f.string(from: selectedDate)
        }
        
        let baseDay = task.dueDate!
        let newDue = DateHelper.combine(day: baseDay, timeHM: timeString)
        
        var payload: [String: Any] = [
            "title": trimmed,
            "dueDate": newDue
        ]
        
        if let timeString {
            payload["time"] = timeString
            payload["hasTime"] = true
        } else {
            payload["time"] = FieldValue.delete()
            payload["hasTime"] = false
        }
        
        repo.update(id: id, fields: payload) { [weak self] err in
            if let err = err {
                self?.onError?("Erro ao atualizar: \(err.localizedDescription)")
            } else {
                task.title = trimmed
                task.time = timeString
                task.dueDate = newDue
                self?.taskToEdit = task
                
                if payload["hasTime"] as? Bool == true {
                    NotificationManager.shared.rescheduleTaskReminder(
                        for: id,
                        title: trimmed,
                        dueDate: newDue
                    )
                } else {
                    NotificationManager.shared.cancelTaskReminder(for: id)
                }
                
                self?.onSucess?()
            }
        }
    }
}

