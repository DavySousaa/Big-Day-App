import Foundation

final class NewTaskViewModel {

    var onSucess: (() -> Void)?
    var onError: ((String) -> Void)?

    // Dependência
    private let repo = TaskRepository.shared

    /// Cria a tarefa no Firestore para o dia selecionado.
    /// - Parameters:
    ///   - title: título digitado
    ///   - shouldSchedule: se o usuário ligou o horário
    ///   - selectedDate: data/hora vinda do seu UIDatePicker (se ligado). Se não tiver hora, passe nil.
    func createTask(title: String, shouldSchedule: Bool, selectedDate: Date?) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            onError?("Digite uma tarefa para ser adicionada!")
            return
        }

        // 1) Monta um timeString "HH:mm" apenas se houver horário
        let timeString = DateFormatHelper.formatTime(shouldSchedule: shouldSchedule, date: selectedDate)
        let hasTime = (shouldSchedule && timeString.isEmpty == false)

        // 2) Define o DIA base: se vier uma data, usamos ela; senão, o "hoje"
        let baseDay = selectedDate ?? Date()

        // 3) DueDate = dia + (opcional) horário
        let dueDate = DateHelper.combine(day: baseDay, timeHM: timeString)

        // 4) Cria no Firestore
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

