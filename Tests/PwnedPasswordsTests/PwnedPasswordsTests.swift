import XCTest
@testable import PwnedPasswords
@testable import Vapor

class PwnedPasswordsTests: XCTestCase {
    func testBreached() throws {
        
        let breached = try PwnedPasswords().testPassword(password: "password")
        
        XCTAssertEqual(breached, true)
    }
    
    func testNotBreached() throws {
        
        let breached = try PwnedPasswords().testPassword(password: "iamnotbreachedWuHuu")
        
        XCTAssertEqual(breached, false)
    }
    
    static let allTests = [
        ("testBreached", testBreached),
        ("testNotBreached", testNotBreached)
    ]
}
