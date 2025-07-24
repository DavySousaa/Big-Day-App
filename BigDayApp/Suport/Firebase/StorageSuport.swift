import FirebaseAuth
import FirebaseStorage
import UIKit

final class StorageSupport {
    static let shared = StorageSupport()
    private init() {}

    func uploadProfileImageToFirebase(_ image: UIImage, completion: @escaping (Bool, URL?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false, nil)
            return
        }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(false, nil)
            return
        }

        // 🔎 2. Nome do arquivo que será salvo
        let fileName = "\(uid).jpg"

        // 🔎 3. Confirma o bucket usado
        let storage = Storage.storage(url: "gs://big-day-app.firebasestorage.app")

        let storageRef = storage.reference().child("profile_pictures/\(fileName)")

        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(false, nil)
                return
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                storageRef.downloadURL { url, error in
                    if let error = error {
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
