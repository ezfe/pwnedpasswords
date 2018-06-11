import Foundation
import Vapor
import Crypto

public struct PwnedPasswords: Service {
    public init() { }
    
    public enum PwnedPasswordsError: Error {
        case dataConversionError
        case apiDataConversionError
    }
    
    public func testPassword(_ request: Request, password: String) throws -> Future<Bool> {
        guard let utf8Data = password.data(using: .utf8) else {
            throw PwnedPasswordsError.dataConversionError
        }
        let hash = try SHA1.hash(utf8Data).hexEncodedString(uppercase: true)

        return try PwnedPasswordsRequest(request).send(short: String(hash.prefix(5)), long: hash)
    }
}
