//
//  GFAlertVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 26.04.2023.
//

import UIKit

/// A custom Alert `UIViewController` presented with a full-screen
/// transparent black background and a centered container with alert content.
class GFAlertVC: UIViewController {

    // MARK: - Class variables

    private var alertTitle: String?
    private var alertMessage: String?
    private var buttonTitle: String?

    private var alertCompletion: (() -> Void)?

    /// Default padding of 20 pts for alert container elements.
    let padding: CGFloat = 20

    // MARK: - View variables

    /// A container view for alert content.
    let container = GFAlertContainerView()

    /// Alert ``GFTitleLabel`` with `.center` text alignment and font size of 20.
    let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 20)

    /// Alert ``GFBodyLabel`` message label with `.center` text alignment.
    let messageLabel = GFBodyLabel(textAlignment: .center)

    /// Alert button with `.systemPink` color and default title of "OK".
    let actionButton = GFButton(color: .systemPink, title: "OK")

    // MARK: -
    /// Creates an instance of  ``GFAlertVC``.
    /// - Parameters:
    ///   - alertTitle: A title for alert.
    ///   - alertMessage: A message that alert conveys.
    ///   - buttonTitle: A title for alert button. Default vale is "**OK**".
    ///   - completion: An optional completion handler to execute when
    ///   alert is dismissed.
    init(alertTitle: String, alertMessage: String, buttonTitle: String? = "OK", completion: (() -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)

        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.buttonTitle = buttonTitle

        self.alertCompletion = completion
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black.withAlphaComponent(0.75)
        view.addSubviews(container, titleLabel, messageLabel, actionButton)

        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureMessageLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Lays out constraints for alert ``container`` view.
    private func configureContainerView() {
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.widthAnchor.constraint(equalToConstant: 280),
            container.heightAnchor.constraint(equalToConstant: 220)
        ])
    }

    /// Sets ``titleLabel`` text to the value of `alertTitle` or default
    /// "*"Alert [No Title]"*" text, lays out constraints  within alert ``container``.
    private func configureTitleLabel() {
        titleLabel.text = alertTitle ?? "Alert [No Title]"

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    /// Sets ``actionButton`` title to the value of `buttonTitle` or default "*OK*" text,
    /// adds target to dismiss alert on button tap, and lays out constraints within alert ``container``.
    private func configureActionButton() {
        actionButton.setTitle(buttonTitle ?? "OK", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)

        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    /// Dismisses this alert view and executes the optional completion handler passed at initialization.
    @objc private func dismissVC() {
        dismiss(animated: true)
        if let completion = alertCompletion {
            completion()
        }
    }

    /// Sets ``messageLabel`` text to the value of `alertMessage` or default
    /// "*[Alert details n/a]*" text, sets `lineLimit` to 4, and lays out constraints
    /// within alert ``container``.
    private func configureMessageLabel() {
        messageLabel.text = alertMessage ?? "[Alert details n/a]"
        messageLabel.numberOfLines = 4

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }

}
