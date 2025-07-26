//
//  NewTaskViewModel.swift
//  BigDayApp
//
//  Created by Davy Sousa on 25/07/25.
//


import UIKit
import UserNotifications

final class NewTaskViewModel {
    
    var onSucess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    
    func createTask(title: String, shouldSchedule: Bool, selectedDate: Date?) {
        guard !title.isEmpty else {
            self.onError?("Digite uma tarefa para ser adicionada!")
            return
        }
        
        let timeString = DateFormatHelper.formatTime(shouldSchedule: shouldSchedule, date: selectedDate)
        
        let task = Task(id: UUID(), title: title, time: timeString, isCompleted: false)
        var list = TaskSuportHelper().getTask()
        list.append(task)
        TaskSuportHelper().addTask(lista: list)
        
        if shouldSchedule, let date = selectedDate {
            NotificationManager.shared.scheduleTaskReminder(title: title, date: date)
        }
        self.onSucess?()
    }
}
