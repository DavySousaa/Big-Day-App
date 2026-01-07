//
//  ShareTasksViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 08/07/25.
//
import UIKit
import NotificationBannerSwift

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
    var currentColor: UIColor = .label
    var viewModel = TaskShareViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = shareScreen
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationController?.navigationBar.tintColor = .label
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareScreen.infoShareButton)
        
        shareScreen.delegate = self
        shareScreen.tasksTableView.tintColor = .white
        shareScreen.tasksTableView.backgroundColor = .clear
        shareScreen.tasksTableView.register(TaskCellShare.self, forCellReuseIdentifier: TaskCellShare.identifier)
        shareScreen.tasksTableView.delegate = self
        shareScreen.tasksTableView.dataSource = self
        
        viewModel.tasksChanged = { [weak self] in
            self?.shareScreen.tasksTableView.reloadData()
        }
        viewModel.onSucess = { [weak self] in
            self?.shareScreen.tasksTableView.reloadData()
        }
        viewModel.onError = { msg in
            print("❌", msg)
        }
        
        if let saved = SelectedDateStore.load() {
            viewModel.updateSelectedDate(saved)
        } else {
            viewModel.updateSelectedDate(Date()) // hoje
            
        }
        shareScreen.dayLabel.text = DateHelper.dayTitle(from: viewModel.selectedDate)
        viewModel.bind()
        
        navigationSetupWithLogo(title: "Compartilhar tarefas")
        updateNickNamePhotoUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let saved = SelectedDateStore.load() {
            viewModel.updateSelectedDate(saved)
        } else {
            viewModel.updateSelectedDate(Date()) // hoje
            
        }
        shareScreen.dayLabel.text = DateHelper.dayTitle(from: viewModel.selectedDate)
        viewModel.bind()
        updateNickNamePhotoUser()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            navigationSetupWithLogo(title: "Compartilhar tarefas")
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
            
        }
    }
    
}

extension ShareTasksViewController: TapButtonShareDelete {
    
    func didTapInfoButton() {
        showAlert(title: "Como compartilhar?", message: "Ao clicar em copiar, a imagem fica salva no copia/cola do texto. Então basta colar onde queira colocar o screenshot.")
    }
    
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
    
    func didTapCopyPhotoBtn() {
        let imageHelper = RenderImageHelper()
        guard let image = imageHelper.createShareImage(
            from: shareScreen.containerView,
            tableView: shareScreen.tasksTableView
        ) else { return }
        
        let banner = NotificationBanner(title: "Sucesso!", subtitle: "Imagem copiada para área de transferência.", style: .success)
        banner.duration = 2
        banner.show()
        UIPasteboard.general.image = image
    }
    
    func didTapCopyShadowBtn() {
        let imageHelper = RenderImageHelper()
        imageHelper.copyImageFromAssets(named: "Shadow")
        let banner = NotificationBanner(title: "Sucesso!", subtitle: "Imagem copiada para área de transferência.", style: .success)
        banner.duration = 2
        banner.show()
    }
}
