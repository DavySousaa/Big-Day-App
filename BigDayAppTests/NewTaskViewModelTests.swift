import Foundation
import XCTest
@testable import BigDayApp

final class NewTaskViewModelTests: XCTestCase {
    var sut: NewTaskViewModel!

    override func setUp() {
        super.setUp()
        sut = NewTaskViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func test_createTask_withEmptyTitle_shouldTriggerOnError() {
        let expectation = XCTestExpectation(description: "onError should be called")
        var errorMessage = ""
        
        sut.onError = { message in
            errorMessage = message
            expectation.fulfill()
        }
        
        sut.createTask(title: "", shouldSchedule: true, selectedDate: nil)
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(errorMessage, "Digite uma tarefa para ser adicionada!")
    }
    
    func test_createTask_withoutScheduling_shouldCreateTaskAndCallSuccess(){
        let expectation = XCTestExpectation(description: "onSucess should be called")
        
        sut.onSucess = {
            expectation.fulfill()
        }
        
        TaskSuportHelper().resetTasks()
        
        sut.createTask(title: "Estudar Swift", shouldSchedule: false, selectedDate: nil)
        
        wait(for: [expectation], timeout: 1.0)
        let list = TaskSuportHelper().getTask()
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list[0].title, "Estudar Swift")
        XCTAssertEqual(list[0].time, "")
    }
    
    func test_createTask_withScheduling_shouldSaveTimeAndCallNotification() {
        let expectation = XCTestExpectation(description: "onSucess should be called")
        
        sut.onSucess = {
            expectation.fulfill()
        }
        
        TaskSuportHelper().resetTasks()
        
        let date = Date()
        sut.createTask(title: "Ir à academia", shouldSchedule: true, selectedDate: date)
        wait(for: [expectation], timeout: 1.0)
        
        let list = TaskSuportHelper().getTask()
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list[0].title, "Ir à academia")
        XCTAssertEqual(list[0].time?.isEmpty, false)
    }
}
