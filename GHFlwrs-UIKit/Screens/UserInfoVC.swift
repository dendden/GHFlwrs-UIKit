//
//  UserInfoVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 02.05.2023.
//

import UIKit

class UserInfoVC: UIViewController {

    var username: String!

    let headerView = UIView()
    let itemCardViewOne = UIView()
    let itemCardViewTwo = UIView()

    var childViews: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        getUserInfo(for: username)
        layoutUI()
    }

    private func configure() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        title = username
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }

    @objc private func dismissVC() {
        dismiss(animated: true)
    }

    private func getUserInfo(for username: String) {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in

            guard let self = self else { return }

            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
                }
            case .failure(let failure):
                self.presentGFAlertOnMainThread(title: "Oops.. 🫣", message: failure.rawValue) {
                    self.dismiss(animated: true)
                }
            }
        }
    }

    private func layoutUI() {

        let padding: CGFloat = 20
        let itemCardHeightMultiplier = 0.4

        childViews = [headerView, itemCardViewOne, itemCardViewTwo]

        for child in childViews {
            view.addSubview(child)
            child.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                child.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                child.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }

        headerView.backgroundColor = .systemMint
        itemCardViewOne.backgroundColor = .systemIndigo
        itemCardViewTwo.backgroundColor = .systemCyan

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55),

            itemCardViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemCardViewOne.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: itemCardHeightMultiplier),

            itemCardViewTwo.topAnchor.constraint(equalTo: itemCardViewOne.bottomAnchor, constant: padding),
            itemCardViewTwo.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: itemCardHeightMultiplier)
        ])
    }

    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }

}
