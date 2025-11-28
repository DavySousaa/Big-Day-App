import UIKit
import UserNotifications

class NewTasksViewController: UIViewController, UITextFieldDelegate {
    var newTask = NewTask()
    weak var taskController: TasksViewController?
    private let viewModel = NewTaskViewModel()
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
        self.view = newTask
        navigationController?.navigationBar.tintColor = .label
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationItem.backButtonTitle = "Voltar"
        newTask.delegate = self
        newTask.newTaskTextField.delegate = self
        bindViewModel()
        
        newTask.repeatCollectionView.delegate = self
        newTask.repeatCollectionView.dataSource = self
        newTask.repeatCollectionView.register(RepeatDayCell.self, forCellWithReuseIdentifier: RepeatDayCell.identifier)
        newTask.repeatCollectionView.allowsMultipleSelection = true
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
            self?.navigationController?.popViewController(animated: true)
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

extension NewTasksViewController: UICollectionViewDelegate {
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

extension NewTasksViewController: UICollectionViewDataSource {
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

extension NewTasksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 4
        let spacing: CGFloat = 8
        
        let totalSpacing = (itemsPerRow - 1) * spacing
        let contentWidth = collectionView.bounds.width - totalSpacing
        
        let width = floor(contentWidth / itemsPerRow)
        return CGSize(width: width, height: 40)
    }
}
