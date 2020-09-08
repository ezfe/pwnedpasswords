# Vapor PwnedPasswords Provider

![Swift](http://img.shields.io/badge/swift-5.2-brightgreen.svg)
![Vapor](http://img.shields.io/badge/vapor-4.0-brightgreen.svg)

This packages provides an easy way to test a password against https://haveibeenpwned.com/API/v2#PwnedPasswords in your Vapor app.

This package is a fork of [joscdk/pwnedpasswords-provider](https://github.com/joscdk/pwnedpasswords-provider)

## Getting started

### Vapor 3

In your `Package.swift` add:

```swift
.package(url: "https://github.com/ezfe/pwnedpasswords-provider.git", .from: "1.0.0")
```

Then to test a password, run e.g.:

```swift
import PwnedPasswords

router.get("password") { req -> String in        
	try PwnedPasswords().test(password: "password", with: req.client()).map { breached in
		if breached {
			print("Password breached")
		} else {
			print("Password is not breached")
		}
	}
}
```

You need to parse the password in as plaintext.

## Security note

No passwords will ever leave the server in plaintext.

Pwned Passwords V2 uses https://en.wikipedia.org/wiki/K-anonymity to protect passwords. You can read more about it here: https://blog.cloudflare.com/validating-leaked-passwords-with-k-anonymity/

## Thanks

- Special thanks to https://www.troyhunt.com/ for providing the API.

## TODO

- [ ] Better documentation, and security information
