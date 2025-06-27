//
//  LoginAccountViewModel.swift
//  BigDayApp
//
//  Created by Davy Sousa on 27/06/25.
//

import Foundation

final class LoginAccountViewModel {

    var email: String = ""
    var password: String = ""

    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?

    func login() {
        AuthService.shared.loginUser(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.onSuccess?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
}
