//
//  ShareTasksViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 08/07/25.
//
import UIKit

class ShareTasksViewController: UIViewController, UserProfileUpdatable {
    
    var nicknameProperty: String? {
        get { return nickname }
        set { nickname = newValue ?? "" }
    }
    
    var nameUserLabel: UILabel? {
        return shareScreen.nameUserLabel
    }
    
    var imageUserView: UIImageView {
        return shareScreen.imageUser
    }
    var shareScreen = ShareScreen()
    var nickname = ""
    var tasks: [Task] = []
    var selectedTaskID: UUID?
    var currentColor: UIColor = .white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = shareScreen
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationController?.navigationBar.tintColor = .label
        
        shareScreen.delegate = self
        shareScreen.tasksTableView.tintColor = .white
        shareScreen.tasksTableView.backgroundColor = .clear
        shareScreen.tasksTableView.register(TaskCellShare.self, forCellReuseIdentifier: TaskCellShare.identifier)
        shareScreen.tasksTableView.delegate = self
        shareScreen.tasksTableView.dataSource = self
        
        navigationSetupWithLogo(title: "Compartilhar tarefas")
        updateNickNamePhotoUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNickNamePhotoUser()
        loadTasks()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            navigationSetupWithLogo(title: "Compartilhar tarefas")
        }
    }
    
    func loadTasks() {
        self.tasks = TaskSuportHelper().getTask()
        self.shareScreen.tasksTableView.reloadData()
    }
    
    func saveTasks() {
        TaskSuportHelper().addTask(lista: tasks)
    }
    
    func renderViewAsImage(view: UIView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        return renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
    
    func createShareImage() -> UIImage? {
        shareScreen.tasksTableView.layoutIfNeeded()
        shareScreen.containerView.backgroundColor = .clear
        shareScreen.containerView.layoutIfNeeded()
        let image = renderViewAsImage(view: shareScreen.containerView)
        shareScreen.containerView.backgroundColor = .secondarySystemBackground
        return image
    }

}

extension ShareTasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCellShare.identifier, for: indexPath) as? TaskCellShare else {
            return UITableViewCell()
        }
        let task = tasks[indexPath.row]
        cell.configure(with: task)
        cell.hourLabel.textColor = currentColor
        
        if task.isCompleted {
            cell.circleImage.image = UIImage(systemName: "checkmark.circle.fill")
            let attributedText = NSAttributedString(
                string: task.title,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: currentColor
                ]
            )
            cell.titleLabel.attributedText = attributedText
        } else {
            cell.circleImage.image = UIImage(systemName: "circle")
            let attributedText = NSAttributedString(
                string: task.title,
                attributes: [
                    .strikethroughStyle: 0,
                    .foregroundColor: currentColor
                ]
            )
            cell.titleLabel.attributedText = attributedText
        }
        return cell
    }
}

extension ShareTasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TaskCell {
            tasks[indexPath.row].isCompleted.toggle()
            saveTasks()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ShareTasksViewController: TapButtonShareDelete {
    func didTapWhiteColor() {
        currentColor = .white
        shareScreen.nameUserLabel.textColor = .white
        shareScreen.dayLabel.textColor = .white
        shareScreen.tasksTableView.reloadData()
    }
    
    func didTapBlackColor() {
        currentColor = .black
        shareScreen.nameUserLabel.textColor = .black
        shareScreen.dayLabel.textColor = .black
        shareScreen.tasksTableView.reloadData()
    }
    
    func didTapCopyBtn() {
        guard let image = createShareImage() else { return }
        UIPasteboard.general.image = image
    }
}
