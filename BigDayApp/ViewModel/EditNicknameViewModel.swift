//
//  EditNicknameViewModel.swift
//  BigDayApp
//
//  Created by Davy Sousa on 25/07/25.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

final class EditNicknameViewModel {
    
    var newNickname = ""
    var onSucess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func saveNickname() {
        guard !newNickname.isEmpty else {
            onError?("Digite o novo apelido.")
            return
        }
        
        UserDefaults.standard.set(newNickname, forKey: "nickname")
        
        if let uid = Auth.auth().currentUser?.uid {
            Firestore.firestore().collection("users").document(uid).updateData([
                "nickname": newNickname
            ]) { error in
                if let error = error {
                    print("❌ Erro ao salvar no Firestore:", error.localizedDescription)
                } else {
                    DispatchQueue.main.async {
                        self.onSucess?()
                    }
                }
            }
        }
        self.onSucess?()
    }
}
