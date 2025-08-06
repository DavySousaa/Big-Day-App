//
//  LoginAccountViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 02/06/25.
//

import UIKit

class LoginAccountViewController: UIViewController, UITextFieldDelegate, LoginAccountScreenDelegate {
    
    func didTapResetButton() {
        let vc = ForgotPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    var loginAccount = LoginAccount()
    var viewModel = LoginAccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginAccount
        loginAccount.delegate = self
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.tintColor = .label
        
        navigationItem.backButtonTitle = "Voltar"
        
        loginAccount.emailTextField.delegate = self
        loginAccount.passwordTextField.delegate = self
        
        let logoImage = traitCollection.userInterfaceStyle == .dark
            ? UIImage(named: "logo2")
            : UIImage(named: "logo1")
        loginAccount.imageLogo.image = logoImage
        
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
                self?.loginAccount.hideButtonLoading()
                let tabBarVC = MainTabBarController()
                if let sceneDelegate = UIApplication.shared.connectedScenes
                    .first?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = tabBarVC
                }
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.loginAccount.hideButtonLoading()
                self?.showAlert(title: "Erro", message: message)
            }
        }
    }
    
    func didTapLogin() {
        viewModel.email = loginAccount.emailTextField.text ?? ""
        viewModel.password = loginAccount.passwordTextField.text ?? ""
        loginAccount.showButtonLoading()
        viewModel.login()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


