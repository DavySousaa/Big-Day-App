import FirebaseAuth
import FirebaseStorage
import UIKit

final class StorageSupport {
    static let shared = StorageSupport()
    private init() {}

    func uploadProfileImageToFirebase(_ image: UIImage, completion: @escaping (Bool, URL?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("❌ Usuário NÃO está autenticado")
            completion(false, nil)
            return
        }

        // 🔎 1. UID autenticado
        print("✅ UID do usuário autenticado:", uid)

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(false, nil)
            return
        }

        // 🔎 2. Nome do arquivo que será salvo
        let fileName = "\(uid).jpg"
        print("📂 Nome do arquivo salvo no Storage:", fileName)

        // 🔎 3. Confirma o bucket usado
        let storage = Storage.storage(url: "gs://big-day-app.firebasestorage.app")
        print("🌐 Bucket em uso:", storage.reference().bucket)

        let storageRef = storage.reference().child("profile_pictures/\(fileName)")

        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("❌ Erro ao fazer upload:", error.localizedDescription)
                completion(false, nil)
                return
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("❌ Erro ao obter URL:", error.localizedDescription)
                        completion(false, nil)
                        return
                    }

                    guard let url = url else {
                        completion(false, nil)
                        return
                    }

                    completion(true, url)
                }
            }
        }
    }

}
