//
//  ForgotPasswordViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 14/07/25.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    var forgotPassword = ForgotPassWord()
    var viewModel = ForgotPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = forgotPassword
        view.backgroundColor = UIColor(named: "PrimaryColor")
        forgotPassword.delegate = self
        forgotPassword.emailTextField.delegate = self
        navigationSetup(title: "Redefinir senha")
        blindViewModel()
    }
    
    private func blindViewModel() {
        viewModel.onSucess = { [weak self] message in
            self?.showAlert(title: "Sucesso", message: message)
        }
        viewModel.onError = { [weak self] message in
            self?.showAlert(title: "Erro", message: message)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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

extension ForgotPasswordViewController: ForgotPasswordDelegate {
    func didTapSend() {
        viewModel.email = forgotPassword.emailTextField.text ?? ""
        viewModel.sendResetEmail()
    }
}
