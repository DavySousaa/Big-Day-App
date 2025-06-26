//
//  CreateAccountViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 02/06/25.
//

import UIKit

class CreateAccountViewController: UIViewController, UITextFieldDelegate, CreateAccountScreenDelegate {

   var createAccount = CreateAccount()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = createAccount
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        createAccount.delegate = self
        
        createAccount.emailTextField.delegate = self
        createAccount.nickNameTextField.delegate = self
        createAccount.passwordTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func didTapCreate() {
        let tasksVC = TasksViewController()
        navigationController?.pushViewController(tasksVC, animated: true)
    }
}

