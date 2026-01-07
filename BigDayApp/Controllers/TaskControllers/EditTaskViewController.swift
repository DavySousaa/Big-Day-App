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
    private var repeatOptions: [RepeatOption] = [
        RepeatOption(title: "não", isSelected: true),
        RepeatOption(title: "seg", isSelected: false),
        RepeatOption(title: "ter", isSelected: false),
        RepeatOption(title: "qua", isSelected: false),
        RepeatOption(title: "qui", isSelected: false),
        RepeatOption(title: "sex", isSelected: false),
        RepeatOption(title: "sáb", isSelected: false),
        RepeatOption(title: "dom", isSelected: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editTask
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationItem.backButtonTitle = "Voltar"
        editTask.delegate = self
        editTask.newTaskTextField.delegate = self
        fillTaskIfNeeded() 
        bindViewModel()
        
        editTask.repeatCollectionView.delegate = self
        editTask.repeatCollectionView.dataSource = self
        editTask.repeatCollectionView.register(RepeatDayCell.self, forCellWithReuseIdentifier: RepeatDayCell.identifier)
        editTask.repeatCollectionView.allowsMultipleSelection = true
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
 
}

extension EditTaskViewController: EditTaskDelegate {
    func tapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func tapSaveButton() {
        let title = editTask.newTaskTextField.text ?? ""
        let shouldSchedule = editTask.switchPicker.isOn
        let selectedDate = shouldSchedule ? editTask.timePicker.date : nil
        
        viewModel.saveEditTask(title: title, shouldSchedule: shouldSchedule, selectedDate: selectedDate)
    }
    
    
}

extension EditTaskViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            // Tocou em "não" → desmarca todos os outros
            for i in 1..<repeatOptions.count {
                repeatOptions[i].isSelected = false
                if let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? RepeatDayCell {
                    cell.isSelected = false
                }
                collectionView.deselectItem(at: IndexPath(item: i, section: 0), animated: false)
            }
            repeatOptions[0].isSelected = true
        } else {
            // Tocou em algum dia → desmarca "não"
            repeatOptions[0].isSelected = false
            collectionView.deselectItem(at: IndexPath(item: 0, section: 0), animated: false)
            if let cellZero = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? RepeatDayCell {
                cellZero.isSelected = false
            }
            
            repeatOptions[indexPath.item].isSelected = true
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? RepeatDayCell {
            cell.isSelected = true
        }
        
        printSelectedDays()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // Só faz sentido pra índice > 0 (“não” é exclusivo)
        if indexPath.item != 0 {
            repeatOptions[indexPath.item].isSelected = false
            
            let anyDaySelected = repeatOptions[1...].contains(where: { $0.isSelected })
            if !anyDaySelected {
                // Se nenhum dia selecionado → volta pro "não"
                repeatOptions[0].isSelected = true
                collectionView.selectItem(at: IndexPath(item: 0, section: 0),
                                          animated: true,
                                          scrollPosition: [])
                
                if let cellZero = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? RepeatDayCell {
                    cellZero.isSelected = true
                }
            }
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? RepeatDayCell {
            cell.isSelected = false
        }
        
        printSelectedDays()
    }
    
    private func printSelectedDays() {
        let selected = repeatOptions
            .enumerated()
            .filter { $0.element.isSelected }
            .map { $0.element.title }
        
        print("Dias selecionados: \(selected)")
    }
}

extension EditTaskViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        repeatOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepeatDayCell.identifier, for: indexPath) as! RepeatDayCell
        let option = repeatOptions[indexPath.item]
        cell.configure(with: option)
        
        return cell
    }
}

extension EditTaskViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 4
        let spacing: CGFloat = 8
        
        let totalSpacing = (itemsPerRow - 1) * spacing
        let contentWidth = collectionView.bounds.width - totalSpacing
        
        let width = floor(contentWidth / itemsPerRow)
        return CGSize(width: width, height: 40)
    }
}
