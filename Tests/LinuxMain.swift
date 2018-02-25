#if os(Linux)

import XCTest
@testable import PwnedPasswordsTests
XCTMain([
    testCase(PwnedPasswordsTests.allTests),
])

#endif

