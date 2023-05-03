//
//  UserInfoVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 02.05.2023.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func didTapGitHubAccount(with urlString: String)
    func didTapGetFollowers(hasFollowers: Bool)
}

class UserInfoVC: UIViewController {

    var username: String!
    weak var followersListDelegate: FollowersListVCDelegate?

    let headerView = UIView()
    let itemCardViewOne = UIView()
    let itemCardViewTwo = UIView()
    let dateLabel = GFSubtitleLabel(fontSize: 14, textAlignment: .center)

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
                    self.configureUIElementsWith(user: user)
                }
            case .failure(let failure):
                self.presentGFAlertOnMainThread(title: "Oops.. 🫣", message: failure.rawValue) {
                    self.dismiss(animated: true)
                }
            }
        }
    }

    private func configureUIElementsWith(user: User) {

        let repoItemVC = GFRepoItemVC(user: user)
        repoItemVC.userInfoDelegate = self

        let followerItemVC = GFFollowerItemVC(user: user)
        followerItemVC.userInfoDelegate = self

        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: repoItemVC, to: self.itemCardViewOne)
        self.add(childVC: followerItemVC, to: self.itemCardViewTwo)
        self.dateLabel.text = "GitHub since " + user.createdAt.shortMonthAndYear
    }

    private func layoutUI() {

        let padding: CGFloat = 20
        let itemCardHeightMultiplier = 0.35

        childViews = [headerView, itemCardViewOne, itemCardViewTwo, dateLabel]

        for child in childViews {
            view.addSubview(child)
            child.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                child.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                child.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55),

            itemCardViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemCardViewOne.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: itemCardHeightMultiplier),

            itemCardViewTwo.topAnchor.constraint(equalTo: itemCardViewOne.bottomAnchor, constant: padding),
            itemCardViewTwo.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: itemCardHeightMultiplier),

            dateLabel.topAnchor.constraint(equalTo: itemCardViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}

extension UserInfoVC: UserInfoVCDelegate {

    func didTapGitHubAccount(with urlString: String) {

        guard let url = URL(string: urlString) else {
            presentGFAlertOnMainThread(
                title: "Broken link 🤬",
                message: "It looks like the link to \(username!)'s profile on GitHub is invalid."
            )
            return
        }

        presentSafariVC(with: url)
    }

    func didTapGetFollowers(hasFollowers: Bool) {
        guard hasFollowers else {
            presentGFAlertOnMainThread(
                title: "Zero means zero",
                message: "We can't be bothered to refresh the UI for 0 followers, sorry! 😤",
                buttonTitle: "Sad but true"
            )
            return
        }
        followersListDelegate?.didRequestFollowersList(for: username)
        dismiss(animated: true)
    }

}
