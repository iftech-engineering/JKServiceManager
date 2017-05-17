//
//  JKServiceManagerTests.swift
//  JKServiceManagerTests
//
//  Created by Jason Yu on 5/17/17.
//  Copyright © 2017 Jike. All rights reserved.
//

import XCTest
@testable import JKServiceManager

class JKServiceManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCanRegisterService() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let bundle = Bundle(for: JKServiceManagerTests.self)
        ServiceManager.registerAndStartAllServices(in: [bundle])
    }
    
}

protocol TestServiceProtocol: ServiceProtocol {
    func doTestJob()
}

class TestService: TestServiceProtocol {
    static var isSingleton: Bool = true
    static var sharedInstance: ServiceProtocol = TestService()
    
    required init() {
        
    }
    
    func doTestJob() {
        print("is doing test job")
    }
}

