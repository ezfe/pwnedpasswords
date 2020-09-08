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
    private let eventLoop: EventLoop

    fileprivate init(client: Client, eventLoop: EventLoop) {
        self.client = client
        self.eventLoop = eventLoop
    }
    
    public enum PwnedPasswordsError: Error {
        case dataConversionError
        case apiResponseParseError
        case hashError
    }
    
    public func test(password: String) -> EventLoopFuture<Bool> {
        guard let utf8Data = password.data(using: .utf8) else {
            return self.eventLoop.makeFailedFuture(PwnedPasswordsError.dataConversionError)
        }
        
        let hash = Data(Crypto.Insecure.SHA1.hash(data: utf8Data)).hexEncodedString()

        return send(hash)
    }
    
    private func send(_ searchHash: String) -> EventLoopFuture<Bool> {
        guard searchHash.count == 40 else {
            return self.eventLoop.makeFailedFuture(PwnedPasswordsError.hashError)
        }

        let prefix = searchHash.prefix(5)
        let suffix = searchHash.suffix(35)

        let url = URI(string: "https://api.pwnedpasswords.com/range/\(prefix)")
        let headers = HTTPHeaders([("Add-Padding", "true")])

        return self.client.get(url, headers: headers).flatMapThrowing { res in
            let result = try res.content.decode(String.self)
            let lines = result.split { $0.isNewline }
            for line in lines {
                guard let separator = line.firstIndex(of: ":") else {
                    throw PwnedPasswordsError.apiResponseParseError
                }

                if line[..<separator] == suffix {
                    guard let count = Int(line[separator...]) else {
                        throw PwnedPasswordsError.apiResponseParseError
                    }

                    return count > 0
                }
            }

            return false
        }
    }
}

public extension Request {
    var pwnedPasswords: PwnedPasswords {
        .init(client: self.client, eventLoop: self.eventLoop)
    }
}

