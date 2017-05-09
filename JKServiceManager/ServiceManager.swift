//
//  ServiceManager.swift
//  ServiceManager
//
//  Created by Jason Yu on 4/11/17.
//  Copyright © 2017 Jike. All rights reserved.
//

import Foundation

public protocol ServiceManagerLoggerDelegate: class {
    func info(_ message: String)
    func error(_ message: String)
}

public class ServiceManager {
    // Injected logger provider
    public static var logger: ServiceManagerLoggerDelegate?
    
    private static var servicesDict: [String: ServiceProtocol.Type] = [:]
    private static var serviceRegistrationCompleted = false
    
    /// Get the service instance for specified serviceName
    ///
    /// - Parameter serviceName: The name string of the service
    /// - Returns: The service instance. Return nil if not found.
    public class func getInstance<ServiceType>(for serviceName: String) -> ServiceType? {
        if serviceRegistrationCompleted == false {
            assert(false, "Trying to get service instance before all service registration completes")
        }
        
        if let instanceType = servicesDict[serviceName] {
            let serviceInstance: ServiceProtocol
            // Get existing instance or create new, based on how Service declares itself
            if instanceType.isSingleton {
                serviceInstance = instanceType.sharedInstance
            } else {
                serviceInstance = instanceType.init()
            }
            // Try convert to required type
            return serviceInstance as? ServiceType
        }
        
        return nil
    }
    
    /// Register all services specified in Services.json of the bundles, and then start them one by one.
    ///
    /// - Parameter bundles: Bundles array that contain Services.json. 
    /// Note: If any bundle doesn't contain Services.json or it's incorrectly formed, an assert would be triggered.
    public class func registerAndStartAllServices(in bundles: [Bundle]) {
        do {
            try self.registerAllServices(in: bundles)
        } catch {
            assert(false, "Service registration error: \(error)")
        }
        
        self.startAllServices()
    }
    
    // MARK: Private func
    
    private class func registerAllServices(in bundles: [Bundle]) throws {
        logger?.info("Start registerAllServices")
        
        // Enumerate bundles
        try bundles.forEach { (bundle: Bundle) in
            guard let namespace = bundle.infoDictionary?["CFBundleExecutable"] as? String else {
                throw ServiceManagerError.bundleReadError
            }
            
            let serviceClassDict = try self.getServiceDictionary(in: bundle)
            
            // Enumerate service name/class pair
            try serviceClassDict.forEach { (serviceName, serviceClassNameString) in
                // Get full class name
                let serviceClassFullName = "\(namespace).\(serviceClassNameString)"
                
                // Get class from name
                if let serviceClass: ServiceProtocol.Type = bundle.classNamed(serviceClassFullName) as? ServiceProtocol.Type {
                    // Register service
                    try self.register(instanceType: serviceClass, serviceName: serviceName)
                    
                    // Call onRegister on the class to perform any additional custom registration
                    serviceClass.onRegister()
                } else {
                    assert(false, "Service: \(serviceClassFullName) declared, but not found in bundle: \(namespace)")
                    throw ServiceManagerError.serviceClassMissing
                }
            }
        }
        
        serviceRegistrationCompleted = true
    }
    
    private class func getServiceDictionary(in bundle: Bundle) throws -> [String: String] {
        // Check if Services.json exists
        if let jsonPath = bundle.path(forResource: "Services", ofType: "json") {
            
            // Read json file
            let url = URL(fileURLWithPath: jsonPath)
            
            let servicesObject: Any?
            do {
                let jsonData = try Data(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                servicesObject = (jsonObject as? [String: Any])?["Services"]
            } catch {
                assert(false, "Bundle: \(bundle) reading services json error: \(error)")
                throw ServiceManagerError.serviceJsonParseError
            }
            
            // Parse json
            if let serviceClassDict = servicesObject as? [String: String] {
                return serviceClassDict
            } else {
                throw ServiceManagerError.serviceJsonParseError
            }
        } else {
            assert(false, "Services.json not found in bundle: \(bundle)")
            throw ServiceManagerError.serviceJsonMissing
        }
    }

    private class func register(instanceType: ServiceProtocol.Type, serviceName: String) throws {
        guard servicesDict[serviceName] == nil else {
            assert(false, "\(serviceName) has already been registered to class: \(servicesDict[serviceName]!)")
            throw ServiceManagerError.serviceAlreadyRegistered
        }
        
        servicesDict[serviceName] = instanceType
        logger?.info("Register service class: \(instanceType) with name: \(serviceName) completed")
    }
    
    private class func startAllServices() {
        self.servicesDict.forEach { (serviceName, serviceClass) in
            // Start service
            // Note: startService only makes sense when serviceClass is singleton
            if serviceClass.isSingleton {
                logger?.info("Starting service: \(serviceName)")
                serviceClass.sharedInstance.startService()
            }
        }
    }
}
