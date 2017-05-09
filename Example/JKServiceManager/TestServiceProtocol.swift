//
//  TestServiceProtocol.swift
//  JKServiceManager
//
//  Created by Jason Yu on 5/8/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import JKServiceManager

public protocol TestServiceProtocol: ServiceProtocol {
    func doTestJob()
}

extension Services {
    public static var testService: TestServiceProtocol? {
        return ServiceManager.getInstance(for: "testService")
    }
}
