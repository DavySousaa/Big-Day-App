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
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = ColorSuport.blackApp
        
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
        loadTasks()
    }
    
    private func setupNavgatioBar() {
        navigationController?.navigationBar.tintColor = ColorSuport.blackApp
        navigationItem.title = "Compartilhar Tarefas"
    }
    
    func updateNickNamePhotoUser() {
        nickname = UserDefaults.standard.string(forKey: "nickname") ?? "Usuário"
        if let savedImageData = UserDefaults.standard.data(forKey: "profileImageView"),
           let savedImage = UIImage(data: savedImageData) {
            shareScreen.imageUser.image = savedImage
        }
    }

    func updateNickName() {
        shareScreen.nameUserLabel.text = nickname
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
        let backgroundImage = shareScreen.containerView.subviews.first(where: { $0 is UIImageView })
        backgroundImage?.isHidden = true
        shareScreen.containerView.layoutIfNeeded()
        let image = renderViewAsImage(view: shareScreen.containerView)
        backgroundImage?.isHidden = false
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
                    .foregroundColor: UIColor.white
                ]
            )
            cell.titleLabel.attributedText = attributedText
        } else {
            cell.circleImage.image = UIImage(systemName: "circle")
            let attributedText = NSAttributedString(
                string: task.title,
                attributes: [
                    .strikethroughStyle: 0,
                    .foregroundColor: UIColor.white
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
    func didTapStoryBtn() {
        guard let image = createShareImage(),
              let urlScheme = URL(string: "instagram-stories://share"),
              UIApplication.shared.canOpenURL(urlScheme) else {
            print("Instagram não disponível.")
            return
        }
        
        let pasteboardItems: [String: Any] = [
            "com.instagram.sharedSticker.backgroundImage": image
        ]
        let pasteboardOptions = [
            UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
        ]
        
        UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
        UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
    }
    
    func didTapSaveBtn() {
        guard let image = createShareImage() else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    func didTapCopyBtn() {
        guard let image = createShareImage() else { return }
        UIPasteboard.general.image = image
    }
}
