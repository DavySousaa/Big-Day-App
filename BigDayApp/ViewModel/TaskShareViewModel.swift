//
//  TaskShareViewModel.swift
//  BigDayApp
//
//  Created by Davy Sousa on 26/07/25.
//

import Foundation

final class TaskShareViewModel {
    
    var onSucess: (() -> Void)?
    var onError: ((String) -> Void)?
    private(set) var tasks: [Task] = []
    
    func loadTasks() {
        self.tasks = TaskSuportHelper().getTask()
        self.onSucess?()
    }
    
    func saveTasks() {
        TaskSuportHelper().addTask(lista: tasks)
    }
    
    func toggleTask(at index: Int) {
        tasks[index].isCompleted.toggle()
        saveTasks()
    }
}
