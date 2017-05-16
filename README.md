# JKServiceManager

[![Version](https://img.shields.io/cocoapods/v/JKServiceManager.svg?style=flat)](http://cocoapods.org/pods/JKServiceManager)
[![License](https://img.shields.io/cocoapods/l/JKServiceManager.svg?style=flat)](http://cocoapods.org/pods/JKServiceManager)
[![Platform](https://img.shields.io/cocoapods/p/JKServiceManager.svg?style=flat)](http://cocoapods.org/pods/JKServiceManager)
[![Build Status](https://travis-ci.org/jike-engineering/JKServiceManager.svg?branch=master)](https://travis-ci.org/jike-engineering/JKServiceManager)

JKServiceManager is a lightweight manager for registering and invoking custom services(app modules), written in Swift.

## Inspiration

In [Jike](https://www.okjike.com) app, due to rapid growth of modules for various business, we need a modulized architecture for several causes:

* **Faster compilation speed**, which matters a lot to Swift developers :)
* **Decoupled business logic**, each module can be maintained and tested by different people
* **Unified service invocation style**, take full advantage of Swift language features for simplest code

## Usage

### 1. Define Service Protocol
```Swift
// Define a service protocol
public protocol TestServiceProtocol: ServiceProtocol {
    func doTestJob()
}

// Extend Services class with typed static member for convenience
// Otherwise each caller needs to call (ServiceManager.getInstance(for: "testService") as? TestServiceProtocol)
extension Services {
    public static var test: TestServiceProtocol? {
        return ServiceManager.getInstance(for: "testService")
    }
}
```

### 2. Implement Service
```Swift
// Implement of a service protocol. Can be defined in another framework/module for decoupling.
class TestService: TestServiceProtocol {
    static var isSingleton: Bool = true
    
    static var sharedInstance: ServiceProtocol = TestService()
    
    public required init() {}
    
    func doTestJob() {
        print("Test service instance is doing job")
    }
}
```

### 3. Add to Services.json
```json
{
    "Services": {
        "testService": "TestService"
    }
}
```

### 4. Invoke Service
```Swift
// Register and start all services at app launch
ServiceManager.registerAndStartAllServices(in: [Bundle.main])

Services.test?.doTestJob()
```
Simple enough?

## Architecture

![](http://ww1.sinaimg.cn/large/006tKfTcgy1fff8ns54jyj30mx0ll75x.jpg)

We have a 3 level architecture in Jike app. 
From top to bottom:

* **Services**: Implement services, which conform to corresponding service protocols
* **Common**: Define service protocols, meant to be imported by all business modules
* **Core**: Infrastructure of app, including JKServiceManager

## Example

See example folder.

## Requirements

- iOS 8.0+
- Swift 3.0+

## Installation

JKServiceManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JKServiceManager"
```


## License

JKServiceManager is available under the MIT license. See the LICENSE file for more info.
