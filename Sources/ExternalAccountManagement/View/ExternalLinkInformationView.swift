import UIKit

protocol ExternalLinkInformationViewDelegate: AnyObject {
    func showMoreInformation()
    func continueToAccountManagement()
    func cancel()
}

@available(iOS 15.0, *)
internal class ExternalLinkInformationView: UIView {

    weak var delegate: ExternalLinkInformationViewDelegate?

    private let contentStackView: UIStackView
    private let contentScrollView: UIScrollView

    let titleLabel: UILabel
    let descriptionLabel: UILabel
    let learnMoreButton: UIButton

    private let buttonStackView: UIStackView
    let confirmationButton: UIButton
    let cancelButton: UIButton

    init(organizationName: String) {
        let bundle = Bundle.module

        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(
            ofSize: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).pointSize,
            weight: .bold
        )
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label
        titleLabel.text = NSLocalizedString("AppStore.FullSheet.ExternalPurchases.Title", bundle: bundle, comment: "")

        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(
            ofSize: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).pointSize,
            weight: .bold
        )
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .label
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        let descriptionFormatString = NSLocalizedString("AppStore.FullSheet.ExternalPurchases.Body", bundle: bundle, comment: "")
        descriptionLabel.text = String(format: descriptionFormatString, organizationName)

        var learnMoreButtonConfiguration = UIButton.Configuration.plain()
        learnMoreButtonConfiguration.attributedTitle = AttributedString(NSLocalizedString("AppStore.FullSheet.ExternalPurchases.LearnMore", bundle: bundle, comment: ""), attributes: .init([
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont.preferredFont(forTextStyle: .body)
        ]))
        learnMoreButtonConfiguration.titleAlignment = .center

        learnMoreButton = UIButton(configuration: learnMoreButtonConfiguration)

        contentStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, learnMoreButton])
        contentStackView.setCustomSpacing(16, after: titleLabel)
        contentStackView.setCustomSpacing(16, after: descriptionLabel)
        contentStackView.alignment = .center
        contentStackView.axis = .vertical
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        contentScrollView = UIScrollView()
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.addSubview(contentStackView)

        var confirmationButtonConfiguration = UIButton.Configuration.filled()
        confirmationButtonConfiguration.baseBackgroundColor = .secondarySystemBackground
        confirmationButtonConfiguration.attributedTitle = AttributedString(NSLocalizedString("AppStore.FullSheet.ExternalPurchases.Action1", bundle: bundle, comment: ""), attributes: .init([
            .font: UIFont.systemFont(ofSize: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize, weight: .semibold),
            .foregroundColor: UIColor.systemBlue
        ]))
        confirmationButtonConfiguration.background.cornerRadius = 14

        confirmationButton = UIButton(configuration: confirmationButtonConfiguration)
        confirmationButton.translatesAutoresizingMaskIntoConstraints = false

        var cancelButtonConfiguration = UIButton.Configuration.filled()
        cancelButtonConfiguration.baseBackgroundColor = .secondarySystemBackground
        cancelButtonConfiguration.attributedTitle = AttributedString(NSLocalizedString("AppStore.FullSheet.ExternalPurchases.Action2", bundle: bundle, comment: ""), attributes: .init([
            .font: UIFont.systemFont(ofSize: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize, weight: .semibold),
            .foregroundColor: UIColor.systemBlue
        ]))
        cancelButtonConfiguration.background.cornerRadius = 14

        cancelButton = UIButton(configuration: cancelButtonConfiguration)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        buttonStackView = UIStackView(arrangedSubviews: [confirmationButton, cancelButton])
        buttonStackView.axis = .vertical
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.spacing = 12

        super.init(frame: .zero)

        confirmationButton.addTarget(self, action: #selector(ExternalLinkInformationView.continueToAccountManagement(_:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(ExternalLinkInformationView.cancel(_:)), for: .touchUpInside)
        learnMoreButton.addTarget(self, action: #selector(ExternalLinkInformationView.showMoreInformation(_:)), for: .touchUpInside)

        addSubview(contentScrollView)
        addSubview(buttonStackView)
        backgroundColor = .systemBackground

        if UIDevice.current.userInterfaceIdiom == .phone {
            setPhoneConstraints()
            contentScrollView.contentInset.top = 70
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            setPadConstraints()
            contentScrollView.contentInset.top = 88
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setPhoneConstraints() {
        let constraints = [
            confirmationButton.heightAnchor.constraint(equalToConstant: 50),
            confirmationButton.widthAnchor.constraint(lessThanOrEqualToConstant: 360),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.widthAnchor.constraint(lessThanOrEqualToConstant: 360),
            buttonStackView.widthAnchor.constraint(lessThanOrEqualToConstant: 360),

            buttonStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonStackView.leadingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.leadingAnchor),
            layoutMarginsGuide.trailingAnchor.constraint(lessThanOrEqualTo: buttonStackView.trailingAnchor),
            bottomAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 27),

            contentScrollView.topAnchor.constraint(equalTo: topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            layoutMarginsGuide.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            buttonStackView.topAnchor.constraint(equalTo: contentScrollView.bottomAnchor, constant: 24),

            contentStackView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor),

            contentScrollView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),

        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func setPadConstraints() {
        let constraints = [
            confirmationButton.heightAnchor.constraint(equalToConstant: 50),
            confirmationButton.widthAnchor.constraint(equalToConstant: 360),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.widthAnchor.constraint(equalToConstant: 360),
            buttonStackView.widthAnchor.constraint(equalToConstant: 360),

            buttonStackView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor, constant: 44),
            contentScrollView.trailingAnchor.constraint(equalTo: buttonStackView.trailingAnchor, constant: 44),
            bottomAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 40),

            contentScrollView.topAnchor.constraint(equalTo: topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 88),
            trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor, constant: 88),
            buttonStackView.topAnchor.constraint(equalTo: contentScrollView.bottomAnchor, constant: 24),
            contentStackView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor),

            contentScrollView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Actions

    @objc private func cancel(_ sender: UIButton) {
        delegate?.cancel()
    }

    @objc private func continueToAccountManagement(_ sender: UIButton) {
        delegate?.continueToAccountManagement()
    }

    @objc private func showMoreInformation(_ sender: UIButton) {
        delegate?.showMoreInformation()
    }

}
