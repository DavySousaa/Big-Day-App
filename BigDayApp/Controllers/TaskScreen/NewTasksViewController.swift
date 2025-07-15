
import UIKit

class NewTasksViewController: UIViewController {
    
    var newTask = NewTask()
    var taskController: TasksViewController?
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = newTask
        view.backgroundColor = .clear
        navigationItem.backButtonTitle = ""
        newTask.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func createTask() {
        var list:[Task] = TaskSuportHelper().getTask()
        let selectedTime = getTime()
        
        guard !newTask.newTaskTextField.text!.isEmpty else {
            showAlert(message: "Digite uma tarefa para ser adicionada!")
            return
        }
        var task: Task = Task(id: UUID(), title: newTask.newTaskTextField.text ?? "Nova tarefa", time: selectedTime, isCompleted: false)
        
        list.append(task)
        TaskSuportHelper().addTask(lista: list)
        
        self.tasks = list
        taskController?.tasks = self.tasks
        taskController?.taskScreen.tasksTableView.reloadData()

        self.dismiss(animated: true)
    }
    
    @objc func getTime() -> String {
        
        if !newTask.switchPicker.isOn {
            return ""
        }
        
        let selectedTime = newTask.timePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let timeString = formatter.string(from: selectedTime)
        return timeString
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Atenção", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

extension NewTasksViewController: UITextFieldDelegate, NewTaskDelegate {
    func tapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func tapCreateButton() {
        createTask()
    }
    
}
