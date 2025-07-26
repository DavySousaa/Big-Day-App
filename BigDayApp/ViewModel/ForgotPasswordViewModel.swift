//
//  ForgotPasswordViewModel.swift
//  BigDayApp
//
//  Created by Davy Sousa on 24/07/25.
//
import Foundation
import FirebaseAuth
import UIKit

final class ForgotPasswordViewModel {

    var email: String = ""
    
    func sendResetEmail() {
        
        guard !email.isEmpty else {
            onError?("Insira seu e-mail.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.onError?(error.localizedDescription)
            } else {
                self.onSucess?("Enviamos um e-mail com instruções para redefinir sua senha.")
            }
        }
    }
    var onSucess: ((String) -> Void)?
    var onError: ((String) -> Void)?
}
