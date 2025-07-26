//
//  EditTaskViewModelTests.swift
//  BigDayApp
//
//  Created by Davy Sousa on 26/07/25.
//

import Foundation
import XCTest
@testable import BigDayApp

final class EditTaskViewModelTests: XCTestCase {
    var sut: EditTaskViewModel!
    
    override func setUp() {
        super.setUp()
        sut = EditTaskViewModel()
        TaskSuportHelper().resetTasks()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        TaskSuportHelper().resetTasks()
    }
    
    func test_createTask_withEmptyTitle_shouldTriggerOnError() {
        let expectation = XCTestExpectation(description: "onError should be called")
        var errorMessage = ""
        
        sut.onError = { message in
            errorMessage = message
            expectation.fulfill()
        }
        
        sut.saveEditTask(title: "", shouldSchedule: true, selectedDate: nil)
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(errorMessage, "Digite uma tarefa para ser adicionada!")
    }
    
    func test_editTask_shouldUpdateTaskWithNewTitleAndTime() {
        let originalTask = Task(id: UUID(), title: "Título antigo", time: "08:00", isCompleted: false)
        TaskSuportHelper().addTask(lista: [originalTask])
        sut.taskToEdit = originalTask
        
        let expectation = XCTestExpectation(description: "onSucess should be called")
        sut.onSucess = {
            expectation.fulfill()
        }
        
        let newTitle = "Novo título"
        let newTime = Calendar.current.date(bySettingHour: 18, minute: 30, second: 0, of: Date())!
        
        sut.saveEditTask(title: newTitle, shouldSchedule: true, selectedDate: newTime)
        wait(for: [expectation], timeout: 1.0)
        
        let list = TaskSuportHelper().getTask()
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list[0].title, newTitle)
        XCTAssertEqual(list[0].time, DateFormatHelper.formatTime(shouldSchedule: true, date: newTime))
    }
}
