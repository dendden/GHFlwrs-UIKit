//
//  UserInfoVC.swift
//  GHFlwrs-UIKit
//
//  Created by Денис Трясунов on 02.05.2023.
//

import UIKit

/// The delegate protocol for ViewControllers listening to request from
/// ``UserInfoVC`` for updating followers list.
protocol UserInfoVCDelegate: AnyObject {

    /// Informs the delegate that ``UserInfoVC`` has received a request
    /// from ``GFFollowerItemVC`` to list followers for a new user.
    /// - Parameter username: The username of user whose followers must be listed.
    func didRequestFollowersList(for username: String)
}

/// A `ViewController` that presents detailed information about the user selected
/// from ``FollowersListVC`` collection.
class UserInfoVC: GFDataLoadingVC {

    // MARK: - Class variables

    var username: String!

    /// A delegate `ViewController` that receives the request to update followers list.
    weak var userInfoDelegate: UserInfoVCDelegate?

    // MARK: - View variables

    let headerView = UIView()
    let itemCardViewOne = UIView()
    let itemCardViewTwo = UIView()
    let dateLabel = GFSubtitleLabel(fontSize: 14, textAlignment: .center)

    var childViews: [UIView] = []

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        getUserInfo(for: username)
        layoutUI()
    }

    /// Configures background color, negates large title, creates and adds a `Done` button
    /// for dismiss action.
    private func configure() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }

    /// Dismisses this `ViewController` with animation.
    @objc private func dismissVC() {
        dismiss(animated: true)
    }

    /// Fetches user info with ``NetworkManager``.``NetworkManager/getUserInfo(for:)``
    /// method.
    ///
    /// If network request fails, this method presents a ``GFAlertVC`` with ``GFNetworkError`` description.
    /// - Parameter username: The username of user whose info must be fetched.
    private func getUserInfo(for username: String) {

        showLoadingProgressView()

        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                configureUIElementsWith(user: user)
                dismissLoadingProgressView()
            } catch {
                dismissLoadingProgressView()
                presentNetworkError(error) {
                    self.dismiss(animated: true)
                }
            }
        }

        /* Old way of performing network call (with completion handler + Result type): */
        /*NetworkManager.shared.getUserInfo(for: username) { [weak self] result in

            guard let self = self else { return }

            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.configureUIElementsWith(user: user)
                }
            case .failure(let failure):
                self.presentGFAlert(title: "Oops.. 🫣", message: failure.rawValue) {
                    self.dismiss(animated: true)
                }
            }
        }*/
    }

    /// Initializes `ViewControllers` for ``GFUserInfoHeaderVC`` and info cards for
    /// ``GFRepoItemVC`` and ``GFFollowerItemVC``, adding them as children to `self`,
    /// and populates the bottom ``dateLabel`` with the date when user joined GitHub.
    /// - Parameter user: A user whose information must be displayed.
    private func configureUIElementsWith(user: User) {

        let headerVC = GFUserInfoHeaderVC(user: user)
        let repoItemVC = GFRepoItemVC(user: user, delegate: self)
        let followerItemVC = GFFollowerItemVC(user: user, delegate: self)

        self.add(childVC: headerVC, to: self.headerView)
        self.add(childVC: repoItemVC, to: self.itemCardViewOne)
        self.add(childVC: followerItemVC, to: self.itemCardViewTwo)
        self.dateLabel.text = "GitHub since " + user.createdAt.shortMonthAndYear
    }

    /// Adds child subviews and activates their layout constraints.
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
            dateLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    /// Adds child `ViewControllers` to self and adds their views to provided `containerView`.
    /// - Parameters:
    ///   - childVC: A `ViewController` to add as a child to self.
    ///   - containerView: A view to which the child `ViewController`'s view should be added.
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}
// MARK: -

extension UserInfoVC: GFRepoItemVCDelegate, GFFollowerItemVCDelegate {

    func didTapGitHubAccount(with urlString: String) {

        guard let url = URL(string: urlString) else {
            presentGFAlert(
                title: "Broken link 🤬",
                message: "It looks like the link to \(username!)'s profile on GitHub is invalid."
            )
            return
        }

        presentSafariVC(with: url)
    }

    func didTapGetFollowers(hasFollowers: Bool) {
        guard hasFollowers else {
            presentGFAlert(
                title: "Zero means zero",
                message: "We can't be bothered to refresh the UI for 0 followers, sorry! 😤",
                buttonTitle: "Sad but true"
            )
            return
        }
        userInfoDelegate?.didRequestFollowersList(for: username)
        dismiss(animated: true)
    }

}
