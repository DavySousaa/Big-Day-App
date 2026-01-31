
import Foundation
import XCTest
@testable import BigDayApp

final class EditListViewModelTests: XCTestCase {
    
    var sut: EditListViewModel!
    
    override func setUp() {
        super.setUp()
        sut = EditListViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func test_editList_withEmptyTitle_shouldTriggerOnError() {
        let expectation = XCTestExpectation(description: "onError should be called")
        var errorMessage = ""
        
        sut.onErorr = { message in
            errorMessage = message
            expectation.fulfill()
        }
        
        sut.saveEditList(title: "", iconName: "xmark")
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(errorMessage, "Digite o novo nome da lista")
    }
    
    func test_editList_withEmptyIcon_shouldTriggerOnError() {
        let expectation = XCTestExpectation(description: "onError should be called")
        var errorMessage = ""
        
        sut.onErorr = { message in
            errorMessage = message
            expectation.fulfill()
        }
        
        sut.saveEditList(title: "Nome da lista", iconName: "")
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(errorMessage, "Escolha o novo ícone")
    }
    
    
}
