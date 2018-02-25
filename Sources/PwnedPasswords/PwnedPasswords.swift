import Vapor
import Crypto
import Foundation

public struct PwnedPasswords: Service {
    public func testPassword(password: String) throws -> Bool {
        let hashed = SHA1.hash(Data(password.utf8)).hexString.uppercased()
        
        return try PwnedPasswordsRequest().send(short: hashed.truncated(5), long: hashed)
    }
}

extension String {
    func truncated(_ limit: Int) -> String {
        return String(characters.prefix(limit))
    }
}
