import FirebaseFirestore
import FirebaseAuth

class ListItemsViewModel {
    
    private let db = Firestore.firestore()
    var onItemsUpdate: (([ListItem]) -> Void)?
    var listTitle: UserList?
    private var listener: ListenerRegistration?
    
    func listenItems(listId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        listener = db.collection("users")
            .document(userId)
            .collection("lists")
            .document(listId)
            .collection("items")
            .order(by: "createdAt", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                
                guard let docs = snapshot?.documents, error == nil else { return }
                
                let items = docs.map { doc -> ListItem in
                    let data = doc.data()
                    return ListItem(
                        id: doc.documentID,
                        title: data["title"] as? String ?? "",
                        isCompleted: data["isCompleted"] as? Bool ?? false
                    )
                }
                self?.onItemsUpdate?(items)
            }
    }
    
    func addItem(listId: String, title: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let newItem = [
            "title": title,
            "isCompleted": false,
            "createdAt": Timestamp(date: Date())
        ] as [String : Any]
        
        db.collection("users")
            .document(userId)
            .collection("lists")
            .document(listId)
            .collection("items")
            .addDocument(data: newItem)
    }
    
    func updateCompletion(listId: String, itemId: String, isCompleted: Bool) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("users")
            .document(userId)
            .collection("lists")
            .document(listId)
            .collection("items")
            .document(itemId)
            .updateData(["isCompleted": isCompleted])
    }
    
    func deleteItem(listId: String, itemId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("users")
            .document(userId)
            .collection("lists")
            .document(listId)
            .collection("items")
            .document(itemId)
            .delete()
    }
    
    func stopListening() {
        listener?.remove()
    }
}

