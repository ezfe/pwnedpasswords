import Foundation
import Vapor
import Crypto

fileprivate extension Data {
    func hexEncodedString() -> String {
        return self.map { String(format: "%02hhX", $0) }.joined()
    }
}

public struct PwnedPasswords {
    private let client: Client

    init(client: Client) {
        self.client = client
    }
    
    public enum PwnedPasswordsError: Error {
        case dataConversionError
        case apiDataConversionError
    }
    
    public func test(password: String) throws -> EventLoopFuture<Bool> {
        guard let utf8Data = password.data(using: .utf8) else {
            throw PwnedPasswordsError.dataConversionError
        }
        
        let hash = Data(Crypto.Insecure.SHA1.hash(data: utf8Data)).hexEncodedString()

        return try send(short: String(hash.prefix(5)), long: hash)
    }
    
    private func send(short: String, long: String) throws -> EventLoopFuture<Bool> {
        let url = URI(string: "https://api.pwnedpasswords.com/range/\(short)")


        return self.client.get(url).flatMapThrowing { res in
            let result = try res.content.decode(String.self)
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

public extension Request {
    var pwnedPasswords: PwnedPasswords {
        .init(client: self.client)
    }
}

