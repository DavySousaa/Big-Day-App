
import Foundation
import XCTest
@testable import BigDayApp


final class NewListsViwModelTests: XCTestCase {
    
    var sut: CreateListViewModel!
    
    override func setUp() {
        super.setUp()
        sut = CreateListViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func test_createList_withEmptyName_shouldTriggerOnError() {
        let expectation = XCTestExpectation(description: "onError should be called")
        var errorMessage = ""
        
        sut.onError = { message in
            errorMessage = message
            expectation.fulfill()
        }
        
        sut.createList(title: "", iconName: "cart")
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(errorMessage, "Digite o nome da sua lista!")
    }
    
    func test_createList_withoutIcon_shouldTriggerOnError() {
        let expectation = XCTestExpectation(description: "onError should be called")
        var errorMessage = ""
        
        sut.onError = { message in
            errorMessage = message
            expectation.fulfill()
        }
        
        sut.createList(title: "Estudar swift", iconName: "")
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(errorMessage, "Escolha um ícone!")
    }
    
    func test_createList_withoutTitleAndIcon_shouldTriggerOnError() {
        let expectation = XCTestExpectation(description: "onError should be called")
        var errorMessage = ""
        
        sut.onError = { message in
            errorMessage = message
            expectation.fulfill()
        }
        
        sut.createList(title: "", iconName: "")
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(errorMessage, "Digite o nome da sua lista!")
    }
    
}

