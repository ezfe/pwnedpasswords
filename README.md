# Vapor PwnedPasswords Provider

![Swift](http://img.shields.io/badge/swift-4.1-brightgreen.svg)
![Vapor](http://img.shields.io/badge/vapor-3.0-brightgreen.svg)
[![CircleCI](https://circleci.com/gh/joscdk/pwnedpasswords-provider/tree/master.svg?style=svg)](https://circleci.com/gh/joscdk/pwnedpasswords-provider/tree/master)

This packages provides an easy way to test a password against https://haveibeenpwned.com/API/v2#PwnedPasswords in your Vapor app.

## Getting started

### Vapor 2

WIP.

### Vapor 3

In your `Package.swift` add:

```swift
.package(url: "https://github.com/joscdk/pwnedpasswords-provider.git", .from: 2.0.0-beta)
```

Then to test a password, run e.g.:

```swift
import PwnedPasswords

router.get("password") { req -> String in
        
        let breached = try PwnedPasswords().testPassword(req.eventLoop, peassword: "password")
        
        if (breached) {
        	print("Password breached")
        } else {
        	print("Password is not breached")
	}
}
```

You need to parse the password in as plaintext.

## Security note

No passwords will ever leave the server in plaintext.

Pwned Passwords V2 uses https://en.wikipedia.org/wiki/K-anonymity to protect passwords. You can read more about it here: https://blog.cloudflare.com/validating-leaked-passwords-with-k-anonymity/

## Thanks

Special thanks to https://www.troyhunt.com/ for providing the API.
