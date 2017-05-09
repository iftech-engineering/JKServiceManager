//
//  TestServiceProtocol.swift
//  JKServiceManager
//
//  Created by Jason Yu on 5/8/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import JKServiceManager

// Define a service protocol
public protocol TestServiceProtocol: ServiceProtocol {
    func doTestJob()
}

// Extend Services class with typed static member for convenience
// Otherwise each caller needs to call (ServiceManager.getInstance(for: "testService") as? TestServiceProtocol)
extension Services {
    public static var testService: TestServiceProtocol? {
        return ServiceManager.getInstance(for: "testService")
    }
}
