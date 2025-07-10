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
    
    var configScreen = ConfigScreen()
    var createAccount = CreateAccount()
    var taskController: TasksViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = configScreen
        configScreen.delegate = self
        navigationItem.hidesBackButton = true
        view.backgroundColor = UIColor(named: "PrimaryColor")
        
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
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .white
        let customButton = configScreen.cancelButton
        customButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let barButtonItem = UIBarButtonItem(customView: customButton)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Atenção", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}


extension ConfigViewController: tapButtonConfigDelete {
    
    func didTapCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    func didTapSaveButton() {
        if let vc = self.navigationController?.viewControllers.first(where: { $0 is TasksViewController }) as? TasksViewController {
            
            guard !configScreen.nickNameTextField.text!.isEmpty else {
                showAlert(message: "Digite o apelido novo.")
                return
            }
            
            let newNickname = configScreen.nickNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            if let previousNickname = UserDefaults.standard.string(forKey: "nickname"), newNickname?.isEmpty ?? true {
                configScreen.nickNameTextField.text = previousNickname
            }
            
            let finalNickname = configScreen.nickNameTextField.text ?? ""
            let newPhotoProfile = configScreen.userPhoto.image
            
            vc.nickname = finalNickname
            vc.taskScreen.nameUserLabel.text = newNickname
            vc.taskScreen.imageUser.image = newPhotoProfile
            
            if let newPhotoProfile = configScreen.userPhoto.image,
               let imageData = newPhotoProfile.jpegData(compressionQuality: 0.8) {
                UserDefaults.standard.set(imageData, forKey: "profileImageView")
                UserDefaults.standard.synchronize()
            }
            
            UserDefaults.standard.set(finalNickname, forKey: "nickname")
            UserDefaults.standard.synchronize()
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    func didTapEditPhoto() {
        self.loadPhoto(for: configScreen.userPhoto)
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
