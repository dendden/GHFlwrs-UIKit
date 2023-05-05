//
//  GFAlertVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 26.04.2023.
//

import UIKit

class GFAlertVC: UIViewController {

    let container = GFAlertContainerView()
    let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = GFBodyLabel(textAlignment: .center)
    let actionButton = GFButton(buttonColor: .systemPink, title: "OK")

    private var alertTitle: String?
    private var alertMessage: String?
    private var buttonTitle: String?

    private var alertCompletion: (() -> Void)?

    let padding: CGFloat = 20

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

    func configureContainerView() {
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.widthAnchor.constraint(equalToConstant: 280),
            container.heightAnchor.constraint(equalToConstant: 220)
        ])
    }

    func configureTitleLabel() {
        titleLabel.text = alertTitle ?? "Alert [No Title]"

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    func configureActionButton() {
        actionButton.setTitle(buttonTitle ?? "OK", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)

        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc func dismissVC() {
        dismiss(animated: true)
        if let completion = alertCompletion {
            completion()
        }
    }

    func configureMessageLabel() {
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
