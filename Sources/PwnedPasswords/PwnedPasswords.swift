import Foundation
import Crypto

fileprivate extension Data {
	func hexEncodedString() -> String {
		return self.map { String(format: "%02hhX", $0) }.joined()
	}
}

public struct PwnedPasswords {
	public enum PwnedPasswordsError: Error {
		case dataConversionError
		case apiRequestError(String)
		case apiResponseParseError
		case hashError
	}
	
	public static func test(password: String) async throws -> Bool {
		guard let utf8Data = password.data(using: .utf8) else {
			throw PwnedPasswordsError.dataConversionError
		}
		
		let hash = Data(Crypto.Insecure.SHA1.hash(data: utf8Data)).hexEncodedString()
		
		return try await send(hash)
	}
	
	private static func send(_ searchHash: String) async throws -> Bool {
		guard searchHash.count == 40 else {
			throw PwnedPasswordsError.hashError
		}
		
		let prefix = searchHash.prefix(5)
		let suffix = searchHash.suffix(35)
		
		guard let url = URL(string: "https://api.pwnedpasswords.com/range/\(prefix)") else {
			throw PwnedPasswordsError.apiRequestError("Unable to build URL")
		}
		var request = URLRequest(url: url)
		request.setValue("true", forHTTPHeaderField: "Add-Padding")
		guard let (data, _) = try? await URLSession.shared.data(for: request) else {
			throw PwnedPasswordsError.apiRequestError("Network request failed")
		}
			
		guard let result = String(data: data, encoding: .utf8) else {
			throw PwnedPasswordsError.apiResponseParseError
		}
			
		let lines = result.split { $0.isNewline }
		for line in lines {
			guard let separator = line.firstIndex(of: ":") else {
				throw PwnedPasswordsError.apiResponseParseError
			}
			
			if line[..<separator] == suffix {
				guard let count = Int(line[separator...].dropFirst()) else {
					throw PwnedPasswordsError.apiResponseParseError
				}
				
				return count > 0
			}
		}
			
		return false
	}
}
