import Foundation
import FirebaseFirestore

final class EditTaskViewModel {

    // A tarefa que será editada (preenchida antes de apresentar a tela)
    var taskToEdit: Task?

    // Callbacks p/ feedback na UI
    var onSucess: (() -> Void)?
    var onError: ((String) -> Void)?

    // Repo
    private let repo = TaskRepository.shared

    /// Salva a edição no Firestore
    /// - Parameters:
    ///   - title: novo título
    ///   - shouldSchedule: se o switch de horário está ligado
    ///   - selectedDate: caso shouldSchedule seja true, vem a data do timePicker (usaremos SÓ a hora)
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

        // Monta timeString "HH:mm" somente se o switch estiver ligado
        var timeString: String? = nil
        if shouldSchedule, let selectedDate {
            let f = DateFormatter()
            f.locale = Locale(identifier: "pt_BR")
            f.timeZone = DateHelper.tz
            f.dateFormat = "HH:mm"
            timeString = f.string(from: selectedDate)
        }

        // Mantemos o DIA da tarefa (não há UI para trocar o dia aqui)
        let baseDay = task.dueDate
        let newDue = DateHelper.combine(day: baseDay, timeHM: timeString)

        // Monta payload
        var payload: [String: Any] = [
            "title": trimmed,
            // Pode mandar Date que o SDK converte p/ Timestamp automaticamente
            "dueDate": newDue
        ]

        if let timeString {
            payload["time"] = timeString
            payload["hasTime"] = true
        } else {
            payload["time"] = FieldValue.delete() // apaga o campo no Firestore
            payload["hasTime"] = false
        }

        // Atualiza no Firestore
        repo.update(id: id, fields: payload) { [weak self] err in
            if let err = err {
                self?.onError?("Erro ao atualizar: \(err.localizedDescription)")
            } else {
                // Atualiza o modelo local (opcional, só por consistência)
                task.title = trimmed
                task.time = timeString
                task.dueDate = newDue
                self?.taskToEdit = task

                self?.onSucess?()
            }
        }
    }
}

