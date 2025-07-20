//
//  AuthService.swift
//  BigDayApp
//
//  Created by Davy Sousa on 27/06/25.
//

import FirebaseAuth
import FirebaseFirestore

class FirestoreManager {
    let db = Firestore.firestore()
    
    func createUserDocument(uid: String, nickname: String, completion: @escaping (Error?) -> Void) {
        let userData: [String: Any] = [
            "nickname": nickname,
            "photoURL": ""
        ]
        
        db.collection("users").document(uid).setData(userData) { error in
            completion(error)
        }
    }
}


final class AuthService {
    static let shared = AuthService()
    private init() {}

    func createUser(nickname: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let uid = result?.user.uid else {
                completion(.failure(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "UID não encontrado."])))
                return
            }

            // ✅ Dados que vão pro Firestore
            let data: [String: Any] = [
                "nickname": nickname,
                "email": email,
                "photoURL": "" // Pode atualizar depois com a foto real
            ]

            // ✅ Salvar no Firestore
            Firestore.firestore().collection("users").document(uid).setData(data) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    // 🟢 AQUI: salva também no UserDefaults
                    LocalUserDefaults.saveNickname(nickname)
                    LocalUserDefaults.savePhotoURL("") // Ainda não tem a foto, mas já deixa a chave salva

                    completion(.success(()))
                }
            }
        }
    }



    func loginUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = result?.user.uid else {
                completion(.failure(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "UID não encontrado."])))
                return
            }
            
            // 🔍 Busca os dados do Firestore
            Firestore.firestore().collection("users").document(uid).getDocument { document, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = document?.data(),
                      let nickname = data["nickname"] as? String,
                      let photoURL = data["photoURL"] as? String else {
                    completion(.failure(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Dados do usuário incompletos."])))
                    return
                }
                
                // ✅ Salva no cache local
                LocalUserDefaults.saveNickname(nickname)
                LocalUserDefaults.savePhotoURL(photoURL)
                
                completion(.success(()))
            }
        }
    }

    
    func fetchCurrentUser(completion: @escaping (Result<UserModel, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Usuário não logado."])))
            return
        }

        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = snapshot?.data(), let user = UserModel(document: data, uid: uid) {
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "Firebase", code: -2, userInfo: [NSLocalizedDescriptionKey: "Dados do usuário não encontrados."])))
            }
        }
    }

}
