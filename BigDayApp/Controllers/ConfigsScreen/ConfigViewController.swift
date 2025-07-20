//
//  Untitled.swift
//  BigDayApp
//
//  Created by Davy Sousa on 06/07/25.
//

import UIKit
import TOCropViewController
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


class ConfigViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate, UserProfileUpdatable {
    
    var nameUserLabel: UILabel? {nil}
    var imageUserView: UIImageView {configScreen.userPhoto}
    var nicknameProperty: String? {
        get { return nil }
        set { }
    }
    
    var editNickName = EditNickName()
    var configScreen = ConfigScreen()
    var createAccount = CreateAccount()
    var taskController: TasksViewController?
    var configs: [Config] = [
        Config(title: "Editar apelido", iconName: "pencil", action: .editNickname),
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

        updateNickNamePhotoUser()
        placeholderOne()
        navigationSetupWithLogo(title: "Configurações")
        navigationItem.backButtonTitle = "Voltar"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        placeholderTwo()
        updateNickNamePhotoUser()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            navigationSetupWithLogo(title: "Configurações")
        }
    }
    
    //MARK - Funcions
    
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

        // Atualiza a imagem localmente na tela de configurações
        configScreen.userPhoto.image = image
        configScreen.userPhoto.layer.cornerRadius = 60 / 2
        configScreen.userPhoto.clipsToBounds = true
        
        LocalUserDefaults.saveProfileImageData(image)
        
        
        if let user = Auth.auth().currentUser {
            print("✅ Usuário autenticado:", user.uid)
        } else {
            print("❌ Usuário NÃO autenticado")
        }

        
        // Faz o upload da imagem pro Firebase Storage
        StorageSupport.shared.uploadProfileImageToFirebase(image) { success, downloadURL in
            guard success, let url = downloadURL else {
                print("❌ Falha no upload ou sem URL.")
                return
            }

            // Salva a URL da imagem no Firestore usando o helper
            DatabaseSupport.shared.savePhotoURL(url) { saveSuccess in
                if saveSuccess {
                    print("✅ Foto salva no banco!")

                    // Atualiza a imagem do usuário na TasksViewController, se ela estiver na stack
                    if let tasksVC = self.navigationController?.viewControllers.first(where: { $0 is TasksViewController }) as? TasksViewController {
                        tasksVC.updateNickNamePhotoUser()
                    }

                } else {
                    print("⚠️ Foto enviada mas não salva no banco.")
                }
            }
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

            // limpa dados locais
            UserDefaults.standard.removeObject(forKey: "nickname")
            UserDefaults.standard.removeObject(forKey: "photoURL")

            // limpa imagem da tela (se necessário)
            configScreen.userPhoto.image = nil

            let loginVC = FirstScreenViewController()
            let navVC = UINavigationController(rootViewController: loginVC)

            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = navVC
            }
        } catch let error {
            print("❌ Erro ao deslogar: \(error.localizedDescription)")
        }
    }
    
    func didTapFeedback() {
        if let url = URL(string: "https://apps.apple.com/app/id497799835?action=write-review") {
            UIApplication.shared.open(url)
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
            case .openNotifications:
                navigationController?.pushViewController(NotificationsViewController(), animated: true)
            case .sendFeedback:
                didTapFeedback()
            case .showAbout:
                navigationController?.pushViewController(AboutAppViewController(), animated: true)
            case .logout:
                showAlertConfirmation()
            }
        }
    }
}
