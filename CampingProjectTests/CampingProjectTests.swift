//
//  CampingProjectTests.swift
//  CampingProjectTests
//
//  Created by 고정근 on 2022/02/15.
//

import XCTest
@testable import CampingProject

class CampingProjectTests: XCTestCase {
    
    let email = "ggggg3032@gmail.com"
    let type = emailType.REGISTER

    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        APIManager.shared.requestEmailCertificationCode(email: email, type: type, completion: { _ in })
//        APIManager.shared.checkEmailCertificationCode(email: email, code: "sbX8aXGg", type: type, completion: {re in
//            print(re)
//        })
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            
            // Put the code you want to measure the time of here.
        }
    }

}
