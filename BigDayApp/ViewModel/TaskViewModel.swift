import Foundation

final class TaskViewModel {
    
    var nameTask: String = ""
    var onSucess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private(set) var tasks: [Task] = [] {
        didSet {
            tasksChanged?()
        }
    }
    
    var tasksChanged: (() -> Void)?
    
    func moveTask(from sourceIndex: Int, to destinationIndex: Int) {
        let movedTask = tasks.remove(at: sourceIndex)
        tasks.insert(movedTask, at: destinationIndex)
        saveTasks()
    }
    
    func validateTask() {
        if nameTask.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            onError?("Dê um nome para sua tarefa.")
        } else {
            onSucess?()
        }
    }
    
    func loadTasks() {
        self.tasks = TaskSuportHelper().getTask()
        self.onSucess?()
    }
    
    func saveTasks() {
        TaskSuportHelper().addTask(lista: tasks)
    }
    
    func toggleTask(at index: Int) {
        tasks[index].isCompleted.toggle()
        saveTasks()
    }
    
    func deleteTask(at index: Int) {
        tasks.remove(at: index)
        saveTasks()
    }
    
    func updateTask(id: UUID, title: String, time: String) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].title = title
            tasks[index].time = time
            saveTasks()
        }
    }
}
