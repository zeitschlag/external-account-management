# External Account Management

This little package aims to be a helper for your "reader"-app [with a link to your website](https://developer.apple.com/support/reader-apps/).
It implements the required UI for both iPhone and iPad, in other words: It does the "Implementing the in-app modal sheet"-part for you.
You provide it with your organization name and the package shows the sheet. That's it.

This package is based on work for the [German left newspaper _nd_](https://www.nd-aktuell.de).
For now it supports English and German. More localizations might follow.
Issue tracker [lives on Github](https://github.com/zeitschlag/external-account-management/issues).

## Prerequisites

These are general requirements from Apple. The `ExternalAccountManagement` relies on you fulfilling them.

- Your app needs the _External Link Account Entitlement_ from Apple. `com.apple.developer.storekit.external-link.account` must be set to `YES`.
- You need to define the URLs you want to link to in your `Info.plist`. Use `SKExternalLinkAccount` as key and dictionary as type.
- In that dictionary, there must be an entry for key `*`.

## Usage

1. Add the Swift package as dependency to your Xcode project.
2. `import ExternalAccountManagement` 
3. Use package:
```swift
let accountManagement = ExternalAccountManagement(organizationName: "Evil Corp.")
try! accountManagement.openAccountManagement(on: viewController) //TODO: Error Handling
```

If something goes wrong, the package throws an error. You're responsible to handle that error.

_Please note: macOS, tvOS, visionOS et al. are not supprted. Also no SwiftUI. Also no Cocoapods._
