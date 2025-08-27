//
//  TaskRepository.swift
//  BigDayApp
//
//  Criado para salvar/ler tasks por dia no Firestore.
//  Estrutura: users/{uid}/tasks/{taskId}
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class TaskRepository {
    static let shared = TaskRepository()
    private init() {}
    
    private let db = Firestore.firestore()
    
    private func tasksRef(uid: String) -> CollectionReference {
        db.collection("users").document(uid).collection("tasks")
    }
    
    func fetchTasksBetween(_ start: Date,
                           _ end: Date,
                           completion: @escaping (Result<[Task], Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Firebase",
                                        code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "Usuário não logado."])))
            return
        }
        
        let startKey = DateHelper.dateKey(from: start) // "yyyyMMdd"
        let endKey   = DateHelper.dateKey(from: end)
        
        tasksRef(uid: uid)
            .whereField("dateKey", isGreaterThanOrEqualTo: startKey)
            .whereField("dateKey", isLessThanOrEqualTo: endKey)
            .order(by: "dateKey", descending: false)
            .getDocuments { snap, err in
                if let err = err { completion(.failure(err)); return }
                
                let items: [Task] = snap?.documents.compactMap { doc in
                    let d = doc.data()
                    return Task(
                        firebaseId: doc.documentID,
                        title: d["title"] as? String ?? "",
                        time: d["time"] as? String,
                        isCompleted: d["isCompleted"] as? Bool ?? false,
                        dueDate: (d["dueDate"] as? Timestamp)?.dateValue() ?? Date(),
                        dateKey: d["dateKey"] as? String ?? "",
                        order: d["order"] as? Int
                    )
                } ?? []
                
                completion(.success(items))
            }
    }
    
    func createTask(title: String,
                    timeString: String?,
                    dueDate: Date,
                    hasTime: Bool,
                    completion: @escaping (Result<String, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Firebase",
                                        code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "Usuário não logado."])))
            return
        }
        
        let ref = tasksRef(uid: uid).document()
        let id = ref.documentID
        
        let data: [String: Any] = [
            "title": title,
            "time": timeString as Any,
            "isCompleted": false,
            "dueDate": Timestamp(date: dueDate),
            "dateKey": DateHelper.dateKey(from: dueDate),
            "hasTime": hasTime,
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        // 3. Salva no Firestore
        ref.setData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(id))
            }
        }
    }
    
    func create(_ task: Task, completion: @escaping (Result<String, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Firebase",
                                        code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "Usuário não logado."])))
            return
        }
        
        let data: [String: Any] = [
            "title": task.title,
            "time": task.time as Any,
            "isCompleted": task.isCompleted,
            "dueDate": Timestamp(date: (task.dueDate)!),
            "dateKey": task.dateKey,
            "hasTime": (task.time != nil),
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        tasksRef(uid: uid).addDocument(data: data) { err in
            if let err = err { completion(.failure(err)); return }
            completion(.success("ok"))
        }
    }
    
    private var dayListener: ListenerRegistration?
    func observeDay(_ date: Date,
                    orderBy field: String = "createdAt",
                    onChange: @escaping (Result<[Task], Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        dayListener?.remove()
        
        let key = DateHelper.dateKey(from: date)
        
        dayListener = tasksRef(uid: uid)
            .whereField("dateKey", isEqualTo: key)
            .order(by: field, descending: false)
            .addSnapshotListener { snap, err in
                if let err = err { onChange(.failure(err)); return }
                
                let items: [Task] = snap?.documents.compactMap { doc in
                    let d = doc.data()
                    return Task(
                        firebaseId: doc.documentID,
                        title: d["title"] as? String ?? "",
                        time: d["time"] as? String,
                        isCompleted: d["isCompleted"] as? Bool ?? false,
                        dueDate: (d["dueDate"] as? Timestamp)?.dateValue() ?? date,
                        dateKey: d["dateKey"] as? String ?? key,
                        order: d["order"] as? Int
                    )
                } ?? []
                
                onChange(.success(items))
            }
    }
    
    func stopObserveDay() {
        dayListener?.remove()
        dayListener = nil
    }
    
    func update(id: String, fields: [String: Any], completion: ((Error?) -> Void)? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var payload = fields
        payload["updatedAt"] = FieldValue.serverTimestamp()
        tasksRef(uid: uid).document(id).updateData(payload, completion: completion)
    }
    
    func toggleDone(id: String, isDone: Bool) {
        update(id: id, fields: ["isCompleted": isDone])
    }
    
    func delete(id: String, completion: ((Error?) -> Void)? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        tasksRef(uid: uid).document(id).delete(completion: completion)
    }
}
