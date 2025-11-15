import FirebaseFirestore
import FirebaseAuth

class ListsViewModel {
    
    private let db = Firestore.firestore()
    var onListsUpdate: (([UserList]) -> Void)?
    var listChanged: (() -> Void)?

    func listenToUserLists() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let listsRef = db.collection("users").document(userId).collection("lists").order(by: "createdAt", descending: false)
        
        listsRef.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Erro ao escutar listas: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            if documents.isEmpty {
                // Caso não tenha listas ainda → cria as padrões
                self.createDefaultListsIfNeeded(for: userId)
                return
            }
            
            // Se já tiver listas → transforma e manda pra Controller
            let lists = documents.map { doc -> UserList in
                let data = doc.data()
                return UserList(
                    id: doc.documentID,
                    title: data["title"] as? String ?? "",
                    iconName: data["iconName"] as? String ?? ""
                )
            }
            
            self.onListsUpdate?(lists)
        }
    }
    
    private func createDefaultListsIfNeeded(for userId: String) {
        let listsRef = db.collection("users").document(userId).collection("lists")
        
        let defaultLists = [
            ["title": "Compras", "iconName": "cart", "createdAt": Timestamp(date: Date())],
            ["title": "Aniversário", "iconName": "gift.fill", "createdAt": Timestamp(date: Date())],
            ["title": "Reforma", "iconName": "hammer", "createdAt": Timestamp(date: Date())]
        ]
        
        for listData in defaultLists {
            listsRef.addDocument(data: listData)
        }
        
        print("✅ Listas padrão criadas para o usuário \(userId)")
    }
    
    func deleteList(listId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let listRef = db.collection("users")
            .document(userId)
            .collection("lists")
            .document(listId)
        
        listRef.collection("items").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Erro ao buscar itens da lista: \(error.localizedDescription)")
                return
            }
            
            let batch = self.db.batch()
            snapshot?.documents.forEach { doc in
                batch.deleteDocument(doc.reference)
            }
            
            batch.commit { error in
                if let error = error {
                    print("❌ Erro ao deletar itens: \(error.localizedDescription)")
                    return
                }
                
                listRef.delete { error in
                    if let error = error {
                        print("❌ Erro ao deletar lista: \(error.localizedDescription)")
                    } else {
                        print("✅ Lista e itens deletados com sucesso!")
                    }
                }
            }
        }
    }
    
}

