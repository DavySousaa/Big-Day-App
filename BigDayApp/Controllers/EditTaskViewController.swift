//
//  EditTaskViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 07/07/25.
//


import UIKit

protocol saveEditProcol: AnyObject {
    func saveEditBt(titleEdit: String, selectedTime: String)
}

class EditTaskViewController: UIViewController {
    
    var editTask = EditTask()
    var taskController: TasksViewController?
    var tasks: [Task] = []
    var delegate: saveEditProcol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editTask
        view.backgroundColor = .clear
        navigationItem.backButtonTitle = ""
        editTask.delegate = self
    }
    
    private func getEditTask() {
        guard let delegate = delegate else {return}
        let editedNickName = editTask.newTaskTextField.text ?? "Nova terefa"
        let selectedTime = getTime()
        
        guard !editTask.newTaskTextField.text!.isEmpty else {
            showAlert(message: "Digite uma tarefa para ser adicionada!")
            return
        }
        
        delegate.saveEditBt(titleEdit: editedNickName, selectedTime: selectedTime)
        self.dismiss(animated: true)
    }
    
    @objc func getTime() -> String {
        
        if !editTask.switchPicker.isOn {
            return ""
        }
        
        let selectedTime = editTask.timePicker.date
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

extension EditTaskViewController: UITextFieldDelegate, EditTaskDelegate {
    func tapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func tapSaveButton() {
        getEditTask()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
