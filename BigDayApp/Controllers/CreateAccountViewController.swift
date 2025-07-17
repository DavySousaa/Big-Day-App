//
//  CreateAccountViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 02/06/25.
//

import UIKit

class CreateAccountViewController: UIViewController, UITextFieldDelegate, CreateAccountScreenDelegate {
    
    var createAccount = CreateAccount()
    var viewModel = CreateAccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = createAccount
        createAccount.delegate = self
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationController?.navigationBar.tintColor = .label
        
        createAccount.emailTextField.delegate = self
        createAccount.nickNameTextField.delegate = self
        createAccount.passwordTextField.delegate = self
        
        let logoImage = traitCollection.userInterfaceStyle == .dark
            ? UIImage(named: "logo2")
            : UIImage(named: "logo1")
        createAccount.imageLogo.image = logoImage
        
        bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func bindViewModel() {
        viewModel.onSuccess = { [weak self] in
            DispatchQueue.main.async {
                let tabBarVC = MainTabBarController()
                if let sceneDelegate = UIApplication.shared.connectedScenes
                    .first?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = tabBarVC
                }
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(title: "Erro", message: message)
            }
        }
    }
    
    func didTapCreate() {
        viewModel.nickname = createAccount.nickNameTextField.text ?? ""
        viewModel.email = createAccount.emailTextField.text ?? ""
        viewModel.password = createAccount.passwordTextField.text ?? ""
        viewModel.register()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


