import Foundation

final class TaskViewModel {
    
    var nameTask: String = ""
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func validateTask() {
        if nameTask.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            onError?("Dê um nome para sua tarefa.")
        } else {
            onSuccess?()
        }
    }
}
