import UIKit
import Foundation

class DetailsTaskController: UIViewController {
    
    var detailTask = DetailsTask()
    var taskController: TasksViewController!
    var viewModel = DetailViewModel()
    
    var subTasks: [SubTask] = [
        SubTask(title: "Tarefa um", isCompleted: false),
        SubTask(title: "Tarefa dois", isCompleted: false),
        SubTask(title: "Tarefa três", isCompleted: false),
        SubTask(title: "Tarefa quatro", isCompleted: false),
        SubTask(title: "Tarefa cinco", isCompleted: false),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = detailTask
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationSetup(title: "Detalhes")
        navigationItem.backButtonTitle = "Voltar"
        detailTask.subTasksTableView.register(SubTaskCell.self, forCellReuseIdentifier: SubTaskCell.identifier)
        detailTask.subTasksTableView.delegate = self
        detailTask.subTasksTableView.dataSource = self
        
        updateUI()
    }
    
    func updateUI() {
        guard let task = viewModel.task else { return }
        detailTask.titleTask.text = task.title
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension DetailsTaskController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SubTaskCell {
            subTasks[indexPath.row].isCompleted.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
            let task = self.subTasks[indexPath.row]
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension DetailsTaskController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubTaskCell.identifier, for: indexPath) as? SubTaskCell else {
            return UITableViewCell()
        }
        let task = subTasks[indexPath.row]
        cell.configure(with: task)
        cell.backgroundColor = UIColor(named: "PrimaryColor")
        
        if task.isCompleted {
            cell.circleImage.image = UIImage(systemName: "checkmark.circle.fill")
            let attributedText = NSAttributedString(
                string: task.title,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.label
                ]
            )
            cell.titleLabel.attributedText = attributedText
        } else {
            cell.circleImage.image = UIImage(systemName: "circle")
            
            let attributedText = NSAttributedString(
                string: task.title,
                attributes: [
                    .strikethroughStyle: 0,
                    .foregroundColor: UIColor.label
                ]
            )
            cell.titleLabel.attributedText = attributedText
        }
        return cell
    }
}
