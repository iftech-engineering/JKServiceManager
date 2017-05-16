// https://github.com/Quick/Quick

import Quick
import Nimble
import JKServiceManager

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        describe("can register service") {
            let testBundle = Bundle(for: TableOfContentsSpec.self)
            ServiceManager.registerAndStartAllServices(in: [testBundle])
            
            
        }
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
