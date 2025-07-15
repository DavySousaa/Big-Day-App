//
//  ForgotPasswordViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 14/07/25.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController, ForgotPasswordDelegate {
    
    func didTapSend() {
        guard let email = forgotPassword.emailTextField.text, !email.isEmpty else {
            showAlert(title: "Erro", message: "Por favor, digite seu e-mail.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.showAlert(title: "Erro", message: error.localizedDescription)
            } else {
                self.showAlert(title: "Tudo certo!", message: "Enviamos um e-mail com instruções para redefinir sua senha.")
            }
        }
    }

    var forgotPassword = ForgotPassWord()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = forgotPassword
        view.backgroundColor = UIColor(named: "PrimaryColor")
        forgotPassword.delegate = self
        setupNavgatioBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func setupNavgatioBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = "Redefinir senha"
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}
