//
//  FirstScreen.swift
//  BigDayApp
//
//  Created by Davy Sousa on 02/06/25.
//

import UIKit

class FirstScreenViewController: UIViewController,FirstScreenDelegate {
    
    func didTapLogin() {
        let loginAccount = LoginAccountViewController()
        navigationController?.pushViewController(loginAccount, animated: true)
    }
    
    func didTapCreate() {
        let createAccountVC = CreateAccountViewController()
        navigationController?.pushViewController(createAccountVC, animated: true)
    }
    
   var firstScreen = FirstScreen()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = firstScreen
        firstScreen.delegate = self
        navigationItem.backButtonTitle = ""
        view.backgroundColor = .white
    }
    
    
}
