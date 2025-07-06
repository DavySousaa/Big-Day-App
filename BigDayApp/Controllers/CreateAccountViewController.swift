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
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        
        createAccount.emailTextField.delegate = self
        createAccount.nickNameTextField.delegate = self
        createAccount.passwordTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.onSuccess = { [weak self] in
            DispatchQueue.main.async {
                UserDefaults.standard.set(self?.viewModel.nickname, forKey: "nickname")
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
    
    func didTapCreate() {
        viewModel.nickname = createAccount.nickNameTextField.text ?? ""
        viewModel.email = createAccount.emailTextField.text ?? ""
        viewModel.password = createAccount.passwordTextField.text ?? ""
        viewModel.register()
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


