import Foundation
import Vapor
import Crypto

public struct PwnedPasswords: Service {
    public init() { }
    
    public enum PwnedPasswordsError: Error {
        case dataConversionError
        case apiDataConversionError
    }
    
    public func test(password: String, with client: Client) throws -> Future<Bool> {
        guard let utf8Data = password.data(using: .utf8) else {
            throw PwnedPasswordsError.dataConversionError
        }
        let hash = try SHA1.hash(utf8Data).hexEncodedString(uppercase: true)

        return try send(short: String(hash.prefix(5)), long: hash, using: client)
    }
    
    private func send(short: String, long: String, using client: Client) throws -> Future<Bool> {
        let url = "https://api.pwnedpasswords.com/range/\(short)"
        
        return client.get(url).map(to: Bool.self) { res in
            guard let data = res.http.body.data else {
                throw PwnedPasswords.PwnedPasswordsError.apiDataConversionError
            }
            
            let result = String(data: data, encoding: .utf8) ?? ""
            let lines = result.split(separator: "\r\n")
            for line in lines {
                let lineOriginal = String("\(short)\(line)".prefix(40))
                if lineOriginal == long {
                    return true
                }
            }
            
            return false
        }
    }
}

