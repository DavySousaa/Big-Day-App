//
//  ShareTasksViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 08/07/25.
//
import UIKit

class ShareTasksViewController: UIViewController {
    
    var shareScreen = ShareScreen()
    var nickname = ""
    var tasks: [Task] = []
    var selectedTaskID: UUID?
    
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
        
        setupNavgatioBar()
        updateNickNamePhotoUser()
        updateNickName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedImageData = UserDefaults.standard.data(forKey: "profileImageView"),
           let savedImage = UIImage(data: savedImageData) {
            shareScreen.imageUser.image = savedImage
        }
        updateNickNamePhotoUser()
        updateNickName()
        loadTasks()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            setupNavgatioBar()
        }
    }
    
    func updateNickNamePhotoUser() {
        nickname = UserDefaults.standard.string(forKey: "nickname") ?? "Usuário"
        if let savedImageData = UserDefaults.standard.data(forKey: "profileImageView"),
           let savedImage = UIImage(data: savedImageData) {
            shareScreen.imageUser.image = savedImage
        }
    }

    func updateNickName() {
        nickname = UserDefaults.standard.string(forKey: "nickname") ?? "Usuário"
        shareScreen.nameUserLabel.text = nickname
    }
    
    
    private func setupNavgatioBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = "Compartilhar Tarefas"
        let logoImage = traitCollection.userInterfaceStyle == .dark
            ? UIImage(named: "logo2")
            : UIImage(named: "logo1")
        
        let imageView = UIImageView(image: logoImage)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        imageView.frame = logoContainer.bounds
        logoContainer.addSubview(imageView)
        
        let logoItem = UIBarButtonItem(customView: logoContainer)
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 14
        
        navigationItem.leftBarButtonItems = [spacer, logoItem]
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
        let backgroundImage = shareScreen.backgroundContainerView
        backgroundImage.isHidden = true
        shareScreen.containerView.layoutIfNeeded()
        let image = renderViewAsImage(view: shareScreen.containerView)
        backgroundImage.isHidden = false
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
        
    }
    
    func didTapBlackColor() {
        <#code#>
    }
    
    func didTapCopyBtn() {
        guard let image = createShareImage() else { return }
        UIPasteboard.general.image = image
    }
}
