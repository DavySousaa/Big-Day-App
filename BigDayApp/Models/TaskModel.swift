//
//  TaskModel.swift
//  BigDayApp
//
//  Created by Davy Sousa on 28/06/25.
//
import Foundation

class Task: Codable {
    var id: UUID
    var title: String
    var time: String?
    var isCompleted: Bool
    
    init(id: UUID, title: String, time: String?, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.time = time
        self.isCompleted = isCompleted
    }
}
