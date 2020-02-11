import XCTest
@testable import PwnedPasswords
@testable import Vapor

class PwnedPasswordsTests: XCTestCase {
    func testBreached() throws {
        
        let application = Application()
        let client = application.client
        let pwned = PwnedPasswords()

        let breached = try pwned.test(password: "password", with: client).wait()

        application.shutdown()

        XCTAssertEqual(breached, true)
    }
    
    func testNotBreached() throws {
        let application = Application()
        let client = application.client
        let pwned = PwnedPasswords()
        
        let breached = try pwned.test(password: "iamnotbreachedWuHuu", with: client).wait()

        application.shutdown()

        XCTAssertEqual(breached, false)
    }
    
    static let allTests = [
        ("testBreached", testBreached),
        ("testNotBreached", testNotBreached)
    ]
}
