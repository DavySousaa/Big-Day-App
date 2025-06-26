//
//  LoginAccountViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 02/06/25.
//

import UIKit

class LoginAccountViewController: UIViewController, UITextFieldDelegate, LoginAccountScreenDelegate {

   var loginAccount = LoginAccount()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginAccount
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        loginAccount.delegate = self
        
        loginAccount.emailTextField.delegate = self
        loginAccount.passwordTextField.delegate = self
        
        let tapGesture = UIRotationGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func didTapLogin() {
        let tasksVC = TasksViewController()
        navigationController?.pushViewController(tasksVC, animated: true)
    }
}


