//
//  ViewController.swift
//  JKServiceManager
//
//  Created by Jason Yu on 05/06/2017.
//  Copyright (c) 2017 Jason Yu. All rights reserved.
//

import UIKit
import JKServiceManager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 0. Provide logger(optional)
        ServiceManager.logger = SomeLogger()
        
        // 1. Specify bundles that contain Services.json.
        // Note: If specified bundle doesn't include Services.json, an assert would be triggered.
        let bundles = [Bundle(for: ViewController.self)]
        
        // 2. Register and start all services
        ServiceManager.registerAndStartAllServices(in: bundles)
        
        // 3. Invoke test service method
        Services.testService?.doTestJob()
    }
    
}

class SomeLogger: ServiceManagerLoggerDelegate {
    init() {}
    
    func info(_ message: String) {
        print(message)
    }
    
    func error(_ message: String) {
        print(message)
    }
}
