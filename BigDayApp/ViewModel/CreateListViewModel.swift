import Foundation
import FirebaseFirestore
import FirebaseAuth

class CreateListViewModel {
    
    var onSucess: (() -> Void)?
    var onError: ((String) -> Void)?
    private let db = Firestore.firestore()
    
    func createList(title: String, iconName: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            onError?("Usuário não autenticado.")
            return
        }
        
        guard !title.isEmpty else {
            onError?("Digite o nome da sua lista!")
            return
        }
        
        guard !iconName.isEmpty else {
            onError?("Escolha um ícone!")
            return
        }
        
        let newListData: [String: Any] = [
            "title": title,
            "iconName": iconName,
            "createdAt": Timestamp(date: Date())
        ]
        
        db.collection("users")
            .document(userId)
            .collection("lists")
            .addDocument(data: newListData) { [weak self] error in
                if let error = error {
                    self?.onError?("Erro ao salvar: \(error.localizedDescription)")
                } else {
                    self?.onSucess?()
                }
            }
    }
    
}
