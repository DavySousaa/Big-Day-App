//
//  EditNicknameViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 12/07/25.
//

import UIKit

class EditNicknameViewController: UIViewController {
    
    var editNickName = EditNickName()
    var tasksVC: TasksViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavgatioBar()
        self.view = editNickName
        view.backgroundColor = UIColor(named: "PrimaryColor")
        editNickName.delegate = self
    }
    
    private func setupNavgatioBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = "Alterar apelido"
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Atenção", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

extension EditNicknameViewController: tapButtonNickNameDelete {
    func didTapSaveButton() {
        print("✅ Botão salvar foi tocado")
        
        guard let newNickname = editNickName.nickNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !newNickname.isEmpty else {
            showAlert(message: "Digite o apelido novo.")
            return
        }
        
        UserDefaults.standard.set(newNickname, forKey: "nickname")
        UserDefaults.standard.synchronize()
        
        navigationController?.popViewController(animated: true)
    }
}


