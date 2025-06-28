//
//  TasksViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 02/06/25.
//

import UIKit
import FirebaseAuth

class TasksViewController: UIViewController, UITextFieldDelegate, CreateTaskDelete {
    
    func didTapCreate() {
        let sheetVC = NewTasksViewController()
        sheetVC.modalPresentationStyle = .overFullScreen
        present(sheetVC, animated: true)
    }
    var selectedTaskID: UUID?
    var taskScreen = TaskScreen()
    private var tasks: [Task] = [
        Task(id: UUID(), title: "Estudar Swift", time: "09:00"),
        Task(id: UUID(), title: "Ir à academia", time: "17:00"),
        Task(id: UUID(), title: "Fazer café", time: "07:30")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = taskScreen
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        taskScreen.delegate = self
        
        taskScreen.tasksTableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        taskScreen.tasksTableView.delegate = self
        taskScreen.tasksTableView.dataSource = self
    }
    
    private func redirectToLogin() {
        let loginVC = FirstScreenViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navController
        }
    }
    
    func saveTasks() {
        TaskSuportHelper().addTask(lista: tasks)
    }
}

extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        let task = tasks[indexPath.row]
        cell.configure(with: task)
        cell.backgroundColor = .white
        
        if task.isCompleted {
            cell.circleImage.image = UIImage(systemName: "checkmark.circle.fill")
            
            let attributedText = NSAttributedString(
                string: task.title,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.darkGray
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
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedTask = tasks.remove(at: sourceIndexPath.row)
        tasks.insert(movedTask, at: destinationIndexPath.row)
        saveTasks()
    }
}

extension TasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TaskCell {
            tasks[indexPath.row].isCompleted.toggle()
            saveTasks()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.tasks.remove(at: indexPath.row)
            TaskSuportHelper().addTask(lista: self.tasks)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Editar") { (action, view, completionHandler) in
            let task = self.tasks[indexPath.row]
            self.selectedTaskID = task.id
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        editAction.image = UIImage(systemName: "square.and.pencil")
        editAction.backgroundColor = .black
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}



