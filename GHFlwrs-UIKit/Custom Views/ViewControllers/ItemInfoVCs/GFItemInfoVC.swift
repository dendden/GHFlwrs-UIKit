//
//  GFItemInfoVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 03.05.2023.
//

import UIKit

/// A superclass for item info cards displayed in ``UserInfoVC``.
class GFItemInfoVC: UIViewController {

    /// A horizontal stack containing two ``GFItemInfoView`` views.
    let itemsStackView = UIStackView()
    let leftItemInfoView = GFItemInfoView()
    let rightItemInfoView = GFItemInfoView()
    /// The button that performs an action from this card.
    let actionButton = GFButton()

    /// A ``User`` whose information is displayed in info card view.
    var user: User!

    /// Creates an instance of ``GFItemInfoVC``.
    /// - Parameter user: The ``User``, whose information must
    /// be displayed in info card view.
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureBackground()
        configureStackView()
        configureActionButton()
        layoutUI()
    }

    /// Sets cards's corner radius to 18 pts and background color
    /// to `.secondarySystemBackground`.
    private func configureBackground() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }

    /// Configures the horizontal ``itemsStackView`` and adds its
    /// arranged subviews.
    private func configureStackView() {
        itemsStackView.axis = .horizontal
        itemsStackView.distribution = .equalSpacing

        itemsStackView.addArrangedSubview(leftItemInfoView)
        itemsStackView.addArrangedSubview(rightItemInfoView)
    }

    /// Sets target and action for ``actionButton``.
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }

    /// Generic superclass function to be overridden by subclass card views.
    @objc func actionButtonTapped() {}

    /// Adds subviews to card and lays out their constraints.
    private func layoutUI() {
        view.addSubviews(itemsStackView, actionButton)

        itemsStackView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20

        NSLayoutConstraint.activate([
            itemsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            itemsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemsStackView.heightAnchor.constraint(equalToConstant: 50),

            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
