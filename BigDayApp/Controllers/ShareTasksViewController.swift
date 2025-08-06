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
    var selectedTaskID: UUID?
    var currentColor: UIColor = .white
    var viewModel = TaskShareViewModel()
    
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
        bindViewModel()
        viewModel.loadTasks()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            navigationSetupWithLogo(title: "Compartilhar tarefas")
        }
    }
    
    func bindViewModel() {
        viewModel.onSucess = {[weak self] in
            self?.shareScreen.tasksTableView.reloadData()
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ShareTasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCellShare.identifier, for: indexPath) as? TaskCellShare else {
            return UITableViewCell()
        }
        let task = viewModel.tasks[indexPath.row]
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
        if let cell = tableView.cellForRow(at: indexPath) as? TaskCellShare {
            viewModel.toggleTask(at: indexPath.row)
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
        let imageHelper = RenderImageHelper()
        guard let image = imageHelper.createShareImage(
            from: shareScreen.containerView,
            tableView: shareScreen.tasksTableView
        ) else { return }
        showAlert(title: "Sucesso", message: "Imagem copiada para área de transferência.")
        UIPasteboard.general.image = image
    }
}
