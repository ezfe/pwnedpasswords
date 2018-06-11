import Foundation
import Vapor

public class PwnedPasswordsRequest {
    let request: Request
    
    init(_ request: Request) {
        self.request = request
    }
    
    public func send(short: String, long: String) throws -> Future<Bool> {
        let client = try request.make(Client.self)
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
