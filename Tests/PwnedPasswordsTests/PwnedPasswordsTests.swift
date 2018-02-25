import XCTest
@testable import PwnedPasswords
@testable import Vapor

class PwnedPasswordsTests: XCTestCase {
    func testBreached() throws {
        
        let eventLoop = try DefaultEventLoop(label: "codes.vapor.pwned.passwords.test")
        
        let breached = try PwnedPasswords().testPassword(eventLoop, password: "password")
        
        XCTAssertEqual(breached, true)
    }
    
    func testNotBreached() throws {
        let eventLoop = try DefaultEventLoop(label: "codes.vapor.pwned.passwords.test")
        
        let breached = try PwnedPasswords().testPassword(eventLoop, password: "iamnotbreachedWuHuu")
        
        XCTAssertEqual(breached, false)
    }
    
    static let allTests = [
        ("testBreached", testBreached),
        ("testNotBreached", testNotBreached)
    ]
}
