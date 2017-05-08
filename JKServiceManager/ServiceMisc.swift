//
//  ServiceMisc.swift
//  Pods
//
//  Created by Jason Yu on 5/6/17.
//
//

import Foundation

public enum ServiceManagerError: Error {
    case serviceAlreadyRegistered
    case serviceJsonParseError
    case serviceJsonMissing
    case serviceClassMissing
    case bundleReadError
}
