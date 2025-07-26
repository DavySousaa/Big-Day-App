import UIKit

struct LocalUserDefaults {
    static let nicknameKey = "nickname"
    static let photoURLKey = "photoURL"
    static let profileImageKey = "cachedProfileImageData"

    static func saveNickname(_ nickname: String) {
        UserDefaults.standard.set(nickname, forKey: nicknameKey)
    }

    static func getNickname() -> String? {
        UserDefaults.standard.string(forKey: nicknameKey)
    }

    static func savePhotoURL(_ url: String) {
        UserDefaults.standard.set(url, forKey: photoURLKey)
    }

    static func getPhotoURL() -> String? {
        UserDefaults.standard.string(forKey: photoURLKey)
    }

    static func saveProfileImageData(_ image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(imageData, forKey: profileImageKey)
        }
    }

    static func getCachedProfileImage() -> UIImage? {
        if let data = UserDefaults.standard.data(forKey: profileImageKey) {
            return UIImage(data: data)
        }
        return nil
    }

    static func clear() {
        UserDefaults.standard.removeObject(forKey: nicknameKey)
        UserDefaults.standard.removeObject(forKey: photoURLKey)
        UserDefaults.standard.removeObject(forKey: profileImageKey)
    }
}

