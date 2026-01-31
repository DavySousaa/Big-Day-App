import UIKit
import UserNotifications

class NewTasksViewController: UIViewController, UITextFieldDelegate {

    var newTask = NewTask()
    weak var taskController: TasksViewController?
    private let viewModel = NewTaskViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = newTask
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationItem.backButtonTitle = ""
        newTask.delegate = self
        newTask.newTaskTextField.delegate = self
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
    

    private func bindViewModel() {
        viewModel.onSucess = { [weak self] in
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
            self.newTask.saveButtonBottomConstraint.constant = -keyboardHeight + bottomInset - 10
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.newTask.saveButtonBottomConstraint.constant = -10
            self.view.layoutIfNeeded()
        }
    }
    
   
}

extension NewTasksViewController: NewTaskDelegate {
    func tapCreateButton() {
        let title = newTask.newTaskTextField.text ?? ""
        let shouldSchedule = newTask.switchPicker.isOn

        let baseDay = taskController?.viewModel.selectedDate ?? Date()

        let timeString: String? = {
            guard shouldSchedule else { return nil }
            let f = DateFormatter()
            f.locale = Locale(identifier: "pt_BR")
            f.timeZone = DateHelper.tz
            f.dateFormat = "HH:mm"
            return f.string(from: newTask.timePicker.date)
        }()

        viewModel.createTask(title: title, timeString: timeString, baseDay: baseDay)
    }
}
