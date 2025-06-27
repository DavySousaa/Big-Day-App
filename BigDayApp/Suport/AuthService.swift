//
//  AuthService.swift
//  BigDayApp
//
//  Created by Davy Sousa on 27/06/25.
//

import FirebaseAuth
import FirebaseFirestore

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

            let data = ["nickname": nickname, "email": email]
            Firestore.firestore().collection("users").document(uid).setData(data) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    func loginUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
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
