//
//  ChangePasswordViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 12/07/25.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    var changePassWord = ChangePassWord()
    var tasksVC: TasksViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavgatioBar()
        self.view = changePassWord
        view.backgroundColor = UIColor(named: "PrimaryColor")
        changePassWord.delegate = self
    }
    
    private func setupNavgatioBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = "Alterar senha"
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Atenção", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

extension ChangePasswordViewController: tapButtonPassWordDelete {
    func didTapSaveButton() {
        print("✅ Botão salvar foi tocado")
        
        guard let newNickname = changePassWord.nickNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !newNickname.isEmpty else {
            showAlert(message: "Digite a nova senha.")
            return
        }
        
        
        navigationController?.popViewController(animated: true)
    }
}


