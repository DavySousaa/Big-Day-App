
import UIKit
import UserNotifications

class NewTasksViewController: UIViewController, UITextFieldDelegate {
    
    var newTask = NewTask()
    var taskController: TasksViewController?
    var tasks: [Task] = []
    var viewModel = NewTaskViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = newTask
        view.backgroundColor = .clear
        navigationItem.backButtonTitle = ""
        newTask.delegate = self
        newTask.newTaskTextField.delegate = self
        blindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func blindViewModel() {
        
        viewModel.onSucess = { [weak self] in
            self?.taskController?.viewModel.loadTasks()
            self?.dismiss(animated: true)
        }
        viewModel.onError = { [weak self] message in
            self?.showAlert(message: message)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Atenção", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

extension NewTasksViewController: NewTaskDelegate {
    func tapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func tapCreateButton() {
        let title = newTask.newTaskTextField.text ?? ""
        let shouldSchedule = newTask.switchPicker.isOn
        let selectedDate = shouldSchedule ? newTask.timePicker.date : nil
        
        viewModel.createTask(title: title, shouldSchedule: shouldSchedule, selectedDate: selectedDate)
    }
}

