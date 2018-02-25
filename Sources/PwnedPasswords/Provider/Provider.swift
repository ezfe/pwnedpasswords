import Vapor
import Crypto
import Foundation

public final class PwnedPasswordsProvider: Provider {
    public static let repositoryName = "pwnedpasswords-provider"
    
    public func boot(_ worker: Container) throws {}
    
	public func register(_ services: inout Services) throws {
        services.register { (container) -> PwnedPasswords in
            return PwnedPasswords()
        }
    }
}
