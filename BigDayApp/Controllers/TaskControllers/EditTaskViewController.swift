import UIKit
import FirebaseFirestore

protocol saveEditProcol: AnyObject {
    func saveEditBt(titleEdit: String, selectedTime: String)
}

class EditTaskViewController: UIViewController, UITextFieldDelegate {
    
    var editTask = EditTask()
    var taskController: TasksViewController?
    var tasks: [Task] = []
    var delegate: saveEditProcol?
    var viewModel = EditTaskViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editTask
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationItem.backButtonTitle = ""
        editTask.delegate = self
        editTask.newTaskTextField.delegate = self
        fillTaskIfNeeded()
        bindViewModel()
        buttonChangePosition()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func bindViewModel() {
        viewModel.onSucess = { [weak self] in
            self?.dismiss(animated: true)
        }
        viewModel.onError = { [weak self] message in
            self?.showAlert(message: message)
        }
    }
    
    func fillTaskIfNeeded() {
        guard let task = viewModel.taskToEdit else { return }
        editTask.newTaskTextField.text = task.title
        
        if let timeString = task.time, !timeString.isEmpty {
            editTask.switchPicker.isOn = true
            // Converte timeString ("HH:mm") para Date
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            if let date = formatter.date(from: timeString) {
                editTask.timePicker.date = date
            }
        } else {
            editTask.switchPicker.isOn = false
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Atenção", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    func buttonChangePosition() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height

        UIView.animate(withDuration: 0.3) {
            let bottomInset = self.view.safeAreaInsets.bottom
            self.editTask.saveButtonBottomConstraint.constant = -keyboardHeight + bottomInset - 10
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.editTask.saveButtonBottomConstraint.constant = -10
            self.view.layoutIfNeeded()
        }
    }
 
}

extension EditTaskViewController: EditTaskDelegate {
    func tapSaveButton() {
        let title = editTask.newTaskTextField.text ?? ""
        let shouldSchedule = editTask.switchPicker.isOn
        let selectedDate = shouldSchedule ? editTask.timePicker.date : nil
        
        viewModel.saveEditTask(title: title, shouldSchedule: shouldSchedule, selectedDate: selectedDate)
    }
    
    
}
