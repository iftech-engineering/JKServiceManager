//
//  ViewController.swift
//  JKServiceManager
//
//  Created by yxztj on 05/06/2017.
//  Copyright (c) 2017 yxztj. All rights reserved.
//

import UIKit
import JKServiceManager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let bundle = Bundle(for: ViewController.self)
        ServiceManager.registerAndStartAllServices(in: [bundle])
        
        // Invoke test service method
        Services.testService?.doTestJob()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

