import UIKit
import StoreKit

final class ExternalAccountManagementError: Error {

    let reason: String
    var localizedDescription: String { return reason }

    init(reason: String) {
        self.reason = reason
    }
}

@objc public class ExternalAccountManagement: NSObject {
    let accountManagementURL: URL
    private let organizationName: String
    static let moreInformationURL = URL(string: "https://apps.apple.com/story/id1614232807")!

    public init(languageCode: String = "*", organizationName: String) {
        let urlStrings = Bundle.main.infoDictionary?["SKExternalLinkAccount"] as! [String: String]
        let url = urlStrings[languageCode]!

        self.accountManagementURL = URL(string: url)!
        self.organizationName = organizationName
    }

    public func openAccountManagement(on viewController: UIViewController) throws {
        guard #available(iOS 15, *) else { return UIApplication.shared.open(accountManagementURL) }
        guard AppStore.canMakePayments else { throw ExternalAccountManagementError(reason: "Couldn't make purchase") }

        if #available(iOS 16, *) {
            Task {
                if await ExternalLinkAccount.canOpen {
                    try await ExternalLinkAccount.open()
                } else {
                    throw ExternalAccountManagementError(reason: "Couldn't make purchase")
                }
            }
        } else {
            // iOS 15-implementation
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                showPhoneSheet(on: viewController)
            case .pad:
                showPadSheet(on: viewController)
            case .tv, .unspecified, .carPlay, .mac, .vision:
                throw ExternalAccountManagementError(reason: "Unsupported device")
            @unknown default:
                throw ExternalAccountManagementError(reason: "Unknown error")
            }
        }
    }

    @available(iOS 15, *)
    private func showPhoneSheet(on viewController: UIViewController) {
        let contentViewController = ExternalLinkInformationViewController(accountManagementURL: accountManagementURL, organizationName: organizationName)
        contentViewController.modalPresentationStyle = .pageSheet

        viewController.present(contentViewController, animated: true)
    }

    @available(iOS 15, *)
    private func showPadSheet(on viewController: UIViewController) {
        guard let screenSize = viewController.view.window?.screen.bounds else { return }

        let contentViewController = ExternalLinkInformationViewController(accountManagementURL: accountManagementURL, organizationName: organizationName)
        contentViewController.modalPresentationStyle = .formSheet
        contentViewController.preferredContentSize.width = 624
        contentViewController.preferredContentSize.height = min(screenSize.width, screenSize.height) - 44.0 - 44.0

        viewController.present(contentViewController, animated: true)
    }
}
