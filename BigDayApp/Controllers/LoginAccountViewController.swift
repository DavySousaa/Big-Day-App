//
//  LoginAccountViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 02/06/25.
//

import UIKit

class LoginAccountViewController: UIViewController, UITextFieldDelegate, LoginAccountScreenDelegate {
    
    var loginAccount = LoginAccount()
    var viewModel = LoginAccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginAccount
        loginAccount.delegate = self
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationController?.navigationBar.tintColor = .label
        
        loginAccount.emailTextField.delegate = self
        loginAccount.passwordTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        let logoImage = traitCollection.userInterfaceStyle == .dark
            ? UIImage(named: "logo2")
            : UIImage(named: "logo1")
        loginAccount.imageLogo.image = logoImage
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.onSuccess = { [weak self] in
            DispatchQueue.main.async {
                let tasksVC = TasksViewController()
                self?.navigationController?.pushViewController(tasksVC, animated: true)
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(title: "Erro", message: message)
            }
        }
    }
    
    func didTapLogin() {
        viewModel.email = loginAccount.emailTextField.text ?? ""
        viewModel.password = loginAccount.passwordTextField.text ?? ""
        viewModel.login()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


