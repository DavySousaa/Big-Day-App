import Foundation
import FirebaseFirestore
import FirebaseAuth

final class EditListViewModel {
    
    var listToEdit: UserList?
    
    var onSucess: (()-> Void)?
    var onErorr: ((String)-> Void)?
    
    private let db = FirebaseFirestore.Firestore.firestore()
    
    func saveEditList(title: String, iconName: String) {
        
        guard let user = Auth.auth().currentUser?.uid else {
            onErorr?("Usuário não autenticado")
            return
        }
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            onErorr?("Digite o novo nome da lista")
            return
        }
        
        guard !iconName.isEmpty else {
            onErorr?("Escolha o novo ícone")
            return
        }
        
        guard let currentList = listToEdit else {
            onErorr?("Lista não encontrada")
            return
        }
        
        guard let listID = currentList.id else {
            onErorr?("ID da lista inválido.")
            return
        }
        
        
        var payload: [String: Any] = [:]
        
        if currentList.title != trimmedTitle {
            payload["title"] = trimmedTitle
        }
        if currentList.iconName != iconName {
            payload["iconName"] = iconName
        }
        if payload.isEmpty {
            onSucess?()
            return
        }
        
        db.collection("users").document(user).collection("lists").document(listID).updateData(payload) { (error) in
            if let error = error {
                self.onErorr?(error.localizedDescription)
            } else {
                if var list = self.listToEdit {
                    let newTitle = payload["title"] as? String ?? list.title
                    let newIcon  = payload["iconName"] as? String ?? list.iconName
                    
                    self.listToEdit = UserList(
                        id: list.id,
                        title: newTitle,
                        iconName: newIcon
                    )
                }
                self.onSucess?()
            }
        }
    }
}
