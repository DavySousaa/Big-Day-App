import Foundation

struct Task: Codable {
    var firebaseId: String?   // id do documento no Firestore
    var title: String
    var time: String?         // opcional
    var isCompleted: Bool
    var dueDate: Date?
    var dateKey: String       // "yyyy-MM-dd"
    var order: Int?           // opcional
}
