import Vapor
import Foundation
import Async
import HTTP
import TCP
import TLS
#if os(Linux)
import OpenSSL
#else
import AppleTLS
#endif

public class PwnedPasswordsRequest {

    init() { }
    
    public func send(short: String, long: String) throws -> Bool {
        var breached: Bool = false
        
        let eventLoop = try DefaultEventLoop(label: "codes.vapor.http.test.client")

        let tcpSocket = try TCPSocket(isNonBlocking: true)
        let tcpClient = try TCPClient(socket: tcpSocket)
        var settings = TLSClientSettings()
        settings.peerDomainName = "api.pwnedpasswords.com"
        
        #if os(macOS)
            let tlsClient = try AppleTLSClient(tcp: tcpClient, using: settings)
        #else
            let tlsClient = try OpenSSLClient(tcp: tcpClient, using: settings)
        #endif
        
        try tlsClient.connect(hostname: "api.pwnedpasswords.com", port: 443)
        let client = HTTPClient(
            stream: tlsClient.socket.stream(on: eventLoop),
            on: eventLoop
        )
        let req = HTTPRequest(method: .get, uri: URI(path: "/range/\(short)"), headers: [.host: "api.pwnedpasswords.com"])
        let res = try client.send(req).flatMap(to: Data.self) { res in
            return res.body.makeData(max: 10_000_000)
        }.await(on: eventLoop)
        
        let result = String(data: res, encoding: .utf8) ?? ""
        
        let data = result.split(separator: "\r\n")
        
        for line in data {
            let lineOriginal = "\(short)\(line)".truncated(40)
            
            if (lineOriginal == long.uppercased()) {
                breached = true
            }
        }
        
        return breached
    }
}
