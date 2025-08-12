import UIKit
import UserNotifications

class NewTasksViewController: UIViewController, UITextFieldDelegate {

    var newTask = NewTask()
    weak var taskController: TasksViewController?
    private let viewModel = NewTaskViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = newTask
        view.backgroundColor = .clear
        navigationItem.backButtonTitle = ""
        newTask.delegate = self
        newTask.newTaskTextField.delegate = self
        bindViewModel()
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
}

extension NewTasksViewController: NewTaskDelegate {
    func tapCancelButton() {
        dismiss(animated: true, completion: nil)
    }

    func tapCreateButton() {
        let title = newTask.newTaskTextField.text ?? ""
        let shouldSchedule = newTask.switchPicker.isOn

        // Dia base vem da tela principal (o dia que o usuário escolheu no calendário)
        let baseDay = taskController?.viewModel.selectedDate ?? Date()

        // Se tiver horário ligado, gera "HH:mm"; senão, deixa nil
        let timeString: String? = {
            guard shouldSchedule else { return nil }
            let f = DateFormatter()
            f.locale = Locale(identifier: "pt_BR")
            f.timeZone = DateHelper.tz
            f.dateFormat = "HH:mm"
            return f.string(from: newTask.timePicker.date)
        }()

        // Chama a sobrecarga alinhada com Firestore
        viewModel.createTask(title: title, timeString: timeString, baseDay: baseDay)
    }
}

