//
//  TasksViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 02/06/25.
//

import UIKit
import FirebaseAuth
import UserNotifications
import FirebaseFirestore


class TasksViewController: UIViewController, UITextFieldDelegate, UserProfileUpdatable {
    
    var selectedTaskID: UUID?
    var taskScreen = TaskScreen()
    var tasks: [Task] = []
    var nickname = ""
    var nicknameProperty: String? {
        get { return nickname }
        set { nickname = newValue ?? "" }
    }
    
    var nameUserLabel: UILabel? {
        return taskScreen.nameUserLabel
    }
    
    var imageUserView: UIImageView {
        return taskScreen.imageUser
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = taskScreen
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationItem.hidesBackButton = true
        
        taskScreen.delegate = self
        taskScreen.tasksTableView.tintColor = .white
        
        taskScreen.tasksTableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        taskScreen.tasksTableView.delegate = self
        taskScreen.tasksTableView.dataSource = self
        
        updateNickNamePhotoUser()
        navigationSetupWithLogo(title: "Tarefas")
        
        
        let manager = NotificationManager()
        manager.scheduleDailyMorningNotification()
        manager.scheduleDailyNightNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTasks()
        updateNickNamePhotoUser()
        navigationSetupWithLogo(title: "Tarefas")
        showNotificationPermition()
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            navigationSetupWithLogo(title: "Tarefas")
        }
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
    
    func showNotificationPermition() {
        let aceptedNotifications = UserDefaults.standard.bool(forKey: "aceptedNotifications")
        guard !aceptedNotifications else { return }
        
        let alert = UIAlertController(title: "Ativar notificações?", message: "Com as notificações ativadas, o Big Day te ajuda a manter o ritmo e a motivação. Tudo no tempo certo. ⏰✨", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Agora não", style: .cancel))
        alert.addAction(UIAlertAction(title: "Ativar", style: .default) { _ in
            self.pedirPermissaoNotificacao()
            UserDefaults.standard.set(true, forKey: "aceptedNotifications")
        })
        present(alert, animated: true)
    }
    
    func pedirPermissaoNotificacao() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("✅ Permissão concedida")
                } else {
                    print("❌ Usuário recusou")
                }
                
                if let error = error {
                    print("Erro: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func editButton() {
        guard let id = selectedTaskID,
                  let task = tasks.first(where: { $0.id == id }) else { return }
        let sheetVC = EditTaskViewController()
        sheetVC.delegate = self
        sheetVC.taskController = self
        sheetVC.modalPresentationStyle = .overFullScreen
        sheetVC.editTask.newTaskTextField.text = task.title
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
        let editIcon = UIImage(systemName: "square.and.pencil")?.withTintColor(ColorSuport.greenApp, renderingMode: .alwaysOriginal)
        editAction.image = editIcon
        editAction.backgroundColor = .label
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

extension TasksViewController: TapButtonDelete {
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
