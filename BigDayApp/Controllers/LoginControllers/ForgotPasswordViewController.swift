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
        buttonChangePosition()
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
    
    func buttonChangePosition() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height

        UIView.animate(withDuration: 0.3) {
            let bottomInset = self.view.safeAreaInsets.bottom
            self.forgotPassword.saveButtonBottomConstraint.constant = -keyboardHeight + bottomInset - 10
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.forgotPassword.saveButtonBottomConstraint.constant = -10
            self.view.layoutIfNeeded()
        }
    }

}

extension ForgotPasswordViewController: ForgotPasswordDelegate {
    func didTapSend() {
        viewModel.email = forgotPassword.emailTextField.text ?? ""
        viewModel.sendResetEmail()
    }
}
