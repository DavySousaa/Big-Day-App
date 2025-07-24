import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


final class DatabaseSupport {
    static let shared = DatabaseSupport()
    private init() {}
}


extension DatabaseSupport {
    
    /// Salva a URL da foto de perfil no Firestore
    func savePhotoURL(_ url: URL, completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        Firestore.firestore().collection("users").document(uid).updateData([
            "photoURL": url.absoluteString
        ]) { error in
            if let error = error {
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    /// Salva ou atualiza o apelido do usuário no Firestore
    func saveNickname(_ nickname: String, completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        Firestore.firestore().collection("users").document(uid).updateData([
            "nickname": nickname
        ]) { error in
            if let error = error {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
