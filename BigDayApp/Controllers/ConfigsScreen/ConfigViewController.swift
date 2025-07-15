//
//  Untitled.swift
//  BigDayApp
//
//  Created by Davy Sousa on 06/07/25.
//

import UIKit
import TOCropViewController
import FirebaseAuth

class ConfigViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate {
    
    var editNickName = EditNickName()
    var configScreen = ConfigScreen()
    var createAccount = CreateAccount()
    var taskController: TasksViewController?
    var configs: [Config] = [
        Config(title: "Editar apelido", iconName: "pencil", action: .editNickname),
        Config(title: "Alterar senha", iconName: "lock.rotation", action: .changePassword),
        Config(title: "Notificações", iconName: "bell.badge", action: .openNotifications),
        Config(title: "Feedback", iconName: "bubble.left.and.bubble.right", action: .sendFeedback),
        Config(title: "Sobre o app", iconName: "info.circle", action: .showAbout),
        Config(title: "Sair da conta", iconName: "rectangle.portrait.and.arrow.right", action: .logout)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = configScreen
        configScreen.configViewController = self
        configScreen.updateTableHeight(rows: configs.count)
        configScreen.configTableView.rowHeight = 60
        
        configScreen.delegate = self
        view.backgroundColor = UIColor(named: "PrimaryColor")
        
        configScreen.configTableView.tintColor = .white
        
        configScreen.configTableView.register(ConfigCell.self, forCellReuseIdentifier: ConfigCell.identifier)
        configScreen.configTableView.delegate = self
        configScreen.configTableView.dataSource = self
        configScreen.configTableView.isScrollEnabled = false

        updateUserPhoto()
        placeholderOne()
        setupNavgatioBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        placeholderTwo()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            setupNavgatioBar()
        }
    }
    
    //MARK - Funcions
    
    func updateUserPhoto() {
        if let savedImageData = UserDefaults.standard.data(forKey: "profileImageView"),
           let savedImage = UIImage(data: savedImageData) {
            configScreen.userPhoto.image = savedImage
            configScreen.userPhoto.layer.cornerRadius = 100 / 2
            configScreen.userPhoto.clipsToBounds = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Método para abrir a galeria
    func loadPhoto(for imageView: UIImageView) {
        self.configScreen.userPhoto = imageView
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    
    // Quando o usuário seleciona a imagem
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            dismiss(animated: true) {
                self.showCropViewController(image: selectedImage)
            }
        }
    }
    
    // Se o usuário cancelar
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Abrindo a tela de recorte
    func showCropViewController(image: UIImage) {
        let cropViewController = TOCropViewController(croppingStyle: .circular, image: image)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }
    
    // Quando o usuário termina de recortar a imagem
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        configScreen.userPhoto.image = image
        configScreen.userPhoto.layer.cornerRadius = configScreen.userPhoto.frame.size.width / 2
        configScreen.userPhoto.clipsToBounds = true
        
        if let data = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(data, forKey: "profileImageView")
        }
        
        if let tasksVC = navigationController?.viewControllers.first(where: { $0 is TasksViewController }) as? TasksViewController {
            tasksVC.updateNickNamePhotoUser()
            tasksVC.updateNickName()
        }
        
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    // Se o usuário cancelar o recorte
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    func placeholderOne() {
        if let vc = self.navigationController?.viewControllers.first(where: { $0 is CreateAccountViewController }) as? CreateAccount {
            createAccount.nickNameTextField.placeholder = vc.nickNameTextField.text
        }
    }
    
    func placeholderTwo() {
        if let vc = self.navigationController?.viewControllers.first(where: { $0 is TasksViewController }) as? TaskScreen {
            createAccount.nickNameTextField.placeholder = vc.nameUserLabel.text
        }
    }
    
    private func setupNavgatioBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = "Configurações"
        navigationItem.backButtonTitle = "Voltar"
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
    
    private func showAlertConfirmation() {
        let alert = UIAlertController(title: "Tem Certeza?", message: "Você realmente deseja sair da sua conta?", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancelar", style: .cancel)
        let confirmButton = UIAlertAction(title: "Sim", style: .destructive) { _ in
            self.tapLogoutButton()
        }
        
        alert.addAction(cancelButton)
        alert.addAction(confirmButton)
        present(alert, animated: true)
    }
    
    func tapLogoutButton() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "nickname")
            UserDefaults.standard.removeObject(forKey: "profileImageView")
            
            let loginVC = FirstScreenViewController()
            let navVC = UINavigationController(rootViewController: loginVC)
            
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = navVC
            }
        } catch let error {
            print("Erro ao deslogar: \(error.localizedDescription)")
        }
    }
}


extension ConfigViewController: tapButtonConfigDelete {
    func didTapEditPhoto() {
        self.loadPhoto(for: configScreen.userPhoto)
    }
}

extension ConfigViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConfigCell.identifier, for: indexPath) as? ConfigCell else {
            return UITableViewCell()
        }
        let config = configs[indexPath.row]
        cell.configure(with: config)
        cell.backgroundColor = .secondarySystemGroupedBackground
        
        return cell
    }
}

extension ConfigViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ConfigCell {
            let config = configs[indexPath.row]
            
            switch config.action {
            case .editNickname:
                let editVC = EditNicknameViewController()
                editVC.tasksVC = self.taskController
                navigationController?.pushViewController(editVC, animated: true)
            case .changePassword:
                navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
            case .openNotifications:
                navigationController?.pushViewController(NotificationsViewController(), animated: true)
            case .sendFeedback:
                navigationController?.pushViewController(FeedbackViewController(), animated: true)
            case .showAbout:
                navigationController?.pushViewController(AboutViewController(), animated: true)
            case .logout:
                showAlertConfirmation()
            }
        }
    }
}
