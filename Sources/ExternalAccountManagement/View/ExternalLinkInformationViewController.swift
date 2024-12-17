import UIKit
import StoreKit

@available(iOS 15.0, *)
internal class ExternalLinkInformationViewController: UIViewController {

    let accountManagementURL: URL
    let organizationName: String
    var contentView: ExternalLinkInformationView { view as! ExternalLinkInformationView }

    init(accountManagementURL: URL, organizationName: String) {
        self.accountManagementURL = accountManagementURL
        self.organizationName = organizationName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func loadView() {
        let contentView = ExternalLinkInformationView(organizationName: organizationName)
        contentView.delegate = self

        view = contentView
    }
}

@available(iOS 15.0, *)
extension ExternalLinkInformationViewController: @preconcurrency ExternalLinkInformationViewDelegate {
    func showMoreInformation() {
        UIApplication.shared.open(ExternalAccountManagement.moreInformationURL)
    }

    func continueToAccountManagement() {
        UIApplication.shared.open(accountManagementURL)
    }
    
    func cancel() {
        dismiss(animated: true)
    }
}
