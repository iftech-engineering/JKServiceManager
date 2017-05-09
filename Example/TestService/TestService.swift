//
//  TestService.swift
//  JKServiceManager
//
//  Created by Jason Yu on 5/8/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import JKServiceManager

class TestService: TestServiceProtocol {
    static var isSingleton: Bool = true
    static var sharedInstance: ServiceProtocol = TestService()
    
    public required init() {}
    
    func doTestJob() {
        print("Test service instance is doing job")
    }
}

