//
//  AuthService.swift
//  BigDayApp
//
//  Created by Davy Sousa on 27/06/25.
//

import FirebaseAuth
import FirebaseFirestore

class FirestoreManager {
    static let shared = FirestoreManager()
    private init() {}

    let db = Firestore.firestore()

    // Garante/atualiza o documento do usuário com merge
    func ensureUserDocument(uid: String, email: String?, nickname: String?, photoURL: String?, completion: ((Error?) -> Void)? = nil) {
        var payload: [String: Any] = [
            "updatedAt": FieldValue.serverTimestamp()
        ]
        if let email = email { payload["email"] = email }
        if let nickname = nickname { payload["nickname"] = nickname }
        if let photoURL = photoURL { payload["photoURL"] = photoURL }

        db.collection("users").document(uid).setData(payload, merge: true) { error in
            completion?(error)
        }
    }

    // Referência da subcoleção tasks do usuário logado
    func tasksRef(for uid: String) -> CollectionReference {
        db.collection("users").document(uid).collection("tasks")
    }
}


final class AuthService {
    static let shared = AuthService()
    private init() {}
    
    func createUser(nickname: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error { completion(.failure(error)); return }
            
            guard let user = result?.user else {
                completion(.failure(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Usuário não retornado."])))
                return
            }
            
            // Cria/atualiza doc do usuário (merge)
            FirestoreManager.shared.ensureUserDocument(
                uid: user.uid,
                email: email,
                nickname: nickname,
                photoURL: ""
            ) { err in
                if let err = err { completion(.failure(err)); return }
                
                // Cache local
                LocalUserDefaults.saveNickname(nickname)
                LocalUserDefaults.savePhotoURL("")
                
                completion(.success(()))
            }
        }
    }
    
    
    
    func loginUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error { completion(.failure(error)); return }
            
            guard let user = result?.user else {
                completion(.failure(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Usuário não retornado."])))
                return
            }
            
            let usersRef = Firestore.firestore().collection("users").document(user.uid)
            usersRef.getDocument { snapshot, err in
                if let err = err { completion(.failure(err)); return }
                
                var data = snapshot?.data() ?? [:]
                
                // Se estiver faltando algo, preenche e já faz ensure/merge
                let existingNickname = data["nickname"] as? String
                let existingPhoto = data["photoURL"] as? String
                let nickFallback = existingNickname ?? (email.split(separator: "@").first.map(String.init) ?? "user")
                let photoFallback = existingPhoto ?? ""
                
                FirestoreManager.shared.ensureUserDocument(
                    uid: user.uid,
                    email: email,
                    nickname: existingNickname ?? nickFallback,
                    photoURL: existingPhoto ?? photoFallback
                ) { ensureErr in
                    if let ensureErr = ensureErr { completion(.failure(ensureErr)); return }
                    
                    // Atualiza cache local
                    LocalUserDefaults.saveNickname(existingNickname ?? nickFallback)
                    LocalUserDefaults.savePhotoURL(existingPhoto ?? photoFallback)
                    
                    completion(.success(()))
                }
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
