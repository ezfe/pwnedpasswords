import Foundation
import Vapor
import Crypto

fileprivate extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

public struct PwnedPasswords {
    public init() { }
    
    public enum PwnedPasswordsError: Error {
        case dataConversionError
        case apiDataConversionError
    }
    
    public func test(password: String, with client: Client) throws -> EventLoopFuture<Bool> {
        guard let utf8Data = password.data(using: .utf8) else {
            throw PwnedPasswordsError.dataConversionError
        }
        
        let hash = Data(Crypto.Insecure.SHA1.hash(data: utf8Data)).hexEncodedString(options: .upperCase)

        return try send(short: String(hash.prefix(5)), long: hash, using: client)
    }
    
    private func send(short: String, long: String, using client: Client) throws -> EventLoopFuture<Bool> {
        let url = URI(string: "https://api.pwnedpasswords.com/range/\(short)")


        return client.get(url).flatMapThrowing { res in
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

