//
//  EditNicknameViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 12/07/25.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class EditNicknameViewController: UIViewController, UITextFieldDelegate {
    
    var editNickName = EditNickName()
    var tasksVC: TasksViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationSetup(title: "Editar apelido")
        self.view = editNickName
        view.backgroundColor = UIColor(named: "PrimaryColor")
        editNickName.delegate = self
        editNickName.nickNameTextField.delegate = self
        
        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
            editNickName.nickNameTextField.text = nickname
        }

        buttonChangePosition()
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
            self.editNickName.saveButtonBottomConstraint.constant = -keyboardHeight + bottomInset - 10
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.editNickName.saveButtonBottomConstraint.constant = -10
            self.view.layoutIfNeeded()
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        
        // 1. Atualiza local (opcional, se quiser mostrar instantaneamente)
        UserDefaults.standard.set(newNickname, forKey: "nickname")
        
        // 2. Atualiza no Firestore (ESSENCIAL!)
        if let uid = Auth.auth().currentUser?.uid {
            Firestore.firestore().collection("users").document(uid).updateData([
                "nickname": newNickname
            ]) { error in
                if let error = error {
                    print("❌ Erro ao salvar no Firestore:", error.localizedDescription)
                } else {
                    print("✅ Apelido atualizado no Firestore")
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }

}


