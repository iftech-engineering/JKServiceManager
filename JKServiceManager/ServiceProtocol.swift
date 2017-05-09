//
//  Service.swift
//  ServiceProtocol
//
//  Created by Jason Yu on 4/11/17.
//  Copyright © 2017 Jike. All rights reserved.
//

import Foundation

// The root protocol for all service protocols
public protocol ServiceProtocol {
    static var isSingleton: Bool { get }
    
    // If we use Self constraint here, then it would behave like a generic constraint, so ServiceManager's serviceDict won't be able to store Service.Type.
    // Note: static members of a class is always lazily evaluated, so this won't bring additional performance overhead.
    static var sharedInstance: ServiceProtocol { get }
    
    init()
    
    // Perform additional register logic for each custom service protocol
    static func onRegister()
    
    // Some service might need to be started on launch
    func startService()
}

extension ServiceProtocol {
    public static func onRegister() {
        // by default no op
    }
    
    public func startService() {
        // by default no op
    }
}
