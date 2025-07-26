//
//  EditTaskViewModel.swift
//  BigDayApp
//
//  Created by Davy Sousa on 25/07/25.
//
import UIKit

final class EditTaskViewModel {
    
    var onSucess: (() -> Void)?
    var onError: ((String) -> Void)?
    var taskToEdit: Task?
    
    func saveEditTask(title: String, shouldSchedule: Bool, selectedDate: Date?) {
        guard !title.isEmpty else {
            self.onError?("Digite uma tarefa para ser adicionada!")
            return
        }
        
        guard var task = taskToEdit else {
            self.onError?("Erro ao carregar a tarefa.")
            return
        }
        
        task.title = title
        task.time = DateFormatHelper.formatTime(shouldSchedule: shouldSchedule, date: selectedDate)
        
        var list = TaskSuportHelper().getTask()
        
        if let index = list.firstIndex(where: { $0.id == task.id }) {
            list[index] = task
        }
        
        TaskSuportHelper().addTask(lista: list)
        
        if shouldSchedule, let date = selectedDate {
            NotificationManager.shared.scheduleTaskReminder(title: title, date: date)
        }
        
        self.onSucess?()
    }
}
