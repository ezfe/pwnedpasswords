import XCTest
@testable import PwnedPasswords
@testable import Vapor

class PwnedPasswordsTests: XCTestCase {
    func testBreached() throws {
        
        let application = try Application()
        let client = try application.client()
        let pwned = PwnedPasswords()
        
        let breached = try pwned.testPassword(client, password: "password").wait()
        
        XCTAssertEqual(breached, true)
    }
    
    func testNotBreached() throws {
        let application = try Application()
        let client = try application.client()
        let pwned = PwnedPasswords()
        
        let breached = try pwned.testPassword(client, password: "iamnotbreachedWuHuu").wait()
        
        XCTAssertEqual(breached, false)
    }
    
    static let allTests = [
        ("testBreached", testBreached),
        ("testNotBreached", testNotBreached)
    ]
}
