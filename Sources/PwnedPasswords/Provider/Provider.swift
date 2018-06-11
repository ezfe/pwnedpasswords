import Foundation
import Vapor

public final class PwnedPasswordsProvider: Provider {
    public static let repositoryName = "pwnedpasswords-provider"
    
    public func didBoot(_ container: Container) throws -> Future<Void> {
        return Future.done(on: container)
    }

	public func register(_ services: inout Services) throws {
        services.register { (container) -> PwnedPasswords in
            return PwnedPasswords()
        }
    }
}
