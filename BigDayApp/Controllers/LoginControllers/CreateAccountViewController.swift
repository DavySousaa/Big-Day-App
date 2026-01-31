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
    var emailValidationViewModel = EmailValidationServiceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = createAccount
        createAccount.delegate = self
        view.backgroundColor = UIColor(named: "PrimaryColor")
        navigationController?.navigationBar.tintColor = .label
        
        createAccount.emailTextField.delegate = self
        createAccount.nickNameTextField.delegate = self
        createAccount.passwordTextField.delegate = self
        
        let logoImage = traitCollection.userInterfaceStyle == .dark
            ? UIImage(named: "logo2")
            : UIImage(named: "logo1")
        createAccount.imageLogo.image = logoImage
        
        bindViewModel()
        buttonChangePosition()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func bindViewModel() {
        viewModel.onSuccess = { [weak self] in
            DispatchQueue.main.async {
                let tabBarVC = MainTabBarController()
                if let sceneDelegate = UIApplication.shared.connectedScenes
                    .first?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = tabBarVC
                }
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(title: "Erro", message: message)
            }
        }
        emailValidationViewModel.onValidationResult = { [weak self] result in
            switch result {
            case .success:
                self?.viewModel.register()
            case .failure(let errorMessage):
                self?.createAccount.hideButtonLoading()
                self?.showAlert(title: "Erro", message: errorMessage)
            }
        }
    }
    
    func didTapCreate() {
        let nickname = createAccount.nickNameTextField.text ?? ""
        let email = createAccount.emailTextField.text ?? ""
        let password = createAccount.passwordTextField.text ?? ""

        
        if nickname.isEmpty || email.isEmpty || password.isEmpty {
            showAlert(title: "Erro", message: "Preencha todos os campos para continuar.")
            return
        }
        
        viewModel.nickname = nickname
        viewModel.email = email
        viewModel.password = password
            
        createAccount.showButtonLoading()
        emailValidationViewModel.checkEmail(email)
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
            self.createAccount.saveButtonBottomConstraint.constant = -keyboardHeight + bottomInset - 10
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.createAccount.saveButtonBottomConstraint.constant = -10
            self.view.layoutIfNeeded()
        }
    }
}


