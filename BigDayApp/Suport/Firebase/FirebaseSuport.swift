import UIKit
import FirebaseAuth
import UserNotifications
import FirebaseFirestore

protocol UserProfileUpdatable: AnyObject {
    var nameUserLabel: UILabel? { get }
    var imageUserView: UIImageView { get }
    var nicknameProperty: String? { get set }
}

extension UserProfileUpdatable where Self: UIViewController {
    
    func updateNickNamePhotoUser() {
        // 🔹 Mostra o que vem do UserDefaults primeiro
        if let nickname = LocalUserDefaults.getNickname() {
            print("🟡 Nickname do cache: \(nickname)")
            self.nicknameProperty = nickname
            self.nameUserLabel?.text = nickname
        }

        if let cachedImage = LocalUserDefaults.getCachedProfileImage() {
            print("🟡 Foto direto do cache (UIImage)")
            self.imageUserView.image = cachedImage
        } else if let photoURL = LocalUserDefaults.getPhotoURL(),
                  let imageUrl = URL(string: photoURL) {
            print("🟡 Foto do cache (URL): \(photoURL)")
            self.loadProfileImage(from: imageUrl)
        }

        // 🔄 Depois atualiza os dados do Firebase
        AuthService.shared.fetchCurrentUser { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    print("🔵 Dados do Firebase: \(user.nickname) | \(user.photoURL ?? "sem URL")")

                    self.nicknameProperty = user.nickname
                    self.nameUserLabel?.text = user.nickname
                    LocalUserDefaults.saveNickname(user.nickname)

                    // ✅ Salva a photoURL no cache, mas NÃO força o download de novo
                    if let photoURL = user.photoURL {
                        LocalUserDefaults.savePhotoURL(photoURL)
                        print("✅ photoURL atualizada no cache, mas sem novo download.")
                    }
                }
            case .failure(let error):
                print("❌ Erro ao buscar user:", error.localizedDescription)
            }
        }
    }



    
    func loadProfileImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageUserView.image = image
                }
            }
        }
    }
}

