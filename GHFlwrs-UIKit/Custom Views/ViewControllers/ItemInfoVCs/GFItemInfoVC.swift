//
//  GFItemInfoVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 03.05.2023.
//

import UIKit

class GFItemInfoVC: UIViewController {

    let itemsStackView = UIStackView()
    let leftItemInfoView = GFItemInfoView()
    let rightItemInfoView = GFItemInfoView()
    let actionButton = GFButton()

    var user: User!

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
        layoutUI()
    }

    private func configureBackground() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }

    private func configureStackView() {
        itemsStackView.axis = .horizontal
        itemsStackView.distribution = .equalSpacing

        itemsStackView.addArrangedSubview(leftItemInfoView)
        itemsStackView.addArrangedSubview(rightItemInfoView)
    }

    private func layoutUI() {
        view.addSubview(itemsStackView)
        view.addSubview(actionButton)

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
