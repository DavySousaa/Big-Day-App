//
//  TasksViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 02/06/25.
//

import UIKit
import FirebaseAuth

class TasksViewController: UIViewController, UITextFieldDelegate {
    
    var selectedTaskID: UUID?
    var taskScreen = TaskScreen()
    var tasks: [Task] = []
    var nickname = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = taskScreen
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        taskScreen.delegate = self
        taskScreen.tasksTableView.tintColor = .white
        taskScreen.tasksTableView.backgroundColor = .white
        
        taskScreen.tasksTableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        taskScreen.tasksTableView.delegate = self
        taskScreen.tasksTableView.dataSource = self
        
        nickname = UserDefaults.standard.string(forKey: "nickname") ?? "Usuário"
        if let savedImageData = UserDefaults.standard.data(forKey: "profileImageView"),
            let savedImage = UIImage(data: savedImageData) {
            taskScreen.imageUser.image = savedImage
        }
        
        setupNavgatioBar()
        updateNickName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedImageData = UserDefaults.standard.data(forKey: "profileImageView"),
            let savedImage = UIImage(data: savedImageData) {
            taskScreen.imageUser.image = savedImage
        }
        loadTasks()
    }
    
    func updateNickName() {
        taskScreen.nameUserLabel.text = nickname
    }
    
    func loadTasks() {
        self.tasks = TaskSuportHelper().getTask()
        self.taskScreen.tasksTableView.reloadData()
    }
    
    func saveTasks() {
        TaskSuportHelper().addTask(lista: tasks)
    }
    
    private func redirectToLogin() {
        let loginVC = FirstScreenViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navController
        }
    }
    
    private func setupNavgatioBar() {
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .white
        
        let image = UIImage(named: "logo1")
        let imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        imageView.frame = logoContainer.bounds
        logoContainer.addSubview(imageView)
        
        let logoItem = UIBarButtonItem(customView: logoContainer)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 14
        
        let customButton = taskScreen.configButton
        customButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let barButtonItem = UIBarButtonItem(customView: customButton)
        navigationItem.rightBarButtonItem = barButtonItem
        
        navigationItem.leftBarButtonItems = [spacer, logoItem]
    }
    
    func editButton() {
        let sheetVC = EditTaskViewController()
        sheetVC.delegate = self
        sheetVC.taskController = self
        sheetVC.modalPresentationStyle = .overFullScreen
        present(sheetVC, animated: true)
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
                    .foregroundColor: ColorSuport.blackApp
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
            self.selectedTaskID = self.tasks[indexPath.row].id
            self.editButton()
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        editAction.image = UIImage(systemName: "square.and.pencil")
        editAction.backgroundColor = .black
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

extension TasksViewController: TapButtonDelete {
    func didTapConfig() {
        let configVC = ConfigViewController()
        navigationController?.pushViewController(configVC, animated: true)
    }
    
    func didTapCreate() {
        let sheetVC = NewTasksViewController()
        sheetVC.taskController = self
        sheetVC.modalPresentationStyle = .overFullScreen
        present(sheetVC, animated: true)
    }
}

extension TasksViewController: saveEditProcol {
    func saveEditBt(titleEdit: String, selectedTime: String) {
        guard let id = selectedTaskID else {return}
        if let index = tasks.firstIndex(where: { $0.id == id}) {
            tasks[index].title = titleEdit
            tasks[index].time = selectedTime ?? ""
            saveTasks()
            taskScreen.tasksTableView.reloadData()
        }
    }
}
